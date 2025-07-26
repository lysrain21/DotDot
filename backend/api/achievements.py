from typing import List
from fastapi import APIRouter, Query

from services.summary import SummaryService

router = APIRouter()

@router.get("/")
async def list_achievements(
    page: int = Query(1, ge=1),
    limit: int = Query(10, ge=1, le=100)
):
    """获取成就列表"""
    offset = (page - 1) * limit
    achievements = SummaryService.get_achievements(limit=limit, offset=offset)
    return [
        {
            "id": achievement.id,
            "date_key": achievement.date_key,
            "task_count": achievement.task_count,
            "step_count": achievement.step_count,
            "consumed_minutes": achievement.consumed_minutes,
            "summary_md": achievement.summary_md
        }
        for achievement in achievements
    ]

@router.get("/{achievement_id}")
async def get_achievement(achievement_id: str):
    """获取单个成就详情"""
    achievement = SummaryService.get_achievement(achievement_id)
    if not achievement:
        return {"error": "Achievement not found"}
    
    return {
        "id": achievement.id,
        "date_key": achievement.date_key,
        "task_count": achievement.task_count,
        "step_count": achievement.step_count,
        "consumed_minutes": achievement.consumed_minutes,
        "summary_md": achievement.summary_md
    }