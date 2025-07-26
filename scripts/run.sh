#!/bin/bash

# TaskAgent 启动脚本
# 一键启动后端和前端

set -e

echo "🚀 启动 TaskAgent..."

# 检查后端是否已在运行
if pgrep -f "python3 main.py" > /dev/null; then
    echo "✅ 后端已在运行"
else
    echo "🔄 启动后端服务..."
    cd /Users/yushenli/Documents/my_code/Commit/backend
    nohup python3 main.py > backend.log 2>&1 &
    sleep 3
    echo "✅ 后端已启动 (端口: 8123)"
fi

# 检查前端是否已在运行
if pgrep -f "task_agent_flutter" > /dev/null; then
    echo "✅ 前端已在运行"
else
    echo "🔄 启动前端应用..."
    cd /Users/yushenli/Documents/my_code/Commit/task_agent_flutter
    
    # 检查是否已构建
    if [ -f "build/macos/Build/Products/Release/task_agent_flutter.app" ]; then
        echo "📱 打开已构建的应用..."
        open build/macos/Build/Products/Release/task_agent_flutter.app
    else
        echo "🔄 构建并运行开发版本..."
        flutter run -d macos --release &
        sleep 5
    fi
fi

echo ""
echo "🎉 TaskAgent 已启动！"
echo "📋 后端: http://127.0.0.1:8123/docs"
echo "📱 前端: 请在Launchpad或Applications中查找 'task_agent_flutter'"
echo ""
echo "💡 使用说明:"
echo "   - 点击 '+' 创建新任务"
echo "   - AI会自动分解任务为步骤"
echo "   - 勾选完成步骤"
echo ""

# 等待用户按键
read -p "按任意键继续..." -n 1 -r