import 'dart:io';
import 'dart:convert';
import 'package:task_agent_flutter/services/config_service.dart';

class AppManagerService {
  final ConfigService _configService = ConfigService();

  // Mock function to hide/show apps - would need platform-specific implementation
  Future<void> hideApp(String appName) async {
    // This is a placeholder - real implementation would use platform channels
    print('Hiding app: $appName');
    // On macOS, you could use AppleScript or NSWorkspace
    // On Windows, use Windows API
    // On Linux, use xdotool or similar
  }

  Future<void> showApp(String appName) async {
    // This is a placeholder - real implementation would use platform channels
    print('Showing app: $appName');
  }

  Future<void> manageAppsForTask(String taskTitle, List<String> requiredApps) async {
    final allApps = await _configService.getAllConfiguredApps();
    
    // Hide apps not needed for this task
    for (final appConfig in allApps) {
      if (!requiredApps.contains(appConfig.appName)) {
        await hideApp(appConfig.appName);
      }
    }
    
    // Show required apps
    for (final appName in requiredApps) {
      await showApp(appName);
    }
  }

  Future<void> restoreAllApps() async {
    final allApps = await _configService.getAllConfiguredApps();
    for (final appConfig in allApps) {
      await showApp(appConfig.appName);
    }
  }

  // Get apps for a specific task
  Future<List<String>> getAppsForTask(String taskTitle) async {
    final taskType = _detectTaskType(taskTitle);
    final configs = await _configService.getConfigsForType(taskType);
    return configs.map((c) => c.appName).toList();
  }

  String _detectTaskType(String taskTitle) {
    final lowerTitle = taskTitle.toLowerCase();
    
    if (lowerTitle.contains('代码') || lowerTitle.contains('编程') || 
        lowerTitle.contains('开发') || lowerTitle.contains('debug') ||
        lowerTitle.contains('python') || lowerTitle.contains('javascript')) {
      return '编程';
    }
    if (lowerTitle.contains('写作') || lowerTitle.contains('文档') || 
        lowerTitle.contains('报告') || lowerTitle.contains('笔记')) {
      return '写作';
    }
    if (lowerTitle.contains('设计') || lowerTitle.contains('ui') || 
        lowerTitle.contains('原型') || lowerTitle.contains('图')) {
      return '设计';
    }
    if (lowerTitle.contains('学习') || lowerTitle.contains('课程') || 
        lowerTitle.contains('研究') || lowerTitle.contains('阅读')) {
      return '学习';
    }
    
    return '通用';
  }
}