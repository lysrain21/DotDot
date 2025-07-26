import asyncio
import json
import structlog
from typing import Dict, Set
from fastapi import WebSocket, WebSocketDisconnect
from uuid import UUID

logger = structlog.get_logger()

class ConnectionManager:
    def __init__(self):
        self.active_connections: Dict[str, Set[WebSocket]] = {}

    async def connect(self, websocket: WebSocket, client_id: str):
        await websocket.accept()
        if client_id not in self.active_connections:
            self.active_connections[client_id] = set()
        self.active_connections[client_id].add(websocket)
        logger.info("WebSocket connected", client_id=client_id)

    def disconnect(self, websocket: WebSocket, client_id: str):
        if client_id in self.active_connections:
            self.active_connections[client_id].discard(websocket)
            if not self.active_connections[client_id]:
                del self.active_connections[client_id]
        logger.info("WebSocket disconnected", client_id=client_id)

    async def send_personal_message(self, message: dict, client_id: str):
        if client_id in self.active_connections:
            disconnected = []
            for connection in self.active_connections[client_id]:
                try:
                    await connection.send_text(json.dumps(message))
                except Exception as e:
                    logger.error("Failed to send message", error=str(e))
                    disconnected.append(connection)
            
            # Clean up disconnected connections
            for conn in disconnected:
                self.disconnect(conn, client_id)

    async def broadcast(self, message: dict, exclude_client: str = None):
        for client_id, connections in self.active_connections.items():
            if client_id != exclude_client:
                for connection in connections:
                    try:
                        await connection.send_text(json.dumps(message))
                    except Exception as e:
                        logger.error("Failed to broadcast", error=str(e))

manager = ConnectionManager()

async def notify_step_update(task_id: str, step_id: str, done: bool):
    """通知步骤状态更新"""
    message = {
        "type": "step_update",
        "task_id": task_id,
        "step_id": step_id,
        "done": done,
        "timestamp": str(asyncio.get_event_loop().time())
    }
    await manager.broadcast(message)

async def notify_task_complete(task_id: str, summary: str):
    """通知任务完成"""
    message = {
        "type": "task_complete",
        "task_id": task_id,
        "summary": summary,
        "timestamp": str(asyncio.get_event_loop().time())
    }
    await manager.broadcast(message)