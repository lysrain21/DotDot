from typing import List, Dict, Any
from uuid import UUID
from fastapi import APIRouter, HTTPException

from services.task import TaskService
from services.agent import AgentService
from services.summary import SummaryService
from schemas import TaskCreate, TaskUpdate, StepUpdate, TaskResponse

router = APIRouter()

@router.post("/")
async def create_task(task: TaskCreate):
    """创建新任务并自动拆解"""
    try:
        return TaskService.create(task.title)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/")
async def list_tasks():
    """获取所有未完成的任务"""
    return TaskService.get_incomplete_tasks()

@router.get("/{task_id}", response_model=TaskResponse)
async def get_task(task_id: UUID):
    """获取单个任务详情"""
    task = TaskService.get(task_id)
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    
    return TaskResponse(
        id=task.id,
        title=task.title,
        estimated_minutes=task.estimated_minutes,
        created_at=task.created_at,
        completed_at=task.completed_at,
        steps=[
            {
                "id": step.id,
                "task_id": step.task_id,
                "content": step.content,
                "tool": step.tool,
                "theme": step.theme,
                "deliverable": step.deliverable,
                "estimate_minutes": step.estimate_minutes,
                "done": step.done,
                "order_idx": step.order_idx
            }
            for step in task.steps
        ]
    )

@router.patch("/{task_id}", response_model=TaskResponse)
async def update_task(task_id: UUID, task_update: TaskUpdate):
    """更新任务信息"""
    task = TaskService.update(task_id, task_update)
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    
    return TaskResponse(
        id=task.id,
        title=task.title,
        estimated_minutes=task.estimated_minutes,
        created_at=task.created_at,
        completed_at=task.completed_at,
        steps=[
            {
                "id": step.id,
                "task_id": step.task_id,
                "content": step.content,
                "tool": step.tool,
                "theme": step.theme,
                "deliverable": step.deliverable,
                "estimate_minutes": step.estimate_minutes,
                "done": step.done,
                "order_idx": step.order_idx
            }
            for step in task.steps
        ]
    )

@router.patch("/steps/{step_id}")
async def update_step(step_id: UUID, step_update: StepUpdate):
    """更新步骤状态或内容"""
    step = TaskService.update_step(step_id, step_update)
    if not step:
        raise HTTPException(status_code=404, detail="Step not found")
    
    return {
        "id": step.id,
        "task_id": step.task_id,
        "content": step.content,
        "tool": step.tool,
        "theme": step.theme,
        "deliverable": step.deliverable,
        "estimate_minutes": step.estimate_minutes,
        "done": step.done,
        "order_idx": step.order_idx
    }

@router.post("/{task_id}/complete")
async def complete_task(task_id: UUID):
    """完成任务并生成总结"""
    task = TaskService.complete(task_id)
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    
    # 生成总结
    agent = AgentService()
    summary = agent.compose_summary(str(task_id))
    
    # 保存到成就
    achievement = SummaryService.save(str(task_id), summary)
    
    return {"summary_markdown": summary}