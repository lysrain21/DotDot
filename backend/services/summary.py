from datetime import datetime, date
from typing import List, Optional
from sqlmodel import Session, select
from models import Achievement, Task, Step, engine

class SummaryService:
    @staticmethod
    def daily(date_key: str) -> str:
        """获取指定日期的总结"""
        with Session(engine) as session:
            # 查找指定日期的成就记录
            statement = select(Achievement).where(Achievement.date_key == date_key)
            achievement = session.exec(statement).first()
            
            if achievement:
                return achievement.summary_md
            
            # 如果没有成就记录，生成新的总结
            target_date = datetime.strptime(date_key, "%Y-%m-%d").date()
            start_dt = datetime.combine(target_date, datetime.min.time())
            end_dt = datetime.combine(target_date, datetime.max.time())
            
            # 查找当天完成的任务
            tasks = session.exec(
                select(Task).where(
                    Task.completed_at >= start_dt,
                    Task.completed_at <= end_dt
                )
            ).all()
            
            if not tasks:
                return f"# 📅 {date_key} 总结\n\n今天还没有完成的任务。"
            
            # 计算统计数据
            total_tasks = len(tasks)
            total_steps = 0
            total_minutes = 0
            
            summary = f"# 📅 {date_key} 任务总结\n\n"
            summary += f"**今日完成任务：** {total_tasks} 个\n\n"
            
            for task in tasks:
                task_steps = session.exec(select(Step).where(Step.task_id == task.id)).all()
                completed_steps = [s for s in task_steps if s.done]
                
                total_steps += len(completed_steps)
                total_minutes += task.estimated_minutes
                
                summary += f"## 🎯 {task.title}\n"
                summary += f"- 完成步骤：{len(completed_steps)}/{len(task_steps)}\n"
                summary += f"- 预估时间：{task.estimated_minutes} 分钟\n\n"
            
            summary += f"---\n\n"
            summary += f"**总计：**\n"
            summary += f"- 完成任务：{total_tasks} 个\n"
            summary += f"- 完成步骤：{total_steps} 个\n"
            summary += f"- 总耗时：{total_minutes} 分钟\n\n"
            summary += "🎉 今天表现很棒！"
            
            return summary

    @staticmethod
    def save(task_id: str, summary_md: str) -> Achievement:
        """保存任务总结到成就"""
        with Session(engine) as session:
            # 获取任务信息
            task = session.exec(select(Task).where(Task.id == task_id)).first()
            if not task:
                raise ValueError("Task not found")
            
            # 获取日期键
            date_key = task.completed_at.strftime("%Y-%m-%d") if task.completed_at else datetime.now().strftime("%Y-%m-%d")
            
            # 查找或创建成就记录
            statement = select(Achievement).where(Achievement.date_key == date_key)
            achievement = session.exec(statement).first()
            
            # 计算当天统计数据
            target_date = datetime.strptime(date_key, "%Y-%m-%d").date()
            start_dt = datetime.combine(target_date, datetime.min.time())
            end_dt = datetime.combine(target_date, datetime.max.time())
            
            tasks = session.exec(
                select(Task).where(
                    Task.completed_at >= start_dt,
                    Task.completed_at <= end_dt
                )
            ).all()
            
            total_tasks = len(tasks)
            total_steps = 0
            total_minutes = 0
            
            for t in tasks:
                task_steps = session.exec(select(Step).where(Step.task_id == t.id)).all()
                completed_steps = [s for s in task_steps if s.done]
                total_steps += len(completed_steps)
                total_minutes += t.estimated_minutes
            
            if achievement:
                achievement.task_count = total_tasks
                achievement.step_count = total_steps
                achievement.consumed_minutes = total_minutes
                achievement.summary_md = SummaryService.daily(date_key)
            else:
                achievement = Achievement(
                    date_key=date_key,
                    task_count=total_tasks,
                    step_count=total_steps,
                    consumed_minutes=total_minutes,
                    summary_md=SummaryService.daily(date_key)
                )
            
            session.add(achievement)
            session.commit()
            session.refresh(achievement)
            return achievement

    @staticmethod
    def rollup(date_key: str) -> Achievement:
        """生成指定日期的成就汇总"""
        return SummaryService.save("", date_key)

    @staticmethod
    def get_achievements(limit: int = 10, offset: int = 0) -> List[Achievement]:
        """获取成就列表"""
        with Session(engine) as session:
            statement = select(Achievement).order_by(Achievement.date_key.desc()).limit(limit).offset(offset)
            return list(session.exec(statement))

    @staticmethod
    def get_achievement(achievement_id: str) -> Optional[Achievement]:
        """获取单个成就"""
        with Session(engine) as session:
            statement = select(Achievement).where(Achievement.id == achievement_id)
            return session.exec(statement).first()