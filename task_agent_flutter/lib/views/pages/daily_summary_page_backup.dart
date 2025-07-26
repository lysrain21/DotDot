import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:task_agent_flutter/bloc/task/task_bloc.dart';
import 'package:task_agent_flutter/bloc/task/task_event.dart';
import 'package:task_agent_flutter/bloc/task/task_state.dart';

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
        _dailySummary = '今日暂无任务总结';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('TODAY SUMMARY', style: TextStyle(fontFamily: 'Courier')),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : RefreshIndicator(
              onRefresh: _loadDailySummary,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TODAY\'S TASK SUMMARY',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.zero,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Markdown(
                          data: _dailySummary,
                          styleSheet: MarkdownStyleSheet(
                            h1: const TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            h2: const TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            h3: const TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            p: const TextStyle(fontFamily: 'Courier', fontSize: 16, color: Colors.white),
                            listBullet: const TextStyle(fontFamily: 'Courier', fontSize: 16, color: Colors.white),
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
                              color: Colors.transparent,
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.emoji_events, color: Colors.white, size: 40),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'COMPLETED: $completedToday TASKS',
                                      style: const TextStyle(
                                        fontFamily: 'Courier',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Text(
                                      'KEEP GOING!',
                                      style: TextStyle(
                                        fontFamily: 'Courier',
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
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