import os
import json
from typing import List, Dict, Any
from openai import OpenAI
import structlog

from models import Task, Step, engine
from sqlmodel import Session, select

logger = structlog.get_logger()

TOOL_DEFS = [
    {
        "type": "function",
        "function": {
            "name": "suggest_detailed_steps",
            "description": "根据任务标题生成详细的步骤拆解",
            "parameters": {
                "type": "object",
                "properties": {
                    "task_title": {
                        "type": "string",
                        "description": "需要拆解的任务标题"
                    }
                },
                "required": ["task_title"]
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "estimate_total_duration",
            "description": "根据步骤列表计算总预估时间",
            "parameters": {
                "type": "object",
                "properties": {
                    "steps": {
                        "type": "array",
                        "items": {
                            "type": "object",
                            "properties": {
                                "content": {"type": "string"},
                                "estimate_minutes": {"type": "integer"}
                            }
                        },
                        "description": "步骤列表"
                    }
                },
                "required": ["steps"]
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "compose_task_summary",
            "description": "任务完成后生成总结",
            "parameters": {
                "type": "object",
                "properties": {
                    "task_id": {
                        "type": "string",
                        "description": "任务ID"
                    }
                },
                "required": ["task_id"]
            }
        }
    }
]

class AgentService:
    def __init__(self):
        self.client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

    def suggest_steps(self, task_title: str) -> List[Dict[str, Any]]:
        """使用GPT-4o-mini生成智能任务拆解步骤"""
        try:
            response = self.client.chat.completions.create(
                model="gpt-4o-mini",
                messages=[
                    {
                        "role": "system",
                        "content": "你是一个专业的任务管理专家。请根据用户提供的任务描述，智能地拆解成具体的、可执行的步骤。请用中文回复，每个步骤以'第X步：'开头，然后描述具体内容。步骤要具体、明确、可执行。"
                    },
                    {
                        "role": "user",
                        "content": f"请帮我拆解这个任务：{task_title}"
                    }
                ],
                temperature=0.7,
                max_tokens=1000
            )
            
            # 解析GPT返回的实际步骤
            ai_response = response.choices[0].message.content
            
            # 解析步骤内容
            steps = []
            lines = ai_response.strip().split('\n')
            
            step_count = 0
            for line in lines:
                line = line.strip()
                if line.startswith('第') and '步：' in line:
                    step_count += 1
                    content = line.split('步：', 1)[1].strip()
                    
                    # 根据步骤内容智能分配工具和主题
                    tool, theme, deliverable, estimate = self._intelligent_assignment(content, step_count)
                    
                    steps.append({
                        "content": content,
                        "tool": tool,
                        "theme": theme,
                        "deliverable": deliverable,
                        "estimate_minutes": estimate
                    })
            
            # 如果GPT没有返回步骤，使用备用方案
            if not steps:
                steps = self._fallback_steps(task_title)
            
            return steps
            
        except Exception as e:
            logger.error("Error generating steps", error=str(e))
            return self._fallback_steps(task_title)
    
    def _intelligent_assignment(self, content: str, step_num: int) -> tuple:
        """根据步骤内容智能分配工具、主题、交付物和时间"""
        content_lower = content.lower()
        
        # 工具匹配
        if any(word in content_lower for word in ['搜索', '查', '找', '调研', '了解']):
            tool = "浏览器/搜索引擎"
        elif any(word in content_lower for word in ['写', '文档', '报告', '记录']):
            tool = "文本编辑器"
        elif any(word in content_lower for word in ['代码', '编程', '开发', '实现']):
            tool = "IDE/代码编辑器"
        elif any(word in content_lower for word in ['测试', '验证', '检查']):
            tool = "测试工具"
        elif any(word in content_lower for word in ['安装', '配置', '设置']):
            tool = "系统工具"
        else:
            tool = "手动执行"
        
        # 主题匹配
        if step_num == 1:
            theme = "规划"
        elif any(word in content_lower for word in ['搜索', '查', '调研', '了解']):
            theme = "调研"
        elif any(word in content_lower for word in ['测试', '验证', '检查']):
            theme = "验证"
        else:
            theme = "执行"
        
        # 交付物匹配
        if any(word in content_lower for word in ['文档', '报告', '方案']):
            deliverable = "文档"
        elif any(word in content_lower for word in ['代码', '程序', '功能']):
            deliverable = "代码/功能"
        elif any(word in content_lower for word in ['测试', '验证']):
            deliverable = "测试结果"
        else:
            deliverable = "阶段性成果"
        
        # 时间估算
        if any(word in content_lower for word in ['简单', '快速', '初步']):
            estimate = 15
        elif any(word in content_lower for word in ['复杂', '详细', '深入']):
            estimate = 60
        else:
            estimate = 30
        
        return tool, theme, deliverable, estimate
    
    def _fallback_steps(self, task_title: str) -> List[Dict[str, Any]]:
        """备用步骤生成"""
        return [
            {
                "content": f"第一步：分析{task_title}的具体需求",
                "tool": "思考/记录",
                "theme": "规划",
                "deliverable": "需求分析",
                "estimate_minutes": 20
            },
            {
                "content": f"第二步：制定{task_title}的执行计划",
                "tool": "规划工具",
                "theme": "规划",
                "deliverable": "执行计划",
                "estimate_minutes": 15
            },
            {
                "content": f"第三步：开始执行{task_title}的核心内容",
                "tool": "相关工具",
                "theme": "执行",
                "deliverable": "核心成果",
                "estimate_minutes": 45
            },
            {
                "content": f"第四步：完成{task_title}并检查结果",
                "tool": "检查清单",
                "theme": "验证",
                "deliverable": "最终成果",
                "estimate_minutes": 20
            }
        ]

    def estimate_total_duration(self, steps: List[Dict[str, Any]]) -> int:
        """计算步骤总预估时间"""
        return sum(step.get("estimate_minutes", 0) for step in steps)

    def compose_summary(self, task_id: str) -> str:
        """生成任务完成总结"""
        with Session(engine) as session:
            from models import Task
            task = session.exec(select(Task).where(Task.id == task_id)).first()
            if not task:
                return "任务未找到"
            
            # 获取所有步骤
            steps = task.steps
            completed_steps = [s for s in steps if s.done]
            
            summary = f"# 🎯 任务完成总结\n\n"
            summary += f"**任务标题：** {task.title}\n\n"
            summary += f"**完成时间：** {task.completed_at.strftime('%Y-%m-%d %H:%M')}\n\n"
            summary += f"**总步骤数：** {len(steps)}\n"
            summary += f"**已完成步骤：** {len(completed_steps)}\n\n"
            
            if completed_steps:
                summary += "## ✅ 完成的步骤\n\n"
                for step in completed_steps:
                    summary += f"- {step.content}\n"
            
            summary += f"\n**总耗时：** {task.estimated_minutes} 分钟\n\n"
            summary += "🎉 恭喜完成任务！"
            
            return summary