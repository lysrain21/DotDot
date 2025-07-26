import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/task/task_bloc.dart';
import '../../bloc/task/task_event.dart';
import '../../bloc/task/task_state.dart';
import '../../models/task.dart';
import '../../navigation/app_router.dart';
import '../../theme/shadcn_theme.dart';

class TaskInputPage extends StatefulWidget {
  const TaskInputPage({Key? key}) : super(key: key);

  @override
  State<TaskInputPage> createState() => _TaskInputPageState();
}

class _TaskInputPageState extends State<TaskInputPage> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _estimatedMinutesController = TextEditingController();

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
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 400,
            height: 600,
            child: Stack(
              children: [
                // Pixel decorations
                _buildPixelDecorations(),
                
                // Main content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 87),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header text
                      _buildHeaderText(),
                      const SizedBox(height: 90),
                      
                      // Input area
                      _buildInputArea(),
                      
                      const Spacer(),
                      
                      // Start button
                      _buildStartButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPixelDecorations() {
    return Stack(
      children: [
        // Left decoration group
        Positioned(left: 41, top: 0, child: _pixelBox(25, 25, Colors.white)),
        Positioned(left: 1, top: 25, child: _pixelBox(108, 25, Colors.white)),
        Positioned(left: 21, top: 50, child: _pixelBox(115, 24, Colors.white)),
        Positioned(left: 136, top: 25, child: _pixelBox(25, 25, Colors.white)),
        Positioned(left: -25, top: 49, child: _pixelBox(25, 25, Colors.white)),
        Positioned(left: 41, top: 74, child: _pixelBox(58, 25, Colors.white)),
        
        // Right decoration group
        Positioned(left: 375, top: 80, child: _pixelBox(25, 25, Colors.white)),
        Positioned(left: 318, top: 105, child: _pixelBox(108, 25, Colors.white)),
        Positioned(left: 344, top: 130, child: _pixelBox(108, 24, Colors.white)),
        Positioned(left: 343, top: 105, child: _pixelBox(25, 25, Colors.white)),
        Positioned(left: 407, top: 80, child: _pixelBox(25, 25, Colors.white)),
        Positioned(left: 373, top: 154, child: _pixelBox(58, 25, Colors.white)),
      ],
    );
  }

  Widget _buildHeaderText() {
    return Stack(
      children: [
        Positioned(
          left: -5,
          top: 1,
          child: Container(
            width: 157,
            height: 26,
            color: const Color(0xFF3B3B3B),
          ),
        ),
        Positioned(
          left: 15,
          top: 26,
          child: Container(
            width: 239,
            height: 32,
            color: const Color(0xFF3B3B3B),
          ),
        ),
        const Text(
          '我想做一个软件，\n它的主要功能是拆解任务。',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 20,
            height: 1.45,
            fontWeight: FontWeight.w400,
            color: Color(0xFFCFFF0B),
          ),
        ),
      ],
    );
  }

  Widget _buildInputArea() {
    return Stack(
      children: [
        // Background shadows
        Positioned(
          left: 16,
          top: 11,
          child: Container(
            width: 271,
            height: 112,
            color: Colors.black,
          ),
        ),
        
        // Main input box
        Container(
          width: 282,
          height: 117,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Stack(
            children: [
              // Corner pixels
              Positioned(left: 0, top: 0, child: _pixelBox(8, 8, const Color(0xFFD9D9D9))),
              Positioned(left: 0, bottom: 0, child: _pixelBox(8, 8, const Color(0xFFD9D9D9))),
              Positioned(right: 0, top: 0, child: _pixelBox(8, 8, const Color(0xFFD9D9D9))),
              Positioned(right: 0, bottom: 0, child: _pixelBox(8, 8, const Color(0xFFD9D9D9))),
              
              // TextField
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _taskController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: '我想在xx分钟内做一个xxx....',
                    hintStyle: TextStyle(
                      color: Color(0xFFD7D7D7),
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Inter',
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    return Center(
      child: GestureDetector(
        onTap: _createTask,
        child: Stack(
          children: [
            Positioned(
              left: 6.5,
              top: 6.5,
              child: Container(
                width: 167,
                height: 42,
                color: const Color(0xFF3B3B3B),
              ),
            ),
            Container(
              width: 167,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFCFFF0B),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Stack(
                children: [
                  // Corner pixels
                  Positioned(left: 0, top: 0, child: _pixelBox(6.5, 6.5, const Color(0xFFD9D9D9))),
                  Positioned(left: 0, bottom: 0, child: _pixelBox(6.5, 7.9, const Color(0xFFD9D9D9))),
                  Positioned(right: 0, top: 0, child: _pixelBox(6.5, 6.5, const Color(0xFFD9D9D9))),
                  Positioned(right: 0, bottom: 0, child: _pixelBox(6.5, 7.9, const Color(0xFFD9D9D9))),
                  
                  const Center(
                    child: Text(
                      '开始！',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF3B3B3B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pixelBox(double width, double height, Color color) {
    return Container(
      width: width,
      height: height,
      color: color,
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
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Creating task with AI...'),
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