enum TaskStatus { pending, inProgress, completed }

class Task {
  final String id;
  final String title;
  final String? description;
  final int estimatedMinutes;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime? dueDate;
  final TaskStatus status;
  final bool isCompleted;
  final List<TaskStep> steps;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.estimatedMinutes,
    required this.createdAt,
    this.completedAt,
    this.dueDate,
    this.status = TaskStatus.pending,
    this.isCompleted = false,
    required this.steps,
  });

  Task copyWith({
    String? id,
    String? title,
    int? estimatedMinutes,
    DateTime? createdAt,
    DateTime? completedAt,
    List<TaskStep>? steps,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      steps: steps ?? this.steps,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      estimatedMinutes: json['estimated_minutes'],
      createdAt: DateTime.parse(json['created_at']),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      isCompleted: json['is_completed'] ?? false,
      steps: (json['steps'] as List? ?? [])
          .map((step) => TaskStep.fromJson(step))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'estimated_minutes': estimatedMinutes,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'is_completed': isCompleted,
      'steps': steps.map((step) => step.toJson()).toList(),
    };
  }
}

class TaskStep {
  final String id;
  final String taskId;
  final String content;
  final String? tool;
  final String? theme;
  final String? deliverable;
  final int estimateMinutes;
  final bool done;
  final int orderIdx;

  TaskStep({
    required this.id,
    required this.taskId,
    required this.content,
    this.tool,
    this.theme,
    this.deliverable,
    required this.estimateMinutes,
    required this.done,
    required this.orderIdx,
  });

  factory TaskStep.fromJson(Map<String, dynamic> json) {
    return TaskStep(
      id: json['id'],
      taskId: json['task_id'],
      content: json['content'],
      tool: json['tool'],
      theme: json['theme'],
      deliverable: json['deliverable'],
      estimateMinutes: json['estimate_minutes'],
      done: json['done'],
      orderIdx: json['order_idx'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_id': taskId,
      'content': content,
      'tool': tool,
      'theme': theme,
      'deliverable': deliverable,
      'estimate_minutes': estimateMinutes,
      'done': done,
      'order_idx': orderIdx,
    };
  }

  TaskStep copyWith({
    String? id,
    String? taskId,
    String? content,
    String? tool,
    String? theme,
    String? deliverable,
    int? estimateMinutes,
    bool? done,
    int? orderIdx,
  }) {
    return TaskStep(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      content: content ?? this.content,
      tool: tool ?? this.tool,
      theme: theme ?? this.theme,
      deliverable: deliverable ?? this.deliverable,
      estimateMinutes: estimateMinutes ?? this.estimateMinutes,
      done: done ?? this.done,
      orderIdx: orderIdx ?? this.orderIdx,
    );
  }
}