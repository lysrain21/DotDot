# TaskAgent - AI-Powered Task Management for macOS

A native macOS menu-bar application that uses AI to automatically break down tasks into manageable steps and track your daily productivity.

## 🚀 Quick Start

### Prerequisites
- Python 3.11+
- Flutter 3.24+
- macOS 12.0+

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/task-agent.git
   cd task-agent
   ```

2. **Set up the backend**
   ```bash
   cd backend
   python -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```

3. **Set up OpenAI API key**
   ```bash
   export OPENAI_API_KEY="your-api-key-here"
   ```

4. **Run the backend**
   ```bash
   python main.py
   ```

5. **Set up Flutter frontend**
   ```bash
   cd task_agent_flutter
   flutter pub get
   flutter run -d macos
   ```

## 📦 Building for Distribution

### Automated Build
```bash
# Build everything
./scripts/build.sh

# Create DMG package
./scripts/package.sh
```

### Manual Build
1. **Build Python backend**
   ```bash
   cd backend
   pyinstaller --onefile main.py -n taskagentd
   ```

2. **Build Flutter app**
   ```bash
   cd task_agent_flutter
   flutter build macos --release
   ```

3. **Package together**
   Copy `taskagentd` to `task_agent_flutter/build/macos/Build/Products/Release/Task Agent.app/Contents/MacOS/`

## 🏗️ Architecture

### Backend (Python/FastAPI)
- **API Server**: FastAPI with REST endpoints
- **Database**: SQLite with SQLModel ORM
- **AI Integration**: OpenAI GPT-4o-mini for task decomposition
- **WebSocket**: Real-time updates for step progress

### Frontend (Flutter)
- **UI Framework**: macos_ui for native macOS look
- **State Management**: flutter_bloc pattern
- **HTTP Client**: dio for API communication
- **WebSocket**: web_socket_channel for real-time updates

## 🔧 API Endpoints

### Tasks
- `POST /api/v1/tasks` - Create task with AI decomposition
- `GET /api/v1/tasks` - List all active tasks
- `PATCH /api/v1/tasks/{id}/steps/{step_id}` - Update step status
- `POST /api/v1/tasks/{id}/complete` - Complete task and get summary

### Summaries
- `GET /api/v1/summary/today` - Get today's summary
- `GET /api/v1/summary/{date}` - Get specific date summary

### Achievements
- `GET /api/v1/achievements` - List daily achievements
- `GET /api/v1/achievements/{id}` - Get specific achievement

### WebSocket
- `ws://localhost:8123/ws/progress` - Real-time step updates

## 📊 Data Model

### Task
- `id`: UUID primary key
- `title`: Task title
- `estimated_minutes`: Total estimated time
- `created_at`: Creation timestamp
- `completed_at`: Completion timestamp
- `steps`: List of task steps

### Step
- `id`: UUID primary key
- `task_id`: Foreign key to Task
- `content`: Step description
- `tool`: Recommended tool
- `theme`: Step category
- `deliverable`: Expected output
- `estimate_minutes`: Time estimate
- `done`: Completion status
- `order_idx`: Step order

### Achievement
- `id`: UUID primary key
- `date_key`: Date identifier (YYYY-MM-DD)
- `task_count`: Number of completed tasks
- `step_count`: Number of completed steps
- `consumed_minutes`: Total time spent
- `summary_md`: Markdown summary

## 🧪 Testing

### Backend Tests
```bash
cd backend
pytest tests/ -v
```

### Flutter Tests
```bash
cd task_agent_flutter
flutter test
```

## 🛠️ Development

### Backend Development
```bash
cd backend
uvicorn main:app --reload --host 127.0.0.1 --port 8123
```

### Flutter Development
```bash
cd task_agent_flutter
flutter run -d macos
```

## 🔄 CI/CD

The project uses GitHub Actions for:
- Automated testing (Python + Flutter)
- Backend building with PyInstaller
- Flutter macOS builds
- DMG creation and artifact uploads

## 📋 Roadmap

- [ ] iCloud sync support
- [ ] Natural language progress updates
- [ ] Badge system and social sharing
- [ ] Offline local LLM fallback
- [ ] Custom task templates
- [ ] Advanced analytics dashboard

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

MIT License - see LICENSE file for details