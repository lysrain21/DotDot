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
        child: SizedBox(
          width: 400,
          height: 600,
          child: Stack(
            children: [
              // Pixel decorations
              _buildPixelDecorations(),
              
              // Main content
              _buildMainContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPixelDecorations() {
    return Stack(
      children: [
        // Left decoration group - Group 54 (exact CSS positions)
        Positioned(left: 41.28, top: 74.08, child: _pixelBox(58.49, 24.95, Colors.white)),
        Positioned(left: 0.73, top: 24.95, child: _pixelBox(108.39, 24.95, Colors.white)),
        Positioned(left: 21, top: 50, child: _pixelBox(115, 24, Colors.white)),
        Positioned(left: 136, top: 25, child: _pixelBox(24.95, 24.95, Colors.white)),
        Positioned(left: -25, top: 49.13, child: _pixelBox(24.95, 24.95, Colors.white)),
        Positioned(left: 41.28, top: 0, child: _pixelBox(24.95, 24.95, Colors.white)),
        
        // Right decoration group - Group 55 (exact CSS positions with transforms)
        Positioned(left: 318, top: 104.95, child: _pixelBox(108.39, 24.95, Colors.white)),
        Positioned(left: 343.73, top: 129.91, child: _pixelBox(108.39, 24.17, Colors.white)),
        Positioned(left: 318, top: 104.95, child: _pixelBox(24.95, 24.95, Colors.white)),
        Positioned(left: 406.9, top: 80, child: _pixelBox(24.95, 24.95, Colors.white)),
        Positioned(left: 373.37, top: 154.08, child: _pixelBox(58.49, 24.95, Colors.white)),
        Positioned(left: 473.18, top: 129.13, child: _pixelBox(24.95, 24.95, Colors.white)),
      ],
    );
  }

  Widget _buildMainContent() {
    return Stack(
      children: [
        // Input area - Group 49 (exact CSS positions)
        Positioned(
          left: 57,
          top: 227,
          child: _buildInputArea(),
        ),
        
        // Header text - Group 57 (exact CSS positions)
        Positioned(
          left: 57,
          top: 180,
          child: const Text(
            '你想做什么?',
            style: TextStyle(
              fontFamily: 'Source Han Sans CN',
              fontSize: 24,
              fontWeight: FontWeight.w400,
              height: 36 / 24,
              color: Color(0xFF2D2D2D),
            ),
          ),
        ),
        
        // Start button - Group 42 (exact CSS positions)
        Positioned(
          left: 118,
          top: 376,
          child: _buildStartButton(),
        ),
      ],
    );
  }

  Widget _buildInputArea() {
    return SizedBox(
      width: 287,
      height: 123,
      child: Stack(
        children: [
          // Main container (Group 49)
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 287,
              height: 123,
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
            ),
          ),
          
          
          
          // Updated corner pixel for new input field
          Positioned(
            left: 75 - 57 + 245 - 8, // right edge of new input field
            top: 241 - 227 + 85 - 8, // bottom edge of new input field
            child: Container(
              width: 8,
              height: 8,
              color: const Color(0xFFD9D9D9),
            ),
          ),
          
          // Enhanced TextField area - removed black bar, larger text
          Positioned(
            left: 75 - 57, // 18px from left of Group 49
            top: 241 - 227, // 14px from top of Group 49
            child: Container(
              width: 245,
              height: 85,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFF3B3B3B), width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: TextField(
                  controller: _taskController,
                  maxLines: 3,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText: '我想在xx分钟内做一个xxx....',
                    hintStyle: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 16,
                      fontFamily: 'Source Han Sans CN',
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Source Han Sans CN',
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF2D2D2D),
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return GestureDetector(
      onTap: _createTask,
      child: SizedBox(
        width: 166.93,
        height: 42.41,
        child: Stack(
          children: [
            // Shadow background (Subtract)
            Positioned(
              left: 6.58,
              top: 6.58,
              child: Container(
                width: 166.93,
                height: 42.41,
                color: const Color(0xFF3B3B3B),
              ),
            ),
            
            // Main button (Rectangle 194)
            Container(
              width: 166.93,
              height: 42.41,
              decoration: BoxDecoration(
                color: const Color(0xFFCFFF0B),
                border: Border.all(color: const Color(0xFF3B3B3B), width: 1),
              ),
              child: Stack(
                children: [
                  // Corner pixels (Group 40)
                  Positioned(left: 0, top: 0, child: _pixelBox(6.58, 6.58, const Color(0xFFD9D9D9))),
                  Positioned(left: 0, bottom: 0, child: _pixelBox(6.58, 7.9, const Color(0xFFD9D9D9))),
                  Positioned(right: 0, top: 0, child: _pixelBox(6.58, 6.58, const Color(0xFFD9D9D9))),
                  Positioned(right: 0, bottom: 0, child: _pixelBox(6.58, 7.9, const Color(0xFFD9D9D9))),
                  
                  const Center(
                    child: Text(
                      '开始!',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Source Han Sans CN',
                        fontWeight: FontWeight.w400,
                        height: 24 / 16,
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
      
      // Listen for the task creation completion
      final bloc = context.read<TaskBloc>();
      await for (final state in bloc.stream) {
        if (state is TaskLoaded) {
          final newTask = state.tasks.firstWhere(
            (t) => t.title == taskTitle,
            orElse: () => state.tasks.first,
          );
          
          if (mounted) {
            Navigator.pop(context); // Close loading dialog
            Navigator.pushNamed(context, '/task-detail', arguments: newTask);
          }
          break;
        } else if (state is TaskError) {
          if (mounted) {
            Navigator.pop(context); // Close loading dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('创建任务失败: ${state.message}')),
            );
          }
          break;
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