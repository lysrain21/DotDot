from datetime import datetime
from typing import List, Optional
from uuid import UUID, uuid4
from sqlmodel import SQLModel, Field, Relationship
from sqlalchemy import Column, DateTime

class Task(SQLModel, table=True):
    __tablename__ = "tasks"
    
    id: UUID = Field(default_factory=uuid4, primary_key=True)
    title: str = Field(max_length=255)
    estimated_minutes: int = Field(default=0)
    created_at: datetime = Field(default_factory=datetime.utcnow)
    completed_at: Optional[datetime] = Field(default=None)
    
    steps: List["Step"] = Relationship(back_populates="task")

class Step(SQLModel, table=True):
    __tablename__ = "steps"
    
    id: UUID = Field(default_factory=uuid4, primary_key=True)
    task_id: UUID = Field(foreign_key="tasks.id")
    content: str = Field(max_length=500)
    tool: Optional[str] = Field(default=None, max_length=100)
    theme: Optional[str] = Field(default=None, max_length=100)
    deliverable: Optional[str] = Field(default=None, max_length=255)
    estimate_minutes: int = Field(default=0)
    done: bool = Field(default=False)
    order_idx: int = Field(default=0)
    
    task: Task = Relationship(back_populates="steps")

class Achievement(SQLModel, table=True):
    __tablename__ = "achievements"
    
    id: UUID = Field(default_factory=uuid4, primary_key=True)
    date_key: str = Field(max_length=10, unique=True)  # YYYY-MM-DD
    task_count: int = Field(default=0)
    step_count: int = Field(default=0)
    consumed_minutes: int = Field(default=0)
    summary_md: str = Field(default="")

from sqlmodel import create_engine
from pathlib import Path

DATABASE_URL = "sqlite:///~/Library/Application Support/TaskAgent/task.db"

def get_engine():
    db_path = Path.home() / "Library/Application Support/TaskAgent"
    db_path.mkdir(parents=True, exist_ok=True)
    db_file = db_path / "task.db"
    return create_engine(f"sqlite:///{db_file}")

engine = get_engine()

async def create_db_and_tables():
    SQLModel.metadata.create_all(engine)