from datetime import datetime
from fastapi import APIRouter, Query

from services.summary import SummaryService

router = APIRouter()

@router.get("/summary/today")
async def get_today_summary():
    """获取今日总结"""
    today = datetime.now().strftime("%Y-%m-%d")
    summary = SummaryService.daily(today)
    return {"summary_markdown": summary}

@router.get("/summary/{date}")
async def get_date_summary(date: str):
    """获取指定日期总结"""
    try:
        # Validate date format
        from datetime import datetime
        datetime.strptime(date, "%Y-%m-%d")
        
        summary = SummaryService.daily(date)
        return {"summary_markdown": summary}
    except ValueError:
        return {"error": "Invalid date format. Use YYYY-MM-DD"}