import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/task/task_bloc.dart';
import 'bloc/task/task_event.dart';
import 'services/api_service.dart';
import 'models/task.dart';

void main() {
  runApp(const TaskAgentApp());
}

class TaskAgentApp extends StatelessWidget {
  const TaskAgentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Agent',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => TaskBloc(apiService: ApiService())..add(LoadTasks()),
        child: const TaskAgentHomePage(),
      ),
    );
  }
}

class TaskAgentHomePage extends StatefulWidget {
  const TaskAgentHomePage({super.key});

  @override
  State<TaskAgentHomePage> createState() => _TaskAgentHomePageState();
}

class _TaskAgentHomePageState extends State<TaskAgentHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Agent'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const TaskCreateDialog(),
              );
            },
          ),
        ],
      ),
      body: const TaskListView(),
    );
  }
}

class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TaskError) {
          return Center(
            child: Text('Error: ${state.message}'),
          );
        }

        if (state is TaskLoaded) {
          if (state.tasks.isEmpty) {
            return const Center(
              child: Text('No tasks yet. Create your first task!'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              final task = state.tasks[index];
              return TaskCard(task: task);
            },
          );
        }

        return const Center(child: Text('Welcome to Task Agent'));
      },
    );
  }
}

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final completedSteps = task.steps.where((s) => s.done).length;
    final totalSteps = task.steps.length;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.check_circle_outline),
                  onPressed: () {
                    context.read<TaskBloc>().add(CompleteTask(task.id));
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Estimated: ${task.estimatedMinutes} min',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Progress: $completedSteps/$totalSteps steps',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ...task.steps.map((step) => StepItem(
              step: step,
              onToggle: (done) {
                context.read<TaskBloc>().add(
                  ToggleStep(task.id, step.id, done),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}

class StepItem extends StatelessWidget {
  final TaskStep step;
  final ValueChanged<bool> onToggle;

  const StepItem({
    super.key,
    required this.step,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Checkbox(
            value: step.done,
            onChanged: (value) => onToggle(value ?? false),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.content,
                  style: TextStyle(
                    decoration: step.done ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (step.tool != null || step.theme != null)
                  Text(
                    '${step.tool ?? ''} ${step.theme ?? ''}'.trim(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                        ),
                  ),
              ],
            ),
          ),
          if (step.estimateMinutes > 0)
            Text(
              '${step.estimateMinutes}min',
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ),
    );
  }
}

class TaskCreateDialog extends StatefulWidget {
  const TaskCreateDialog({super.key});

  @override
  State<TaskCreateDialog> createState() => _TaskCreateDialogState();
}

class _TaskCreateDialogState extends State<TaskCreateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Task'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Task title',
            hintText: 'Enter your task title...',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a task title';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<TaskBloc>().add(CreateTask(_titleController.text));
              Navigator.of(context).pop();
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}