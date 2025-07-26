import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/task.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8123/api/v1';
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }

  Future<List<Task>> getTasks() async {
    try {
      final response = await _dio.get('/tasks/');
      return (response.data as List)
          .map((task) => Task.fromJson(task))
          .toList();
    } catch (e) {
      throw Exception('Failed to load tasks: $e');
    }
  }

  Future<Task> createTask(String title) async {
    try {
      final response = await _dio.post(
        '/tasks/',
        data: {'title': title},
      );
      return Task.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  Future<Task> createTaskWithAI(String title) async {
    try {
      final response = await _dio.post(
        '/tasks/',
        data: {'title': title, 'use_ai': true},
      );
      return Task.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create task with AI: $e');
    }
  }

  Future<Task> createTaskWithAIStreaming(String title, Function(List<String>) onStepGenerated) async {
    try {
      final response = await _dio.post(
        '/tasks/',
        data: {'title': title, 'use_ai': true, 'stream': true},
        options: Options(
          responseType: ResponseType.stream,
        ),
      );
      
      final stream = response.data.stream;
      final completer = Completer<Task>();
      List<String> steps = [];
      
      stream.listen(
        (data) {
          final lines = utf8.decode(data).split('\n');
          for (final line in lines) {
            if (line.startsWith('data: ')) {
              final jsonStr = line.substring(6);
              if (jsonStr == '[DONE]') {
                completer.complete(Task(id: '', title: title, estimatedMinutes: 0, createdAt: DateTime.now(), steps: []));
              } else {
                try {
                  final json = jsonDecode(jsonStr);
                  if (json['step'] != null) {
                    steps.add(json['step']);
                    onStepGenerated(steps);
                  }
                } catch (e) {
                  // Handle JSON parsing errors
                }
              }
            }
          }
        },
        onError: (error) {
          completer.completeError(Exception('Failed to create task with AI: $error'));
        },
        onDone: () {
          if (!completer.isCompleted) {
            completer.complete(Task(id: '', title: title, estimatedMinutes: 0, createdAt: DateTime.now(), steps: []));
          }
        },
      );
      
      return completer.future;
    } catch (e) {
      throw Exception('Failed to create task with AI: $e');
    }
  }

  Future<void> updateStep(String stepId, {bool? done, String? content}) async {
    try {
      final data = {};
      if (done != null) data['done'] = done;
      if (content != null) data['content'] = content;

      await _dio.patch('/tasks/steps/$stepId', data: data);
    } catch (e) {
      throw Exception('Failed to update step: $e');
    }
  }

  Future<String> completeTask(String taskId) async {
    try {
      final response = await _dio.post('/tasks/$taskId/complete');
      return response.data['summary_markdown'];
    } catch (e) {
      throw Exception('Failed to complete task: $e');
    }
  }

  Future<String> getTodaySummary() async {
    try {
      final response = await _dio.get('/summary/today');
      return response.data['summary_markdown'];
    } catch (e) {
      throw Exception('Failed to get today summary: $e');
    }
  }

  Future<TaskStep> addStep(String taskId, String content, {String? tool, String? theme, int? estimateMinutes}) async {
    try {
      final response = await _dio.post(
        '/tasks/$taskId/steps',
        data: {
          'content': content,
          'tool': tool,
          'theme': theme,
          'estimate_minutes': estimateMinutes ?? 5,
        },
      );
      return TaskStep.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to add step: $e');
    }
  }

  Future<void> deleteStep(String stepId) async {
    try {
      await _dio.delete('/tasks/steps/$stepId');
    } catch (e) {
      throw Exception('Failed to delete step: $e');
    }
  }
}