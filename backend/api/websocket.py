from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from websocket_manager import manager

router = APIRouter()

@router.websocket("/ws/progress")
async def websocket_endpoint(websocket: WebSocket):
    client_id = str(websocket.client)
    await manager.connect(websocket, client_id)
    try:
        while True:
            data = await websocket.receive_text()
            # Handle incoming messages if needed
            pass
    except WebSocketDisconnect:
        manager.disconnect(websocket, client_id)