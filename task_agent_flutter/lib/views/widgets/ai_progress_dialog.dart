import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_agent_flutter/bloc/task/task_bloc.dart';
import 'package:task_agent_flutter/navigation/app_router.dart';
import 'package:task_agent_flutter/models/task.dart';

class AIProgressDialog extends StatefulWidget {
  final String taskTitle;

  const AIProgressDialog({Key? key, required this.taskTitle}) : super(key: key);

  @override
  State<AIProgressDialog> createState() => _AIProgressDialogState();
}

class _AIProgressDialogState extends State<AIProgressDialog> {
  bool _isCreating = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _createTaskWithAI();
  }

  Future<void> _createTaskWithAI() async {
    try {
      final bloc = context.read<TaskBloc>();
      
      // Create task with AI
      final newTask = await bloc.apiService.createTaskWithAI(widget.taskTitle);
      
      if (mounted) {
        Navigator.of(context).pop();
        
        // Navigate to task detail
        Navigator.pushNamed(
          context,
          AppRouter.taskDetail,
          arguments: {'taskId': newTask.id},
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isCreating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'AI BREAKDOWN IN PROGRESS',
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            if (_isCreating) ...[
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                'ANALYZING YOUR TASK...',
                style: TextStyle(
                  fontFamily: 'Courier',
                  color: Colors.grey,
                ),
              ),
            ] else if (_error != null) ...[
              Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                _error!,
                style: const TextStyle(
                  fontFamily: 'Courier',
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 1),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                ),
                child: const Text('CLOSE', style: TextStyle(fontFamily: 'Courier')),
              ),
            ],
          ],
        ),
      ),
    );
  }
}