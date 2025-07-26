import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_agent_flutter/bloc/task/task_bloc.dart';
import 'package:task_agent_flutter/bloc/task/task_state.dart';
import 'package:task_agent_flutter/bloc/task/task_event.dart';
import 'package:task_agent_flutter/models/task.dart';
import 'package:task_agent_flutter/theme/app_theme.dart';
import 'package:task_agent_flutter/widgets/lucian_components.dart';

class AchievementPage extends StatefulWidget {
  const AchievementPage({Key? key}) : super(key: key);

  @override
  State<AchievementPage> createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: LucianAppBar(
        title: '🏆 ACHIEVEMENTS',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryDark));
          }
          
          if (state is TaskError) {
            return Center(
              child: LucianCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: AppColors.primaryDark),
                    const SizedBox(height: 16),
                    Text(
                      '加载失败: ${state.message}',
                      style: AppTextStyles.title16DotGothic,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    LucianButton(
                      text: 'RELOAD',
                      onPressed: () {
                        context.read<TaskBloc>().add(const LoadTasks());
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          
          // Handle TaskInitial state too
          final tasks = state is TaskLoaded ? state.tasks : <Task>[];
          final completedTasks = tasks.where((t) => t.completedAt != null).toList();
          final groupedByMonth = _groupTasksByMonth(completedTasks);
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MONTHLY ACHIEVEMENTS',
                  style: AppTextStyles.headline24DotGothic,
                ),
                const SizedBox(height: 16),
                ...groupedByMonth.entries.map((entry) => _buildMonthCard(entry.key, entry.value)),
                if (completedTasks.isEmpty)
                  const LucianEmptyState(
                    message: 'NO ACHIEVEMENTS YET\nCOMPLETE TASKS TO COLLECT STICKERS!',
                    icon: Icons.emoji_events_outlined,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonthCard(String month, List<dynamic> tasks) {
    final stickerCount = tasks.length;
    final stickerType = _getStickerType(stickerCount);
    
    return LucianCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                month,
                style: AppTextStyles.title20DotGothic,
              ),
              const Spacer(),
              Text(
                '$stickerCount TASKS',
                style: AppTextStyles.title16DotGothic,
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 5,
            children: List.generate(30, (index) {
              final taskIndex = index;
              if (taskIndex < tasks.length) {
                return _buildTaskSticker(stickerType);
              } else {
                return _buildEmptySlot();
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskSticker(String type) {
    IconData icon;
    Color color;
    
    switch (type) {
      case 'gold':
        icon = Icons.star;
        color = AppColors.accent;
        break;
      case 'silver':
        icon = Icons.star;
        color = AppColors.gray;
        break;
      case 'bronze':
        icon = Icons.star;
        color = AppColors.gray;
        break;
      default:
        icon = Icons.check_circle;
        color = AppColors.white;
    }
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: color, width: 1),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildEmptySlot() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.gray, width: 1),
      ),
    );
  }

  String _getStickerType(int count) {
    if (count >= 20) return 'gold';
    if (count >= 10) return 'silver';
    if (count >= 5) return 'bronze';
    return 'normal';
  }

  Map<String, List<dynamic>> _groupTasksByMonth(List<dynamic> tasks) {
    final grouped = <String, List<dynamic>>{};
    
    for (final task in tasks) {
      final date = task.completedAt;
      if (date != null) {
        final monthKey = '${date.year}年${date.month}月';
        grouped.putIfAbsent(monthKey, () => []).add(task);
      }
    }
    
    // Sort by month in descending order
    return Map.fromEntries(
      grouped.entries.toList()
        ..sort((a, b) => b.key.compareTo(a.key))
    );
  }
}