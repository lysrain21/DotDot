import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  final String taskType;
  final String appName;
  final String appPath;
  final List<String> keywords;
  final bool isDefault;

  AppConfig({
    required this.taskType,
    required this.appName,
    required this.appPath,
    required this.keywords,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => {
    'taskType': taskType,
    'appName': appName,
    'appPath': appPath,
    'keywords': keywords,
    'isDefault': isDefault,
  };

  factory AppConfig.fromJson(Map<String, dynamic> json) => AppConfig(
    taskType: json['taskType'],
    appName: json['appName'],
    appPath: json['appPath'],
    keywords: List<String>.from(json['keywords']),
    isDefault: json['isDefault'] ?? false,
  );
}

class ConfigService {
  static const String _configKey = 'app_configs';

  static final Map<String, List<AppConfig>> _defaultConfigs = {
    '编程': [
      AppConfig(
        taskType: '编程',
        appName: 'Visual Studio Code',
        appPath: '/Applications/Visual Studio Code.app',
        keywords: ['code', '编程', '开发', 'python', 'javascript', 'flutter'],
        isDefault: true,
      ),
      AppConfig(
        taskType: '编程',
        appName: 'Terminal',
        appPath: '/System/Applications/Utilities/Terminal.app',
        keywords: ['terminal', '命令行', 'git'],
        isDefault: true,
      ),
    ],
    '写作': [
      AppConfig(
        taskType: '写作',
        appName: 'Notion',
        appPath: '/Applications/Notion.app',
        keywords: ['写作', '笔记', '文档'],
        isDefault: true,
      ),
      AppConfig(
        taskType: '写作',
        appName: 'Typora',
        appPath: '/Applications/Typora.app',
        keywords: ['markdown', '写作'],
        isDefault: true,
      ),
    ],
    '设计': [
      AppConfig(
        taskType: '设计',
        appName: 'Figma',
        appPath: '/Applications/Figma.app',
        keywords: ['设计', 'UI', '原型'],
        isDefault: true,
      ),
    ],
    '学习': [
      AppConfig(
        taskType: '学习',
        appName: 'Safari',
        appPath: '/Applications/Safari.app',
        keywords: ['学习', '搜索', '浏览'],
        isDefault: true,
      ),
    ],
  };

  Future<List<AppConfig>> getConfigsForType(String taskType) async {
    final prefs = await SharedPreferences.getInstance();
    final configsJson = prefs.getString(_configKey);
    
    if (configsJson == null) {
      return _defaultConfigs[taskType] ?? [];
    }

    try {
      final configs = List<Map<String, dynamic>>.from(json.decode(configsJson));
      final typeConfigs = configs
          .where((config) => config['taskType'] == taskType)
          .map((config) => AppConfig.fromJson(config))
          .toList();

      // Merge with default configs
      final defaultConfigs = _defaultConfigs[taskType] ?? [];
      final merged = [...defaultConfigs, ...typeConfigs];
      
      // Remove duplicates based on appName
      final unique = <String, AppConfig>{};
      for (final config in merged) {
        if (!unique.containsKey(config.appName)) {
          unique[config.appName] = config;
        }
      }
      
      return unique.values.toList();
    } catch (e) {
      return _defaultConfigs[taskType] ?? [];
    }
  }

  Future<void> saveConfig(AppConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    final configsJson = prefs.getString(_configKey);
    
    List<Map<String, dynamic>> configs = [];
    if (configsJson != null) {
      try {
        configs = List<Map<String, dynamic>>.from(json.decode(configsJson));
      } catch (e) {
        // Ignore error, start fresh
      }
    }

    // Remove existing config for same app and task type
    configs.removeWhere((c) =>
        c['taskType'] == config.taskType && c['appName'] == config.appName);

    configs.add(config.toJson());
    await prefs.setString(_configKey, json.encode(configs));
  }

  Future<void> deleteConfig(String taskType, String appName) async {
    final prefs = await SharedPreferences.getInstance();
    final configsJson = prefs.getString(_configKey);
    
    if (configsJson != null) {
      try {
        final configs = List<Map<String, dynamic>>.from(json.decode(configsJson));
        configs.removeWhere((c) => c['taskType'] == taskType && c['appName'] == appName);
        await prefs.setString(_configKey, json.encode(configs));
      } catch (e) {
        // Ignore error
      }
    }
  }

  Future<List<String>> getAllTaskTypes() async {
    final prefs = await SharedPreferences.getInstance();
    final configsJson = prefs.getString(_configKey);
    
    Set<String> types = Set.from(_defaultConfigs.keys);
    
    if (configsJson != null) {
      try {
        final configs = List<Map<String, dynamic>>.from(json.decode(configsJson));
        for (final config in configs) {
          types.add(config['taskType']);
        }
      } catch (e) {
        // Ignore error
      }
    }
    
    return types.toList()..sort();
  }

  Future<String?> getRecommendedApp(String taskType, String stepContent) async {
    final configs = await getConfigsForType(taskType);
    if (configs.isEmpty) return null;

    // Find best matching app based on keywords
    for (final config in configs) {
      for (final keyword in config.keywords) {
        if (stepContent.toLowerCase().contains(keyword.toLowerCase())) {
          return config.appName;
        }
      }
    }

    // Return default app for the type
    return configs.firstWhere((c) => c.isDefault, orElse: () => configs.first).appName;
  }

  Future<AppConfig?> getAppConfig(String appName) async {
    final allTypes = await getAllTaskTypes();
    
    for (final type in allTypes) {
      final configs = await getConfigsForType(type);
      for (final config in configs) {
        if (config.appName == appName) {
          return config;
        }
      }
    }
    return null;
  }

  Future<List<AppConfig>> getAllConfiguredApps() async {
    final allTypes = await getAllTaskTypes();
    final allConfigs = <AppConfig>[];
    
    for (final type in allTypes) {
      final configs = await getConfigsForType(type);
      allConfigs.addAll(configs);
    }
    
    return allConfigs;
  }
}