import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ai_config.dart';

class AIConfigService {
  static const String _configKey = 'ai_config';
  static const String _lastPresetKey = 'last_preset';

  // Current active configuration
  static AIConfig _currentConfig = AIConfig();

  static AIConfig get currentConfig => _currentConfig;

  static Future<void> loadConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configJson = prefs.getString(_configKey);
      if (configJson != null) {
        final configData = json.decode(configJson);
        _currentConfig = AIConfig.fromJson(configData);
      }
    } catch (e) {
      print('Error loading config: $e');
    }
  }

  static Future<void> saveConfig(AIConfig config) async {
    try {
      _currentConfig = config;
      final prefs = await SharedPreferences.getInstance();
      final configJson = json.encode(config.toJson());
      await prefs.setString(_configKey, configJson);
    } catch (e) {
      print('Error saving config: $e');
    }
  }

  static Future<void> savePreset(String preset) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastPresetKey, preset);
    } catch (e) {
      print('Error saving preset: $e');
    }
  }

  static Future<String> getLastPreset() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_lastPresetKey) ?? 'default';
    } catch (e) {
      return 'default';
    }
  }

  static String enhanceTaskPrompt(String taskTitle) {
    return _currentConfig.getPromptForTask(taskTitle);
  }

  static Map<String, dynamic> getEnhancedTaskData(String taskTitle) {
    return {
      'title': taskTitle,
      'prompt': enhanceTaskPrompt(taskTitle),
      'tools': _currentConfig.tools,
      'context': _currentConfig.context,
      'constraints': _currentConfig.constraints,
    };
  }
}