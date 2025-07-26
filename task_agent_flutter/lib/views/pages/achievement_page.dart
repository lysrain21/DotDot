import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_agent_flutter/bloc/task/task_bloc.dart';
import 'package:task_agent_flutter/bloc/task/task_state.dart';
import 'package:task_agent_flutter/models/task.dart';
import 'package:task_agent_flutter/navigation/app_router.dart';
import 'dart:math';

class AchievementPage extends StatelessWidget {
  const AchievementPage({super.key});

  List<String> _getAchievementImages() {
    return [
      'assets/achievements/Group 77.png',
      'assets/achievements/Group 78.png',
      'assets/achievements/Group 79.png',
      'assets/achievements/Group 82.png',
      'assets/achievements/Group 84.png',
      'assets/achievements/Group 92.png',
    ];
  }

  String _getRandomImage() {
    final images = _getAchievementImages();
    final random = Random();
    return images[random.nextInt(images.length)];
  }

  String _formatDate(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SizedBox(
          width: 400,
          height: 600,
          child: Stack(
            children: [
              // Pixel decoration background
              _buildPixelBackground(),
              
              // Header
              Positioned(
                left: 50,
                top: 60,
                child: Text(
                  '成就日历',
                  style: const TextStyle(
                    fontFamily: 'Source Han Sans CN',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3B3B3B),
                  ),
                ),
              ),
              
              // Calendar grid
              Positioned(
                left: 40,
                top: 120,
                child: _buildCalendarGrid(context),
              ),
              
              // Today's achievement highlight
              Positioned(
                left: 50,
                top: 480,
                child: _buildTodayHighlight(),
              ),
              
              // Back button
              Positioned(
                left: 48,
                top: 520,
                child: _buildBackButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPixelBackground() {
    return Stack(
      children: [
        // Top left decorations
        Positioned(left: 20, top: 20, child: _pixelBox(25, 25, Colors.white)),
        Positioned(left: 0, top: 45, child: _pixelBox(108, 25, Colors.white)),
        Positioned(left: 45, top: 70, child: _pixelBox(115, 24, Colors.white)),
        
        // Bottom right decorations
        Positioned(left: 350, top: 450, child: _pixelBox(25, 25, Colors.white)),
        Positioned(left: 280, top: 480, child: _pixelBox(108, 25, Colors.white)),
        Positioned(left: 320, top: 505, child: _pixelBox(115, 24, Colors.white)),
      ],
    );
  }

  Widget _buildCalendarGrid(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        final tasks = state is TaskLoaded ? state.tasks : <Task>[];
        final completedTasks = tasks.where((t) => t.isCompleted).toList();
        
        // Generate mock achievements for demo
        final achievements = _generateAchievements(completedTasks);
        
        return SizedBox(
          width: 320,
          height: 320,
          child: GridView.builder(
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: 30,
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              return _buildAchievementCard(achievement);
            },
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _generateAchievements(List<Task> completedTasks) {
    final today = DateTime.now();
    final images = _getAchievementImages();
    
    // Create 30 days calendar with first 6 days having achievement icons
    final achievements = <Map<String, dynamic>>[];
    
    // First 6 days get actual achievement icons
    for (var i = 0; i < 6; i++) {
      final date = today.subtract(Duration(days: i));
      achievements.add({
        'date': date,
        'image': images[i % images.length],
        'title': _getRandomTitle(),
        'completed': true,
      });
    }
    
    // Remaining 24 days are empty/placeholder cells
    for (var i = 6; i < 30; i++) {
      final date = today.subtract(Duration(days: i));
      achievements.add({
        'date': date,
        'image': '', // Empty for placeholder
        'title': '',
        'completed': false,
      });
    }
    
    return achievements;
  }

  String _getRandomTitle() {
    final titles = [
      '完美完成', '高效执行', '坚持不懈', '今日之星',
      '任务大师', '专注达人', '时间管理', '效率之王'
    ];
    final random = Random();
    return titles[random.nextInt(titles.length)];
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
    final completed = achievement['completed'] as bool;
    final image = achievement['image'] as String;

    return Container(
      decoration: BoxDecoration(
        color: image.isNotEmpty ? const Color(0xFFCFFF0B) : Colors.white,
        border: Border.all(color: const Color(0xFF3B3B3B), width: 1),
      ),
      child: Stack(
        children: [
          // Corner pixels
          Positioned(left: 0, top: 0, child: _pixelBox(4, 4, const Color(0xFFD9D9D9))),
          Positioned(left: 0, bottom: 0, child: _pixelBox(4, 4, const Color(0xFFD9D9D9))),
          Positioned(right: 0, top: 0, child: _pixelBox(4, 4, const Color(0xFFD9D9D9))),
          Positioned(right: 0, bottom: 0, child: _pixelBox(4, 4, const Color(0xFFD9D9D9))),
          
          // Achievement image or empty placeholder
          Center(
            child: image.isNotEmpty
                ? Image.asset(
                    image,
                    width: 32,
                    height: 32,
                    fit: BoxFit.contain,
                  )
                : Container(), // Empty placeholder
          ),
          
        ],
      ),
    );
  }

  Widget _buildTodayHighlight() {
    final today = DateTime.now();
    final image = _getRandomImage();
    
    return Container(
      width: 300,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFFEFFFE),
        border: Border.all(color: const Color(0xFF3B3B3B), width: 1),
      ),
      child: Stack(
        children: [
          // Corner pixels
          Positioned(left: 0, top: 0, child: _pixelBox(6, 6, const Color(0xFFD9D9D9))),
          Positioned(left: 0, bottom: 0, child: _pixelBox(6, 6, const Color(0xFFD9D9D9))),
          Positioned(right: 0, top: 0, child: _pixelBox(6, 6, const Color(0xFFD9D9D9))),
          Positioned(right: 0, bottom: 0, child: _pixelBox(6, 6, const Color(0xFFD9D9D9))),
          
          // Content
          Row(
            children: [
              const SizedBox(width: 16),
              Image.asset(
                image.isNotEmpty ? image : 'assets/achievements/Group 77.png',
                width: 48,
                height: 48,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '今日成就',
                    style: TextStyle(
                      fontFamily: 'Source Han Sans CN',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3B3B3B),
                    ),
                  ),
                  Text(
                    _formatDate(today),
                    style: const TextStyle(
                      fontFamily: 'Source Han Sans CN',
                      fontSize: 12,
                      color: Color(0xFF646464),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        try {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            // Fallback navigation
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (route) => false,
            );
          }
        } catch (e) {
          print('Navigation error: $e');
          // Force navigation to home
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
            (route) => false,
          );
        }
      },
      child: Container(
        width: 120,
        height: 35,
        decoration: BoxDecoration(
          color: const Color(0xFFCFFF0B),
          border: Border.all(color: const Color(0xFF3B3B3B), width: 1),
        ),
        child: const Center(
          child: Text(
            '返回',
            style: TextStyle(
              fontFamily: 'Source Han Sans CN',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF3B3B3B),
            ),
          ),
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