import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/task/task_bloc.dart';
import '../../bloc/task/task_event.dart';
import '../../bloc/task/task_state.dart';
import '../../models/task.dart';
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
    context.read<TaskBloc>().add(LoadTasks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: SizedBox(
          width: 400,
          height: 600,
          child: BlocBuilder<TaskBloc, TaskState>(
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

                return Stack(
                  children: [
                    // Main container
                    _buildMainContainer(),
                    
                    // Task items
                    ..._buildTaskItems(task),
                    
                    // Yellow accent bar
                    Positioned(
                      left: 341,
                      top: 178,
                      child: _pixelBox(8, 171, const Color(0xFFCFFF0B)),
                    ),
                    
                    // Bottom button
                    _buildBottomButton(task),
                  ],
                );
              }
              
              if (state is TaskError) {
                return Center(
                  child: Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Text(state.message),
                    ),
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMainContainer() {
    return Stack(
      children: [
        Positioned(
          left: 45,
          top: 170,
          child: Container(
            width: 289,
            height: 296,
            color: const Color(0xFF3B3B3B),
          ),
        ),
        Positioned(
          left: 52,
          top: 170,
          child: Container(
            width: 282,
            height: 316,
            color: const Color(0xFF3B3B3B),
          ),
        ),
        Positioned(
          left: 318,
          top: 170,
          child: Container(
            width: 37,
            height: 303,
            color: const Color(0xFF3B3B3B),
          ),
        ),
        Positioned(
          left: 59,
          top: 163,
          child: Container(
            width: 275,
            height: 7,
            color: const Color(0xFF3B3B3B),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTaskItems(Task task) {
    return task.steps.asMap().entries.map((entry) {
      final index = entry.key;
      final step = entry.value;
      final topPosition = 170 + index * 62;
      
      return Positioned(
        left: 52,
        top: topPosition.toDouble(),
        child: _buildTaskItem(index + 1, step.content, step.done, topPosition.toDouble()),
      );
    }).toList();
  }

  Widget _buildTaskItem(int number, String text, bool completed, double top) {
    return SizedBox(
      width: 282,
      height: 55,
      child: Stack(
        children: [
          // Background
          Container(
            width: 282,
            height: 55,
            color: completed ? const Color(0xFF646464) : Colors.white,
          ),
          
          // Corner pixels
          Positioned(left: 0, top: 0, child: _pixelBox(8, 8, const Color(0xFFD9D9D9))),
          Positioned(left: 0, bottom: 0, child: _pixelBox(8, 8, const Color(0xFFD9D9D9))),
          Positioned(right: 0, top: 0, child: _pixelBox(8, 8, const Color(0xFFD9D9D9))),
          Positioned(right: 0, bottom: 0, child: _pixelBox(8, 8, const Color(0xFFD9D9D9))),
          
          // Task number
          Positioned(
            left: 14,
            top: 0,
            child: Text(
              '$number.',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 40,
                height: 1.275,
                fontWeight: FontWeight.w400,
                color: Color(0xFF3B3B3B),
              ),
            ),
          ),
          
          // Task text
          Positioned(
            left: 70,
            top: 21,
            child: SizedBox(
              width: 126,
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'sans-serif',
                  fontSize: 12,
                  height: 1.33,
                  color: completed ? const Color(0xFF999999) : Colors.black,
                ),
              ),
            ),
          ),
          
          // Checkmark for completed tasks
          if (completed)
            Positioned(
              left: 244,
              top: 11,
              child: _buildCheckmark(),
            ),
        ],
      ),
    );
  }

  Widget _buildCheckmark() {
    return SizedBox(
      width: 33,
      height: 33,
      child: Stack(
        children: [
          Container(
            width: 33,
            height: 33,
            color: const Color(0xFFC0C0C0),
          ),
          Container(
            width: 33,
            height: 33,
            color: const Color(0xFF3B3B3B),
          ),
          // Checkmark pixels
          Positioned(left: 13, top: 19.5, child: _pixelBox(6.5, 6.5, const Color(0xFFCFFF0B))),
          Positioned(left: 6.5, top: 13, child: _pixelBox(6.5, 6.5, const Color(0xFFCFFF0B))),
          Positioned(left: 0, top: 6.5, child: _pixelBox(6.5, 6.5, const Color(0xFFCFFF0B))),
          Positioned(left: 26, top: 6.5, child: _pixelBox(6.5, 6.5, const Color(0xFFCFFF0B))),
          Positioned(left: 32.5, top: 0, child: _pixelBox(6.5, 6.5, const Color(0xFFCFFF0B))),
          Positioned(left: 19.5, top: 13, child: _pixelBox(6.5, 6.5, const Color(0xFFCFFF0B))),
        ],
      ),
    );
  }

  Widget _buildBottomButton(Task task) {
    return Positioned(
      left: 118,
      top: 376,
      child: GestureDetector(
        onTap: () async {
          try {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
            
            final summary = await context.read<TaskBloc>().completeTask(task.id);
            
            if (mounted) {
              Navigator.pop(context);
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to complete task: ${e.toString()}')),
              );
            }
          }
        },
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
}