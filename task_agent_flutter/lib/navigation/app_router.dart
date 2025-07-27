import 'package:flutter/material.dart';
import 'package:task_agent_flutter/views/pages/task_input_page.dart';
import 'package:task_agent_flutter/views/pages/task_detail_page.dart';
import 'package:task_agent_flutter/views/pages/completion_review_page.dart';
import 'package:task_agent_flutter/views/pages/daily_summary_page.dart';
import 'package:task_agent_flutter/views/pages/achievement_page.dart';
import 'package:task_agent_flutter/views/pages/config_page.dart';
import 'package:task_agent_flutter/views/pages/config_tool_page.dart';
import '../models/task.dart';

class AppRouter {
  static const String taskInput = '/';
  static const String taskDetail = '/task-detail';
  static const String completionReview = '/completion-review';
  static const String dailySummary = '/daily-summary';
  static const String achievements = '/achievements';
  static const String config = '/config';
  static const String configTool = '/config-tool';

  static Route< dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case taskInput:
        return MaterialPageRoute(builder: (_) => const TaskInputPage());
      
      case taskDetail:
        final args = settings.arguments;
        if (args is Task) {
          return MaterialPageRoute(
            builder: (_) => TaskDetailPage(taskId: args.id),
          );
        } else if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => TaskDetailPage(taskId: args['taskId']),
          );
        } else {
          return MaterialPageRoute(
            builder: (_) => const TaskDetailPage(),
          );
        }
      
      case completionReview:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => CompletionReviewPage(
            taskId: args?['taskId'],
            summary: args?['summary'],
          ),
        );
      
      case dailySummary:
        return MaterialPageRoute(builder: (_) => const DailySummaryPage());
      
      case achievements:
        return MaterialPageRoute(builder: (_) => const AchievementPage());
      
      case config:
        return MaterialPageRoute(builder: (_) => const ConfigPage());
      
      case configTool:
        return MaterialPageRoute(builder: (_) => const ConfigToolPage());
      
      default:
        return MaterialPageRoute(builder: (_) => const TaskInputPage());
    }
  }
}