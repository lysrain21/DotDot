import 'dart:async';
import 'package:task_agent_flutter/models/task.dart';

class TaskSwitcherService {
  static final TaskSwitcherService _instance = TaskSwitcherService._internal();
  factory TaskSwitcherService() => _instance;
  TaskSwitcherService._internal();

  final List<Task> _activeTasks = [];
  Task? _currentTask;
  final StreamController<List<Task>> _tasksController = StreamController<List<Task>>.broadcast();

  Stream<List<Task>> get activeTasksStream => _tasksController.stream;
  
  List<Task> get activeTasks => List.from(_activeTasks);
  Task? get currentTask => _currentTask;

  void addTask(Task task) {
    if (!_activeTasks.any((t) => t.id == task.id)) {
      _activeTasks.add(task);
      _tasksController.add(_activeTasks);
    }
  }

  void switchToTask(String taskId) {
    final task = _activeTasks.firstWhere((t) => t.id == taskId);
    _currentTask = task;
    _tasksController.add(_activeTasks);
  }

  void removeTask(String taskId) {
    _activeTasks.removeWhere((t) => t.id == taskId);
    if (_currentTask?.id == taskId) {
      _currentTask = _activeTasks.isNotEmpty ? _activeTasks.last : null;
    }
    _tasksController.add(_activeTasks);
  }

  List<Task> getIncompleteTasks() {
    return _activeTasks.where((task) => 
      task.completedAt == null && 
      task.steps.any((step) => !step.done)
    ).toList();
  }

  void dispose() {
    _tasksController.close();
  }
}