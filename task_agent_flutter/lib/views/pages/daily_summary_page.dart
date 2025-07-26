import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:task_agent_flutter/bloc/task/task_bloc.dart';
import 'package:task_agent_flutter/bloc/task/task_state.dart';
import 'package:task_agent_flutter/theme/app_theme.dart';

class DailySummaryPage extends StatefulWidget {
  const DailySummaryPage({Key? key}) : super(key: key);

  @override
  State<DailySummaryPage> createState() => _DailySummaryPageState();
}

class _DailySummaryPageState extends State<DailySummaryPage> {
  String _dailySummary = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDailySummary();
  }

  Future<void> _loadDailySummary() async {
    try {
      final summary = await context.read<TaskBloc>().getDailySummary();
      setState(() {
        _dailySummary = summary;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _dailySummary = 'NO TASK SUMMARY FOR TODAY';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('今日总结', style: AppTextStyles.title16DotGothic),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryDarker),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryDark))
          : RefreshIndicator(
              onRefresh: _loadDailySummary,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '今日任务总结',
                      style: AppTextStyles.headline24DotGothic,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: AppColors.primaryDark, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          height: 300, // Fixed height for menu bar
                          child: Markdown(
                            data: _dailySummary,
                            shrinkWrap: true,
                            styleSheet: MarkdownStyleSheet(
                              h1: AppTextStyles.headline24DotGothic.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              h2: AppTextStyles.title20DotGothic.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              h3: AppTextStyles.title16DotGothic.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              p: AppTextStyles.body12Inter.copyWith(
                                fontSize: 16,
                              ),
                              listBullet: AppTextStyles.body12Inter.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<TaskBloc, TaskState>(
                      builder: (context, state) {
                        if (state is TaskLoaded) {
                          final completedToday = state.tasks
                              .where((task) => task.completedAt != null && 
                                    _isToday(task.completedAt!))
                              .length;
                          
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              border: Border.all(color: AppColors.primaryDark, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.emoji_events, 
                                  color: AppColors.primaryDark, size: 40),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '已完成: $completedToday 个任务',
                                      style: AppTextStyles.title16DotGothic,
                                    ),
                                    Text(
                                      '继续加油！',
                                      style: AppTextStyles.body12Gray,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }
}