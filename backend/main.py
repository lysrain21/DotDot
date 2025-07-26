import os
import asyncio
from pathlib import Path
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import structlog
from contextlib import asynccontextmanager

from models import create_db_and_tables
from api import tasks, summaries, achievements, websocket
from services.task import TaskService
from services.agent import AgentService
from services.summary import SummaryService

logger = structlog.get_logger()

@asynccontextmanager
async def lifespan(app: FastAPI):
    await create_db_and_tables()
    logger.info("Database initialized")
    yield

app = FastAPI(
    title="TaskAgent API",
    version="1.0.0",
    lifespan=lifespan
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(tasks.router, prefix="/api/v1/tasks", tags=["tasks"])
app.include_router(summaries.router, prefix="/api/v1", tags=["summaries"])
app.include_router(achievements.router, prefix="/api/v1/achievements", tags=["achievements"])
app.include_router(websocket.router, prefix="/ws")

@app.get("/api/v1/tools")
async def get_tools():
    from services.agent import TOOL_DEFS
    return TOOL_DEFS

@app.get("/health")
async def health_check():
    return {"status": "ok"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "main:app",
        host="127.0.0.1",
        port=8123,
        reload=True
    )