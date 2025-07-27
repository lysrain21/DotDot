import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_agent_flutter/services/ai_config_service.dart';
import 'package:task_agent_flutter/models/ai_config.dart';

class ConfigToolPage extends StatefulWidget {
  const ConfigToolPage({Key? key}) : super(key: key);

  @override
  State<ConfigToolPage> createState() => _ConfigToolPageState();
}

class _ConfigToolPageState extends State<ConfigToolPage> {
  // Configuration state
  final TextEditingController _contextController = TextEditingController();
  final TextEditingController _toolsController = TextEditingController();
  final TextEditingController _constraintsController = TextEditingController();
  
  // Tool presets
  final List<String> _selectedTools = [];
  final List<String> _availableTools = [
    '📝 文本分析器',
    '🔍 研究助手',
    '⏰ 时间管理器',
    '📊 数据分析器',
    '💡 创意生成器',
    '🎯 目标分解器',
    '📋 清单生成器',
    '🔧 技术顾问',
  ];

  @override
  void dispose() {
    _contextController.dispose();
    _toolsController.dispose();
    _constraintsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: SizedBox(
          width: 400,
          height: 600,
          child: Stack(
            children: [
              // Pixel decorations
              _buildPixelDecorations(),
              
              // Main content
              _buildMainContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPixelDecorations() {
    return Stack(
      children: [
        // Left decoration group - Group 54
        Positioned(left: 41.28, top: 74.08, child: _pixelBox(58.49, 24.95, Colors.white)),
        Positioned(left: 0.73, top: 24.95, child: _pixelBox(108.39, 24.95, Colors.white)),
        Positioned(left: 21, top: 50, child: _pixelBox(115, 24, Colors.white)),
        Positioned(left: 136, top: 25, child: _pixelBox(24.95, 24.95, Colors.white)),
        Positioned(left: -25, top: 49.13, child: _pixelBox(24.95, 24.95, Colors.white)),
        Positioned(left: 41.28, top: 0, child: _pixelBox(24.95, 24.95, Colors.white)),
        
        // Right decoration group - Group 55
        Positioned(left: 318, top: 104.95, child: _pixelBox(108.39, 24.95, Colors.white)),
        Positioned(left: 343.73, top: 129.91, child: _pixelBox(108.39, 24.17, Colors.white)),
        Positioned(left: 318, top: 104.95, child: _pixelBox(24.95, 24.95, Colors.white)),
        Positioned(left: 406.9, top: 80, child: _pixelBox(24.95, 24.95, Colors.white)),
        Positioned(left: 373.37, top: 154.08, child: _pixelBox(58.49, 24.95, Colors.white)),
        Positioned(left: 473.18, top: 129.13, child: _pixelBox(24.95, 24.95, Colors.white)),
      ],
    );
  }

  Widget _buildMainContent() {
    return Stack(
      children: [
        // Header
        Positioned(
          left: 57,
          top: 40,
          child: const Text(
            'AI配置工具',
            style: TextStyle(
              fontFamily: 'Source Han Sans CN',
              fontSize: 24,
              fontWeight: FontWeight.w400,
              height: 36 / 24,
              color: Color(0xFF2D2D2D),
            ),
          ),
        ),
        
        // Subtitle
        Positioned(
          left: 57,
          top: 70,
          child: const Text(
            '自定义AI任务拆解助手',
            style: TextStyle(
              fontFamily: 'Source Han Sans CN',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 21 / 14,
              color: Color(0xFF666666),
            ),
          ),
        ),
        
        // Context input - Group 49 style
        Positioned(
          left: 57,
          top: 110,
          child: _buildConfigSection(
            '任务上下文',
            '描述你的任务背景和环境...',
            _contextController,
            80,
          ),
        ),
        
        // Tools selection - Group 49 style
        Positioned(
          left: 57,
          top: 210,
          child: _buildToolsSection(),
        ),
        
        // Constraints input - Group 49 style
        Positioned(
          left: 57,
          top: 330,
          child: _buildConfigSection(
            '限制条件',
            '时间、资源、技能等限制...',
            _constraintsController,
            60,
          ),
        ),
        
        // Save button
        Positioned(
          left: 118,
          top: 480,
          child: _buildSaveButton(),
        ),
        
        // Preset buttons
        Positioned(
          left: 57,
          top: 530,
          child: _buildPresetButtons(),
        ),
      ],
    );
  }

  Widget _buildConfigSection(String title, String hint, TextEditingController controller, double height) {
    return SizedBox(
      width: 287,
      height: height + 30,
      child: Stack(
        children: [
          // Section title
          Positioned(
            left: 0,
            top: 0,
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Source Han Sans CN',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D2D2D),
              ),
            ),
          ),
          
          // Rectangle 202 - Inner black box
          Positioned(
            left: 16,
            top: 20,
            child: Container(
              width: 271,
              height: height,
              color: const Color(0xFF3B3B3B),
            ),
          ),
          
          // Subtract - White border box
          Positioned(
            left: 0,
            top: 15,
            child: Container(
              width: 282,
              height: height + 5,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFF3B3B3B), width: 1),
              ),
            ),
          ),
          
          // Rectangle 194 - White background
          Positioned(
            left: 0,
            top: 15,
            child: Container(
              width: 282,
              height: height + 5,
              color: Colors.white,
            ),
          ),
          
          // TextField
          Positioned(
            left: 18,
            top: 20,
            child: SizedBox(
              width: 246,
              height: height - 10,
              child: TextField(
                controller: controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(
                    color: Color(0xFFD7D7D7),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(8),
                ),
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolsSection() {
    return SizedBox(
      width: 287,
      height: 110,
      child: Stack(
        children: [
          // Section title
          Positioned(
            left: 0,
            top: 0,
            child: const Text(
              'AI工具选择',
              style: TextStyle(
                fontFamily: 'Source Han Sans CN',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D2D2D),
              ),
            ),
          ),
          
          // Tools grid
          Positioned(
            left: 0,
            top: 20,
            child: SizedBox(
              width: 287,
              height: 90,
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                children: _availableTools.map((tool) => _buildToolChip(tool)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolChip(String tool) {
    final isSelected = _selectedTools.contains(tool);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedTools.remove(tool);
          } else {
            _selectedTools.add(tool);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFCFFF0B) : Colors.white,
          border: Border.all(
            color: const Color(0xFF3B3B3B),
            width: 1,
          ),
        ),
        child: Text(
          tool,
          style: TextStyle(
            fontSize: 11,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            color: isSelected ? const Color(0xFF3B3B3B) : const Color(0xFF666666),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _saveConfiguration,
      child: SizedBox(
        width: 166.93,
        height: 42.41,
        child: Stack(
          children: [
            // Shadow background
            Positioned(
              left: 6.58,
              top: 6.58,
              child: Container(
                width: 166.93,
                height: 42.41,
                color: const Color(0xFF3B3B3B),
              ),
            ),
            
            // Main button
            Container(
              width: 166.93,
              height: 42.41,
              decoration: BoxDecoration(
                color: const Color(0xFFCFFF0B),
                border: Border.all(color: const Color(0xFF3B3B3B), width: 1),
              ),
              child: Stack(
                children: [
                  // Corner pixels
                  Positioned(left: 0, top: 0, child: _pixelBox(6.58, 6.58, const Color(0xFFD9D9D9))),
                  Positioned(left: 0, bottom: 0, child: _pixelBox(6.58, 7.9, const Color(0xFFD9D9D9))),
                  Positioned(right: 0, top: 0, child: _pixelBox(6.58, 6.58, const Color(0xFFD9D9D9))),
                  Positioned(right: 0, bottom: 0, child: _pixelBox(6.58, 7.9, const Color(0xFFD9D9D9))),
                  
                  const Center(
                    child: Text(
                      '保存配置',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Source Han Sans CN',
                        fontWeight: FontWeight.w400,
                        height: 24 / 16,
                        color: Color(0xFF3B3B3B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetButtons() {
    return Row(
      children: [
        _buildPresetButton('开发者模式', ['💻 代码分析器', '🔧 调试助手', '⏰ 时间管理器']),
        const SizedBox(width: 12),
        _buildPresetButton('学习模式', ['📚 知识整理', '💡 记忆助手', '📝 笔记生成器']),
        const SizedBox(width: 12),
        _buildPresetButton('创意模式', ['💡 创意生成器', '🎨 设计助手', '📝 文本分析器']),
      ],
    );
  }

  Widget _buildPresetButton(String label, List<String> tools) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTools.clear();
          _selectedTools.addAll(tools);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF3B3B3B), width: 1),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            color: Color(0xFF666666),
          ),
        ),
      ),
    );
  }

  Widget _pixelBox(double width, double height, Color color) {
    return Container(
      width: width,
      height: height,
      color: color,
    );
  }

  void _saveConfiguration() async {
    final config = AIConfig(
      context: _contextController.text,
      tools: _selectedTools,
      constraints: _constraintsController.text,
    );
    
    await AIConfigService.saveConfig(config);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('AI配置已保存！'),
        duration: Duration(seconds: 1),
      ),
    );
    
    Navigator.pop(context, config);
  }

  @override
  void initState() {
    super.initState();
    _loadExistingConfig();
  }

  void _loadExistingConfig() async {
    await AIConfigService.loadConfig();
    final config = AIConfigService.currentConfig;
    
    setState(() {
      _contextController.text = config.context;
      _constraintsController.text = config.constraints;
      _selectedTools.clear();
      _selectedTools.addAll(config.tools);
    });
  }
}