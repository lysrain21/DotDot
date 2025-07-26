from datetime import datetime
from typing import List, Optional
from uuid import UUID
from pydantic import BaseModel

class StepCreate(BaseModel):
    content: str
    tool: Optional[str] = None
    theme: Optional[str] = None
    deliverable: Optional[str] = None
    estimate_minutes: int = 0
    order_idx: int = 0

class StepResponse(BaseModel):
    id: UUID
    task_id: UUID
    content: str
    tool: Optional[str] = None
    theme: Optional[str] = None
    deliverable: Optional[str] = None
    estimate_minutes: int
    done: bool
    order_idx: int

class TaskCreate(BaseModel):
    title: str

class TaskResponse(BaseModel):
    id: UUID
    title: str
    estimated_minutes: int
    created_at: datetime
    completed_at: Optional[datetime] = None
    steps: List[StepResponse] = []

class TaskUpdate(BaseModel):
    title: Optional[str] = None

class StepUpdate(BaseModel):
    done: Optional[bool] = None
    content: Optional[str] = None

class SummaryResponse(BaseModel):
    summary_markdown: str

class AchievementResponse(BaseModel):
    id: UUID
    date_key: str
    task_count: int
    step_count: int
    consumed_minutes: int
    summary_md: str