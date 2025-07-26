import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends TaskEvent {
  const LoadTasks();
}

class CreateTask extends TaskEvent {
  final String title;
  final bool useAI;
  final bool waitForCompletion;

  const CreateTask(this.title, {this.useAI = true, this.waitForCompletion = false});

  @override
  List<Object> get props => [title, useAI, waitForCompletion];
}

class ToggleStep extends TaskEvent {
  final String taskId;
  final String stepId;
  final bool done;

  const ToggleStep(this.taskId, this.stepId, this.done);

  @override
  List<Object> get props => [taskId, stepId, done];
}

class CompleteTask extends TaskEvent {
  final String taskId;

  const CompleteTask(this.taskId);

  @override
  List<Object> get props => [taskId];
}

class RefreshTasks extends TaskEvent {
  const RefreshTasks();
}

class UpdateStep extends TaskEvent {
  final String stepId;
  final bool? done;
  final String? content;

  const UpdateStep(this.stepId, {this.done, this.content});

  @override
  List<Object> get props => [stepId, done ?? '', content ?? ''];
}

class AddStep extends TaskEvent {
  final String taskId;
  final String content;
  final String? tool;
  final String? theme;
  final int? estimateMinutes;

  const AddStep({
    required this.taskId,
    required this.content,
    this.tool,
    this.theme,
    this.estimateMinutes,
  });

  @override
  List<Object> get props => [taskId, content, if (tool != null) tool!, if (theme != null) theme!, if (estimateMinutes != null) estimateMinutes!];
}

class DeleteStep extends TaskEvent {
  final String stepId;
  final String taskId;

  const DeleteStep(this.stepId, this.taskId);

  @override
  List<Object> get props => [stepId, taskId];
}