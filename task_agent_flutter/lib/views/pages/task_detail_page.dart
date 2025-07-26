import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/task/task_bloc.dart';
import '../../bloc/task/task_event.dart';
import '../../bloc/task/task_state.dart';
import '../../models/task.dart';
import '../../components/ui/card.dart';
import '../../components/ui/button.dart';
import '../../navigation/app_router.dart';

class TaskDetailPage extends StatefulWidget {
  final String? taskId;

  const TaskDetailPage({super.key, this.taskId});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  @override
  void initState() {
    super.initState();
    // Ensure tasks are loaded when detail page opens
    context.read<TaskBloc>().add(LoadTasks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        elevation: 0,
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is TaskLoaded) {
            if (widget.taskId == null) {
              return const Center(child: Text('No task ID provided'));
            }
            
            final task = state.tasks.firstWhere(
              (t) => t.id == widget.taskId,
              orElse: () => Task(
                id: '',
                title: 'Task not found',
                description: 'Task not found or has been deleted',
                estimatedMinutes: 0,
                createdAt: DateTime.now(),
                steps: [],
                status: TaskStatus.pending,
                isCompleted: false,
              ),
            );

            if (task.id.isEmpty) {
              return const Center(child: Text('Task not found'));
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShadcnCard(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.title,
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                                if (task.description != null && task.description!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      task.description!,
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const Icon(Icons.schedule, size: 16),
                                    const SizedBox(width: 4),
                                    Text('${task.estimatedMinutes} min'),
                                    const SizedBox(width: 24),
                                    const Icon(Icons.calendar_today, size: 16),
                                    const SizedBox(width: 4),
                                    Text(task.dueDate?.toString().split(' ')[0] ?? 'No due date'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Steps',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        ...task.steps.map((step) => ShadcnCard(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Checkbox(
                              value: step.done,
                              onChanged: (value) {
                                context.read<TaskBloc>().add(
                                  ToggleStep(task.id, step.id, value ?? false),
                                );
                              },
                            ),
                            title: Text(step.content),
                            subtitle: step.tool != null || step.theme != null
                                ? Text('${step.tool ?? ''} ${step.theme ?? ''}'.trim())
                                : null,
                            trailing: step.estimateMinutes > 0
                                ? Text('${step.estimateMinutes} min')
                                : null,
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ShadcnButton(
                      onPressed: () async {
                        try {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => Center(
                              child: ShadcnCard(
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const CircularProgressIndicator(),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Generating completion summary...',
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                          
                          final summary = await context.read<TaskBloc>().completeTask(task.id);
                          
                          if (mounted) {
                            Navigator.pop(context); // Close loading dialog
                            Navigator.pushNamed(
                              context,
                              AppRouter.completionReview,
                              arguments: {
                                'taskId': task.id,
                                'summary': summary,
                              },
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            Navigator.pop(context); // Close loading dialog
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to complete task: ${e.toString()}')),
                            );
                          }
                        }
                      },
                      child: const Text('Complete Task'),
                    ),
                  ),
                ),
              ],
            );
          }
          
          if (state is TaskError) {
            return Center(
              child: ShadcnCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(state.message),
                      const SizedBox(height: 16),
                      ShadcnButton(
                        onPressed: () {
                          context.read<TaskBloc>().add(LoadTasks());
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}