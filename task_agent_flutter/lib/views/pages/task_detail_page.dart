import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/task/task_bloc.dart';
import '../../bloc/task/task_event.dart';
import '../../bloc/task/task_state.dart';
import '../../models/task.dart';
import '../../navigation/app_router.dart';
import '../../services/api_service.dart';

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

  Future<void> _navigateToCompletionReview(BuildContext context, Task task) async {
    try {
      // Get the API service from the context
      final apiService = ApiService();
      final summary = await apiService.completeTask(task.id);
      
      if (mounted) {
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error completing task: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: SizedBox(
          width: 400,
          height: 600,
          child: BlocListener<TaskBloc, TaskState>(
            listener: (context, state) async {
              print('TaskBloc state changed: ${state.runtimeType}');
              if (state is TaskWithAllStepsCompleted) {
                print('Navigating to completion review for task: ${state.task.id}');
                await _navigateToCompletionReview(context, state.task);
              }
            },
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
                      
                      // Header text
                      _buildHeaderText(task),
                      
                      // Scrollable task list
                      Positioned(
                        left: 52,
                        top: 170,
                        child: SizedBox(
                          width: 282,
                          height: 316, // Container height
                          child: task.steps.isEmpty
                              ? const Center(child: Text('暂无任务步骤'))
                              : ListView(
                                  padding: EdgeInsets.zero,
                                  children: _buildTaskList(task),
                                ),
                        ),
                      ),
                      
                      // Yellow accent bar
                      Positioned(
                        left: 341,
                        top: 178,
                        child: _pixelBox(8, 171, const Color(0xFFCFFF0B)),
                      ),
                      
                      // Bottom buttons
                      _buildBottomButtons(task),
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
      ),
    );
  }

  Widget _buildMainContainer() {
    return Stack(
      children: [
        // Group 52 - Main container structure
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

  Widget _buildHeaderText(Task task) {
    return Stack(
      children: [
        // Background rectangles
        Positioned(
          left: 45,
          top: 88,
          child: Container(
            width: 157,
            height: 26,
            color: const Color(0xFF3B3B3B),
          ),
        ),
        Positioned(
          left: 65,
          top: 113,
          child: Container(
            width: 239,
            height: 32,
            color: const Color(0xFF3B3B3B),
          ),
        ),
        // Text
        Positioned(
          left: 50,
          top: 87,
          child: SizedBox(
            width: 275,
            child: Text(
              '现在要做的事情\n${task.title.length > 10 ? task.title.substring(0, 10) : task.title}',
              style: const TextStyle(
                fontFamily: 'Source Han Sans CN',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                height: 30 / 20,
                color: Color(0xFFCFFF0B),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTaskList(Task task) {
    // Limit to 9 steps maximum
    final limitedSteps = task.steps.take(9).toList();
    return limitedSteps.asMap().entries.map((entry) {
      final index = entry.key;
      final step = entry.value;
      
      return SizedBox(
        width: 282,
        height: 62,
        child: Stack(
          children: [
            // Task item
            Positioned(
              left: 0,
              top: 0,
              child: _buildTaskItem(
                index + 1, 
                step.content, 
                step.done, 
                0,
                task: task,
                step: step,
              ),
            ),
            // Checkmark - positioned according to CSS
            Positioned(
              left: 237, // 289 - 52 = 237
              top: 11,   // 181 - 170 = 11
              child: GestureDetector(
                onTap: () {
                  context.read<TaskBloc>().add(ToggleStep(
                    task.id,
                    step.id,
                    !step.done,
                  ));
                },
                child: _buildCheckmarkWidget(step.done),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  // These methods are now integrated into _buildTaskList

  Widget _buildTaskItem(int number, String text, bool completed, double top, 
      {VoidCallback? onTap, required Task task, required TaskStep step}) {
    // Dynamic content based on task completion
    final backgroundColor = completed ? const Color(0xFF646464) : Colors.white;
    final textColor = completed ? const Color(0xFF999999) : Colors.black;
    
    // Use actual AI-generated text instead of sample text
    String titleText = '第$number步';
    String descriptionText = text;
    
    return SizedBox(
      width: 282,
      height: 55,
      child: Stack(
        children: [
          // Background
          Container(
            width: 282,
            height: 55,
            color: backgroundColor,
          ),
          
          // Corner pixels
          Positioned(left: 0, top: 0, child: _pixelBox(8, 8, const Color(0xFFD9D9D9))),
          Positioned(left: 0, bottom: 0, child: _pixelBox(8, 8, const Color(0xFFD9D9D9))),
          Positioned(right: 0, top: 0, child: _pixelBox(8, 8, const Color(0xFFD9D9D9))),
          Positioned(right: 0, bottom: 0, child: _pixelBox(8, 8, const Color(0xFFD9D9D9))),
          
          // Task number (Silkscreen font)
          Positioned(
            left: 14,
            top: -2, // Adjust to match exact CSS position
            child: Text(
              '$number.',
              style: const TextStyle(
                fontFamily: 'Silkscreen',
                fontSize: 40,
                height: 51 / 40,
                fontWeight: FontWeight.w400,
                color: Color(0xFF3B3B3B),
              ),
            ),
          ),
          
          // Task title
          Positioned(
            left: 71,
            top: 7, // Adjust to match exact CSS position
            child: Text(
              titleText,
              style: TextStyle(
                fontFamily: 'Source Han Sans CN',
                fontSize: 12,
                height: 18 / 12,
                fontWeight: FontWeight.w400,
                color: textColor,
              ),
            ),
          ),
          
          // Task description
          Positioned(
            left: 71,
            top: 25, // Adjust to match exact CSS position
            child: SizedBox(
              width: 124,
              child: Text(
                descriptionText,
                style: TextStyle(
                  fontFamily: 'Source Han Sans CN',
                  fontSize: 12,
                  height: 16 / 12,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckmarkWidget(bool completed) {
    Color checkmarkColor;
    switch (completed) {
      case true:
        checkmarkColor = const Color(0xFF3B3B3B);
        break;
      case false:
        checkmarkColor = const Color(0xFFECECEC);
        break;
      default:
        checkmarkColor = const Color(0xFFECECEC);
    }
    
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
            color: checkmarkColor,
          ),
          // Checkmark pixels (Group 23)
          Positioned(left: 289 - 289, top: 181 - 181, child: _pixelBox(6.6, 6.6, const Color(0xFFCFFF0B))),
          Positioned(left: 315.4 - 289, top: 181 - 181, child: _pixelBox(6.6, 6.6, const Color(0xFFCFFF0B))),
          Positioned(left: 315.4 - 289, top: 207.4 - 181, child: _pixelBox(6.6, 6.6, const Color(0xFFCFFF0B))),
          Positioned(left: 289 - 289, top: 207.4 - 181, child: _pixelBox(6.6, 6.6, const Color(0xFFCFFF0B))),
          Positioned(left: 302 - 289, top: 201 - 181, child: _pixelBox(6.5, 6.5, const Color(0xFFCFFF0B))),
          Positioned(left: 308.5 - 289, top: 194.5 - 181, child: _pixelBox(6.5, 6.5, const Color(0xFFCFFF0B))),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(Task task) {
    return Stack(
      children: [
        // Left button - Group 42
        Positioned(
          left: 48,
          top: 507,
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouter.taskInput,
                (route) => false,
              );
            },
            child: SizedBox(
              width: 133.55,
              height: 33.93,
              child: Stack(
                children: [
                  // Shadow
                  Positioned(
                    left: 5.27,
                    top: 5.27,
                    child: Container(
                      width: 133.55,
                      height: 33.93,
                      color: const Color(0xFF3B3B3B),
                    ),
                  ),
                  // Main button
                  Container(
                    width: 133.55,
                    height: 33.93,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCFFF0B),
                      border: Border.all(color: const Color(0xFF3B3B3B), width: 0.8),
                    ),
                    child: Stack(
                      children: [
                        // Corner pixels
                        Positioned(left: 0, top: 0, child: _pixelBox(5.27, 5.27, const Color(0xFFD9D9D9))),
                        Positioned(left: 0, bottom: 0, child: _pixelBox(5.27, 6.32, const Color(0xFFD9D9D9))),
                        Positioned(right: 0, top: 0, child: _pixelBox(5.27, 5.27, const Color(0xFFD9D9D9))),
                        Positioned(right: 0, bottom: 0, child: _pixelBox(5.27, 6.32, const Color(0xFFD9D9D9))),
                        
                        const Center(
                          child: Text(
                            '新的任务!',
                            style: TextStyle(
                              fontFamily: 'Source Han Sans CN',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
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
          ),
        ),
        
        // Right button - Group 49
        Positioned(
          left: 216,
          top: 507,
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouter.achievements,
                (route) => false,
              );
            },
            child: SizedBox(
              width: 133.55,
              height: 33.93,
              child: Stack(
                children: [
                  // Shadow
                  Positioned(
                    left: 5.27,
                    top: 5.27,
                    child: Container(
                      width: 133.55,
                      height: 33.93,
                      color: const Color(0xFF3B3B3B),
                    ),
                  ),
                  // Main button
                  Container(
                    width: 133.55,
                    height: 33.93,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCFFF0B),
                      border: Border.all(color: const Color(0xFF3B3B3B), width: 0.8),
                    ),
                    child: Stack(
                      children: [
                        // Corner pixels
                        Positioned(left: 0, top: 0, child: _pixelBox(5.27, 5.27, const Color(0xFFD9D9D9))),
                        Positioned(left: 0, bottom: 0, child: _pixelBox(5.27, 6.32, const Color(0xFFD9D9D9))),
                        Positioned(right: 0, top: 0, child: _pixelBox(5.27, 5.27, const Color(0xFFD9D9D9))),
                        Positioned(right: 0, bottom: 0, child: _pixelBox(5.27, 6.32, const Color(0xFFD9D9D9))),
                        
                        const Center(
                          child: Text(
                            '查看成就!',
                            style: TextStyle(
                              fontFamily: 'Source Han Sans CN',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
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
          ),
        ),
      ],
    );
  }

  // Removed old bottom button, now using _buildBottomButtons

  Widget _pixelBox(double width, double height, Color color) {
    return Container(
      width: width,
      height: height,
      color: color,
    );
  }
}