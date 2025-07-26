# TaskAgent - AI智能任务拆解助手 🤖

## 项目名称
**TaskAgent** - AI驱动的智能任务管理与分解系统

## 项目描述

TaskAgent是一个革命性的AI任务管理应用，通过先进的自然语言处理技术，将用户输入的复杂任务自动分解为具体可执行的步骤。它解决了传统待办事项应用"只记录不指导"的核心痛点，让每一项任务都有清晰的执行路线图。

### 核心功能
- **🤖 AI智能分解**：基于GPT-4o-mini，将任意任务分解为9步以内详细计划
- **🎨 像素级完美UI**：400×600分辨率，Dribbble级别的精致像素艺术设计
- **📱 跨平台支持**：Flutter构建，支持macOS、Windows、iOS、Android
- **⚡ 实时同步**：WebSocket实时更新任务状态和进度
- **🏆 成就系统**：emoji驱动的成就日历，记录每日生产力
- **🎯 专注模式**：单任务专注界面，避免信息过载

## 以太坊生态集成

虽然当前版本专注于AI任务管理，但项目已构建完整的Web3集成架构：

### 已规划的以太坊集成
- **智能合约验证**：Solidity智能合约验证任务完成真实性
- **NFT成就系统**：将任务完成记录铸造为ERC-721 NFT徽章
- **Token激励机制**：ERC-20代币奖励高生产力用户
- **去中心化存储**：IPFS存储任务历史和成就数据
- **DAO治理**：社区共同维护任务模板库

### 技术准备
- Web3钱包连接接口已预留
- 智能合约ABI标准已定义
- 链上数据结构设计完成

## 技术栈

### 前端技术栈
- **Flutter 3.19+** - 跨平台UI框架
- **Dart 3.0+** - 开发语言
- **flutter_bloc 8.x** - 状态管理
- **dio 5.x** - HTTP客户端
- **macos_ui** - macOS原生风格组件
- **equatable** - 数据模型不可变性

### 后端技术栈
- **FastAPI 0.104+** - Python高性能异步Web框架
- **SQLModel 0.0.14** - Python ORM (基于SQLAlchemy)
- **SQLite** - 轻量级数据库(生产环境可迁移PostgreSQL)
- **OpenAI GPT-4o-mini** - AI任务分解引擎
- **Uvicorn** - ASGI服务器
- **WebSockets** - 实时双向通信

### 开发工具
- **VS Code** - 主要IDE
- **Flutter DevTools** - 性能分析
- **Postman** - API测试
- **Git** - 版本控制

## 安装与运行指南

### 系统要求
- **Flutter**: 3.19.0 或更高版本
- **Dart**: 3.0.0 或更高版本  
- **Python**: 3.8 或更高版本
- **操作系统**: macOS 11+ / Windows 10+ / Linux Ubuntu 20.04+

### 快速开始

#### 1. 克隆项目
```bash
git clone https://github.com/yourusername/taskagent.git
cd taskagent
```

#### 2. 启动后端服务
```bash
# 进入后端目录
cd backend

# 创建虚拟环境
python -m venv venv

# 激活虚拟环境
# macOS/Linux:
source venv/bin/activate
# Windows:
venv\Scripts\activate

# 安装依赖
pip install -r requirements.txt

# 设置环境变量
cp .env.example .env
# 编辑.env文件，添加OpenAI API密钥

# 启动服务器
python -m uvicorn main:app --reload --port 8000
```

#### 3. 启动前端应用
```bash
# 新终端，进入Flutter目录
cd ../task_agent_flutter

# 获取依赖
flutter pub get

# 运行应用
flutter run -d macos  # macOS
flutter run -d windows  # Windows
flutter run  # 自动选择可用设备
```

### 环境配置

#### 必需的环境变量
在`backend/.env`文件中配置：
```
OPENAI_API_KEY=sk-your-openai-api-key-here
DATABASE_URL=sqlite:///./taskagent.db
DEBUG=True
CORS_ORIGINS=["http://localhost:8000", "http://127.0.0.1:8000"]
```

