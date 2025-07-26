import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../models/task.dart';
import '../../services/api_service.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final ApiService apiService;

  TaskBloc({required this.apiService}) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<CreateTask>(_onCreateTask);
    on<ToggleStep>(_onToggleStep);
    on<UpdateStep>(_onUpdateStep);
    on<AddStep>(_onAddStep);
    on<DeleteStep>(_onDeleteStep);
    on<CompleteTask>(_onCompleteTask);
    on<RefreshTasks>(_onRefreshTasks);
  }

  Future<void> _onLoadTasks(
    LoadTasks event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      final tasks = await apiService.getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError('Failed to load tasks: ${e.toString()}'));
    }
  }

  Future<void> _onCreateTask(
    CreateTask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      if (event.useAI) {
        // For now, use the regular AI creation since streaming might not be supported by backend
        final newTask = await apiService.createTaskWithAI(event.title);
        if (state is TaskLoaded) {
          final currentTasks = (state as TaskLoaded).tasks;
          emit(TaskLoaded([newTask, ...currentTasks]));
        } else {
          emit(TaskLoaded([newTask]));
        }
      } else {
        final newTask = await apiService.createTask(event.title);
        if (state is TaskLoaded) {
          final currentTasks = (state as TaskLoaded).tasks;
          emit(TaskLoaded([newTask, ...currentTasks]));
        } else {
          emit(TaskLoaded([newTask]));
        }
      }
    } catch (e) {
      emit(TaskError('Failed to create task: ${e.toString()}'));
    }
  }

  Future<void> _onToggleStep(
    ToggleStep event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await apiService.updateStep(event.stepId, done: event.done);
      if (state is TaskLoaded) {
        final currentTasks = (state as TaskLoaded).tasks;
        final updatedTasks = currentTasks.map((task) {
          if (task.id == event.taskId) {
            final updatedSteps = task.steps.map((step) {
              if (step.id == event.stepId) {
                return step.copyWith(done: event.done);
              }
              return step;
            }).toList();
            return task.copyWith(steps: updatedSteps);
          }
          return task;
        }).toList();
        emit(TaskLoaded(updatedTasks));
      }
    } catch (e) {
      emit(TaskError('Failed to update step: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateStep(
    UpdateStep event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await apiService.updateStep(
        event.stepId,
        done: event.done,
        content: event.content,
      );
      if (state is TaskLoaded) {
        final currentTasks = (state as TaskLoaded).tasks;
        final updatedTasks = currentTasks.map((task) {
          final updatedSteps = task.steps.map((step) {
            if (step.id == event.stepId) {
              return step.copyWith(
                done: event.done ?? step.done,
                content: event.content ?? step.content,
              );
            }
            return step;
          }).toList();
          return task.copyWith(steps: updatedSteps);
        }).toList();
        emit(TaskLoaded(updatedTasks));
      }
    } catch (e) {
      emit(TaskError('Failed to update step: ${e.toString()}'));
    }
  }

  Future<void> _onAddStep(
    AddStep event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final newStep = await apiService.addStep(
        event.taskId,
        event.content,
        tool: event.tool,
        theme: event.theme,
        estimateMinutes: event.estimateMinutes,
      );
      if (state is TaskLoaded) {
        final currentTasks = (state as TaskLoaded).tasks;
        final updatedTasks = currentTasks.map((task) {
          if (task.id == event.taskId) {
            final updatedSteps = [...task.steps, newStep];
            return task.copyWith(steps: updatedSteps);
          }
          return task;
        }).toList();
        emit(TaskLoaded(updatedTasks));
      }
    } catch (e) {
      emit(TaskError('Failed to add step: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteStep(
    DeleteStep event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await apiService.deleteStep(event.stepId);
      if (state is TaskLoaded) {
        final currentTasks = (state as TaskLoaded).tasks;
        final updatedTasks = currentTasks.map((task) {
          if (task.id == event.taskId) {
            final updatedSteps = task.steps.where((step) => step.id != event.stepId).toList();
            return task.copyWith(steps: updatedSteps);
          }
          return task;
        }).toList();
        emit(TaskLoaded(updatedTasks));
      }
    } catch (e) {
      emit(TaskError('Failed to delete step: ${e.toString()}'));
    }
  }

  Future<void> _onCompleteTask(
    CompleteTask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await apiService.completeTask(event.taskId);
      if (state is TaskLoaded) {
        final currentTasks = (state as TaskLoaded).tasks;
        final updatedTasks = currentTasks.where((task) => task.id != event.taskId).toList();
        emit(TaskLoaded(updatedTasks));
      }
    } catch (e) {
      emit(TaskError('Failed to complete task: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshTasks(
    RefreshTasks event,
    Emitter<TaskState> emit,
  ) async {
    add(LoadTasks());
  }

  Future<String> completeTask(String taskId) async {
    try {
      final summary = await apiService.completeTask(taskId);
      add(CompleteTask(taskId));
      return summary;
    } catch (e) {
      throw Exception('Failed to complete task: $e');
    }
  }

  Future<String> getDailySummary() async {
    try {
      return await apiService.getTodaySummary();
    } catch (e) {
      return 'NO TASK SUMMARY FOR TODAY';
    }
  }

  Future<void> updateStep(String stepId, {bool? done, String? content}) async {
    add(UpdateStep(stepId, done: done, content: content));
  }

  Future<void> addStep(String taskId, String content, {String? tool, String? theme, int? estimateMinutes}) async {
    add(AddStep(
      taskId: taskId,
      content: content,
      tool: tool,
      theme: theme,
      estimateMinutes: estimateMinutes,
    ));
  }

  Future<void> deleteStep(String stepId, String taskId) async {
    add(DeleteStep(stepId, taskId));
  }
}