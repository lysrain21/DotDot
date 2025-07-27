class AIConfig {
  final String context;
  final List<String> tools;
  final String constraints;
  final String preset;

  AIConfig({
    this.context = '',
    this.tools = const [],
    this.constraints = '',
    this.preset = 'default',
  });

  Map<String, dynamic> toJson() {
    return {
      'context': context,
      'tools': tools,
      'constraints': constraints,
      'preset': preset,
    };
  }

  factory AIConfig.fromJson(Map<String, dynamic> json) {
    return AIConfig(
      context: json['context'] ?? '',
      tools: List<String>.from(json['tools'] ?? []),
      constraints: json['constraints'] ?? '',
      preset: json['preset'] ?? 'default',
    );
  }

  AIConfig copyWith({
    String? context,
    List<String>? tools,
    String? constraints,
    String? preset,
  }) {
    return AIConfig(
      context: context ?? this.context,
      tools: tools ?? this.tools,
      constraints: constraints ?? this.constraints,
      preset: preset ?? this.preset,
    );
  }

  // Preset configurations
  static Map<String, List<String>> get presets {
    return {
      'developer': ['💻 代码分析器', '🔧 调试助手', '⏰ 时间管理器', '📝 文档生成器'],
      'student': ['📚 知识整理', '💡 记忆助手', '📝 笔记生成器', '⏰ 学习规划'],
      'creative': ['💡 创意生成器', '🎨 设计助手', '📝 文本分析器', '🎯 头脑风暴'],
      'business': ['📊 数据分析器', '💼 商业策略', '⏰ 项目管理', '📝 报告生成'],
      'fitness': ['🏃 运动规划', '💪 训练助手', '⏰ 时间安排', '📊 进度跟踪'],
    };
  }

  String getPromptForTask(String taskTitle) {
    final toolsStr = tools.join('、');
    final constraintsStr = constraints.isNotEmpty ? '限制条件：$constraints' : '';
    final contextStr = context.isNotEmpty ? '任务背景：$context' : '';
    
    return '''
请使用以下工具集：$toolsStr
来拆解这个任务：$taskTitle

$contextStr
$constraintsStr

请提供详细的9步以内执行计划，每步都要具体可执行。
    '''.trim();
  }
}