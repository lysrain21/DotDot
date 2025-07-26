from typing import List, Optional, Dict, Any
from uuid import UUID
from sqlmodel import Session, select
from datetime import datetime

from models import Task, Step, engine
from schemas import TaskCreate, TaskUpdate, StepUpdate
from services.agent import AgentService

class TaskService:
    @staticmethod
    def create(title: str) -> Dict[str, Any]:
        with Session(engine) as session:
            # Create skeleton task
            task = Task(title=title)
            session.add(task)
            session.commit()
            session.refresh(task)
            
            # Auto-decompose with Agent
            agent = AgentService()
            steps_data = agent.suggest_steps(title)
            total_minutes = agent.estimate_total_duration(steps_data)
            
            # Update task with estimated time
            task.estimated_minutes = total_minutes
            session.add(task)
            
            # Create steps
            for idx, step_data in enumerate(steps_data):
                step = Step(
                    task_id=task.id,
                    content=step_data["content"],
                    tool=step_data.get("tool"),
                    theme=step_data.get("theme"),
                    deliverable=step_data.get("deliverable"),
                    estimate_minutes=step_data["estimate_minutes"],
                    order_idx=idx
                )
                session.add(step)
            
            session.commit()
            session.refresh(task)
            
            # Load steps
            steps = session.exec(
                select(Step).where(Step.task_id == task.id).order_by(Step.order_idx)
            ).all()
            
            # Return dict with steps
            return {
                'id': str(task.id),
                'title': task.title,
                'estimated_minutes': task.estimated_minutes,
                'created_at': task.created_at.isoformat(),
                'completed_at': task.completed_at.isoformat() if task.completed_at else None,
                'steps': [
                    {
                        'id': str(step.id),
                        'task_id': str(step.task_id),
                        'content': step.content,
                        'tool': step.tool,
                        'theme': step.theme,
                        'deliverable': step.deliverable,
                        'estimate_minutes': step.estimate_minutes,
                        'done': step.done,
                        'order_idx': step.order_idx
                    }
                    for step in steps
                ]
            }

    @staticmethod
    def get(task_id: UUID) -> Optional[Task]:
        with Session(engine) as session:
            statement = select(Task).where(Task.id == task_id)
            return session.exec(statement).first()

    @staticmethod
    def get_all() -> List[Dict[str, Any]]:
        with Session(engine) as session:
            tasks = session.exec(
                select(Task).order_by(Task.created_at.desc())
            ).all()
            
            result = []
            for task in tasks:
                steps = session.exec(
                    select(Step).where(Step.task_id == task.id).order_by(Step.order_idx)
                ).all()
                
                task_dict = {
                    'id': str(task.id),
                    'title': task.title,
                    'estimated_minutes': task.estimated_minutes,
                    'created_at': task.created_at.isoformat(),
                    'completed_at': task.completed_at.isoformat() if task.completed_at else None,
                    'steps': []
                }
                
                for step in steps:
                    task_dict['steps'].append({
                        'id': str(step.id),
                        'task_id': str(step.task_id),
                        'content': step.content,
                        'tool': step.tool,
                        'theme': step.theme,
                        'deliverable': step.deliverable,
                        'estimate_minutes': step.estimate_minutes,
                        'done': step.done,
                        'order_idx': step.order_idx
                    })
                
                result.append(task_dict)
            
            return result

    @staticmethod
    def update(task_id: UUID, update_data: TaskUpdate) -> Optional[Task]:
        with Session(engine) as session:
            statement = select(Task).where(Task.id == task_id)
            task = session.exec(statement).first()
            if not task:
                return None
            
            if update_data.title is not None:
                task.title = update_data.title
            
            session.add(task)
            session.commit()
            session.refresh(task)
            return task

    @staticmethod
    def mark_step_done(step_id: UUID, done: bool = True) -> Optional[Step]:
        with Session(engine) as session:
            statement = select(Step).where(Step.id == step_id)
            step = session.exec(statement).first()
            if not step:
                return None
            
            step.done = done
            session.add(step)
            session.commit()
            session.refresh(step)
            return step

    @staticmethod
    def update_step(step_id: UUID, update_data: StepUpdate) -> Optional[Step]:
        with Session(engine) as session:
            # Convert UUID to hex string format (without hyphens) for database comparison
            step_id_hex = str(step_id).replace('-', '')
            statement = select(Step).where(Step.id == step_id_hex)
            step = session.exec(statement).first()
            if not step:
                return None
            
            if update_data.done is not None:
                step.done = update_data.done
            if update_data.content is not None:
                step.content = update_data.content
            
            session.add(step)
            session.commit()
            session.refresh(step)
            return step

    @staticmethod
    def complete(task_id: UUID) -> Optional[Task]:
        with Session(engine) as session:
            statement = select(Task).where(Task.id == task_id)
            task = session.exec(statement).first()
            if not task:
                return None
            
            task.completed_at = datetime.utcnow()
            session.add(task)
            session.commit()
            session.refresh(task)
            return task

    @staticmethod
    def get_incomplete_tasks() -> List[Dict[str, Any]]:
        with Session(engine) as session:
            tasks = session.exec(
                select(Task).where(Task.completed_at == None).order_by(Task.created_at.desc())
            ).all()
            
            result = []
            for task in tasks:
                steps = session.exec(
                    select(Step).where(Step.task_id == task.id).order_by(Step.order_idx)
                ).all()
                
                task_dict = {
                    'id': str(task.id),
                    'title': task.title,
                    'estimated_minutes': task.estimated_minutes,
                    'created_at': task.created_at.isoformat(),
                    'completed_at': task.completed_at.isoformat() if task.completed_at else None,
                    'steps': []
                }
                
                for step in steps:
                    task_dict['steps'].append({
                        'id': str(step.id),
                        'task_id': str(step.task_id),
                        'content': step.content,
                        'tool': step.tool,
                        'theme': step.theme,
                        'deliverable': step.deliverable,
                        'estimate_minutes': step.estimate_minutes,
                        'done': step.done,
                        'order_idx': step.order_idx
                    })
                
                result.append(task_dict)
            
            return result