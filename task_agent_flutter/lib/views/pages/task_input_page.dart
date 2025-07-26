import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/task/task_bloc.dart';
import '../../bloc/task/task_event.dart';
import '../../bloc/task/task_state.dart';
import '../../models/task.dart';
import '../../navigation/app_router.dart';
import '../../components/ui/button.dart';
import '../../components/ui/card.dart';

class TaskInputPage extends StatefulWidget {
  const TaskInputPage({Key? key}) : super(key: key);

  @override
  State<TaskInputPage> createState() => _TaskInputPageState();
}

class _TaskInputPageState extends State<TaskInputPage> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _estimatedMinutesController = TextEditingController();
  DateTime? _dueDate;

  @override
  void dispose() {
    _taskController.dispose();
    _descriptionController.dispose();
    _estimatedMinutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
        elevation: 0,
      ),
      body: SafeArea(
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
                        'What would you like to accomplish?',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _taskController,
                        decoration: const InputDecoration(
                          labelText: 'Task Title',
                          hintText: 'e.g., Build a Flutter app for task management',
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description (optional)',
                          hintText: 'Add more details about your task...',
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _estimatedMinutesController,
                              decoration: const InputDecoration(
                                labelText: 'Estimated Time',
                                hintText: '30',
                                suffixText: 'minutes',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (date != null) {
                                  setState(() {
                                    _dueDate = date;
                                  });
                                }
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Due Date',
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _dueDate != null
                                          ? _dueDate!.toString().split(' ')[0]
                                          : 'Select date',
                                    ),
                                    const Icon(Icons.calendar_today, size: 16),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ShadcnButton(
                  onPressed: _createTask,
                  child: const Text('Create Task'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createTask() async {
    if (_taskController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title')),
      );
      return;
    }

    final estimatedMinutes = int.tryParse(_estimatedMinutesController.text) ?? 30;

    // Show loading indicator
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
                  'Creating task with AI...',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final taskTitle = _taskController.text.trim();
      context.read<TaskBloc>().add(CreateTask(
        taskTitle,
        useAI: true,
        waitForCompletion: true,
      ));
      
      // Wait for the task to be created and then navigate to its detail
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        Navigator.pop(context); // Return to task list
        
        // Find the newly created task and navigate to its detail
        final state = context.read<TaskBloc>().state;
        if (state is TaskLoaded) {
          final newTask = state.tasks.firstWhere(
            (t) => t.title == taskTitle,
            orElse: () => state.tasks.first,
          );
          Navigator.pushNamed(context, '/task-detail', arguments: newTask);
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create task: ${e.toString()}')),
        );
      }
    }
  }
}