#### 可选配置
```
# Web3集成预留
INFURA_PROJECT_ID=your-infura-id
WALLET_PRIVATE_KEY=your-wallet-private-key
NFT_CONTRACT_ADDRESS=0x...
TOKEN_CONTRACT_ADDRESS=0x...
```

## 项目亮点/创新点

### 🎯 设计创新
- **像素级完美还原**：每个UI元素都精确到像素，400×600固定分辨率
- **复古像素美学**：融合现代功能与8-bit像素艺术风格
- **响应式微交互**：按钮点击、任务完成都有像素级动画反馈

### 🤖 AI技术创新
- **中文语境优化**：针对中文任务描述进行特别优化
- **动态步骤调整**：根据用户完成情况实时调整后续步骤
- **上下文记忆**：AI记住用户习惯，提供个性化任务分解
- **🛠️ 可配置工具系统**：用户可自定义AI工具集，生成更个性化的任务拆解方案

### 🏗️ 架构创新
- **模块化设计**：前后端完全分离，便于未来Web3扩展
- **实时同步**：WebSocket实现毫秒级数据同步
- **插件化AI引擎**：支持未来接入更多AI模型

### 🌐 Web3就绪架构
- **预留智能合约接口**：所有数据模型都考虑链上存储需求
- **NFT标准化**：成就徽章符合ERC-721标准
- **DAO治理准备**：任务模板库支持社区治理模式

## 未来发展计划

### 第一阶段：功能完善 (1-2个月)
- [ ] 任务分类和标签系统
- [ ] 任务模板市场
- [ ] 重复任务设置
- [ ] 数据导出功能

### 第二阶段：Web3集成 (2-4个月)
- [ ] MetaMask钱包连接
- [ ] 任务完成NFT铸造
- [ ] ERC-20代币奖励系统
- [ ] IPFS数据存储

### 第三阶段：社区功能 (4-6个月)
- [ ] 任务分享和协作
- [ ] 社区任务模板库
- [ ] DAO治理投票
- [ ] 去中心化身份验证

### 长期愿景 (6-12个月)
- [ ] 跨链任务管理
- [ ] AI模型市场
- [ ] 任务赏金平台
- [ ] 全球生产力DAO

## API文档

### 核心端点
```
GET    /api/v1/tasks/          # 获取任务列表
POST   /api/v1/tasks/          # 创建新任务
GET    /api/v1/tasks/{id}      # 获取任务详情
PATCH  /api/v1/tasks/{id}      # 更新任务状态
DELETE /api/v1/tasks/{id}      # 删除任务

POST   /api/v1/tasks/{id}/ai-decompose  # AI任务分解
```

### WebSocket事件
```
task_created     # 新任务创建
task_updated     # 任务状态更新
step_completed   # 步骤完成
achievement_unlocked # 成就解锁
```

## 贡献指南

我们欢迎所有形式的贡献！

### 如何贡献
1. Fork项目仓库
2. 创建功能分支：`git checkout -b feature/amazing-feature`
3. 提交更改：`git commit -m 'Add amazing feature'`
4. 推送到分支：`git push origin feature/amazing-feature`
5. 创建Pull Request

### 开发规范
- 遵循Flutter官方样式指南
- 所有PR需要通过CI测试
- 代码覆盖率需保持在80%以上
- 提交信息使用英文

## 许可证

本项目采用MIT许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 联系与社区

- **项目主页**: https://taskagent.ai
- **GitHub**: https://github.com/yourusername/taskagent
- **Discord社区**: https://discord.gg/taskagent
- **Twitter**: [@taskagent_ai](https://twitter.com/taskagent_ai)
- **邮件**: hello@taskagent.ai

---

**让AI成为你高效生活的得力助手！** 🚀

*Built with ❤️ by the TaskAgent team*