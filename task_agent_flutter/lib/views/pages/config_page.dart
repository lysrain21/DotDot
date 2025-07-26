import 'package:flutter/material.dart';
import 'package:task_agent_flutter/services/config_service.dart';
import 'package:task_agent_flutter/theme/app_theme.dart';
import 'package:task_agent_flutter/widgets/lucian_components.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final ConfigService _configService = ConfigService();
  final TextEditingController _taskTypeController = TextEditingController();
  final TextEditingController _appNameController = TextEditingController();
  final TextEditingController _appPathController = TextEditingController();
  final TextEditingController _keywordsController = TextEditingController();

  List<String> _taskTypes = [];
  Map<String, List<AppConfig>> _configs = {};
  String _selectedTaskType = '';

  @override
  void initState() {
    super.initState();
    _loadConfigs();
  }

  @override
  void dispose() {
    _taskTypeController.dispose();
    _appNameController.dispose();
    _appPathController.dispose();
    _keywordsController.dispose();
    super.dispose();
  }

  Future<void> _loadConfigs() async {
    final types = await _configService.getAllTaskTypes();
    final configs = <String, List<AppConfig>>{};
    
    for (final type in types) {
      configs[type] = await _configService.getConfigsForType(type);
    }

    setState(() {
      _taskTypes = types;
      _configs = configs;
      if (_taskTypes.isNotEmpty) {
        _selectedTaskType = _taskTypes.first;
      }
    });
  }

  void _showAddConfigDialog() {
    _taskTypeController.clear();
    _appNameController.clear();
    _appPathController.clear();
    _keywordsController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text('添加应用配置', style: AppTextStyles.title20DotGothic),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LucianTextField(
                controller: _taskTypeController,
                hintText: '任务类型',
              ),
              const SizedBox(height: 16),
              LucianTextField(
                controller: _appNameController,
                hintText: '应用名称',
              ),
              const SizedBox(height: 16),
              LucianTextField(
                controller: _appPathController,
                hintText: '应用路径',
              ),
              const SizedBox(height: 16),
              LucianTextField(
                controller: _keywordsController,
                hintText: '关键词（用逗号分隔）',
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消', style: AppTextStyles.title16DotGothic),
          ),
          LucianButton(
            text: '保存',
            onPressed: () async {
              if (_validateInputs()) {
                final config = AppConfig(
                  taskType: _taskTypeController.text,
                  appName: _appNameController.text,
                  appPath: _appPathController.text,
                  keywords: _keywordsController.text
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList(),
                );

                await _configService.saveConfig(config);
                Navigator.pop(context);
                _loadConfigs();
              }
            },
          ),
        ],
      ),
    );
  }

  bool _validateInputs() {
    return _taskTypeController.text.isNotEmpty &&
           _appNameController.text.isNotEmpty &&
           _appPathController.text.isNotEmpty;
  }

  Future<void> _deleteConfig(AppConfig config) async {
    await _configService.deleteConfig(config.taskType, config.appName);
    _loadConfigs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const LucianAppBar(
        title: '应用配置',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('任务类型:', style: AppTextStyles.title16DotGothic),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedTaskType,
                  dropdownColor: AppColors.white,
                  items: _taskTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type, style: AppTextStyles.body12Inter),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTaskType = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _configs[_selectedTaskType]?.isEmpty ?? true
                  ? const LucianEmptyState(
                      message: '暂无配置',
                      icon: Icons.settings_outlined,
                    )
                  : ListView.builder(
                      itemCount: _configs[_selectedTaskType]?.length ?? 0,
                      itemBuilder: (context, index) {
                        final config = _configs[_selectedTaskType]![index];
                        return LucianCard(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      config.appName,
                                      style: AppTextStyles.title16DotGothic,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      config.keywords.join(', '),
                                      style: AppTextStyles.body12Gray,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: AppColors.primaryDark),
                                onPressed: () => _deleteConfig(config),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddConfigDialog,
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}