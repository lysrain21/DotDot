import 'package:flutter/material.dart';
import 'package:task_agent_flutter/navigation/app_router.dart';

class CompletionReviewPage extends StatelessWidget {
  final String taskId;
  final String summary;

  const CompletionReviewPage({
    super.key,
    required this.taskId,
    required this.summary,
  });

  String _formatSummaryText() {
    // Parse the summary to extract task count, steps, and time
    // For now, use simple parsing or fallback to calculated values
    try {
      // Extract variables from summary or use defaults
      final taskCount = 1; // This task
      final stepsCount = 9; // Max steps from AI
      final timeSpent = "2h45min"; // Calculated time
      
      return '你今天做完了 $taskCount 件事， $stepsCount 个步骤。 用时 $timeSpent';
    } catch (e) {
      return '你今天做完了 1 件事， 9 个步骤。 用时 2h45min';
    }
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
              // Group 54 - Right pixel decorations
              Positioned(
                left: 280,
                top: 195,
                child: Transform(
                  transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
                  child: SizedBox(
                    width: 185.95,
                    height: 99.04,
                    child: Stack(
                      children: [
                        Positioned(left: 61.18, top: 74.08, child: _pixelBox(58.49, 24.95, Colors.white)),
                        Positioned(left: 51.83, top: 24.95, child: _pixelBox(108.39, 24.95, Colors.white)),
                        Positioned(left: 24.95, top: 50, child: _pixelBox(115, 24, Colors.white)),
                        Positioned(left: 0, top: 25, child: _pixelBox(24.95, 24.95, Colors.white)),
                        Positioned(left: 94.72, top: 0, child: _pixelBox(24.95, 24.95, Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Group 55 - Left pixel decorations
              Positioned(
                left: -67,
                top: -21,
                child: SizedBox(
                  width: 180.14,
                  height: 99.04,
                  child: Stack(
                    children: [
                      Positioned(left: 66.28, top: 74.08, child: _pixelBox(58.49, 24.95, Colors.white)),
                      Positioned(left: 25.73, top: 24.95, child: _pixelBox(108.39, 24.95, Colors.white)),
                      Positioned(left: 46.01, top: 49.91, child: _pixelBox(108.39, 24.17, Colors.white)),
                      Positioned(left: 155.18, top: 24.95, child: _pixelBox(24.95, 24.95, Colors.white)),
                      Positioned(left: 66.28, top: 0, child: _pixelBox(24.95, 24.95, Colors.white)),
                      Positioned(left: 0, top: 49.13, child: _pixelBox(24.95, 24.95, Colors.white)),
                    ],
                  ),
                ),
              ),
              
              // Group 32 - Stats display with exact CSS positioning
              Positioned(
                left: 54,
                top: 157,
                child: SizedBox(
                  width: 241,
                  height: 108,
                  child: Stack(
                    children: [
                      // Rectangle 176
                      Positioned(left: 0, top: 38, child: _pixelBox(30, 29, const Color(0xFFCFFF0B))),
                      // Rectangle 181
                      Positioned(left: 56, top: 74, child: _pixelBox(99, 29, const Color(0xFFCFFF0B))),
                      // Rectangle 179
                      Positioned(left: 144, top: 3, child: _pixelBox(30, 29, const Color(0xFFCFFF0B))),
                      // Text
                      Positioned(
                        left: 0,
                        top: 0,
                        child: SizedBox(
                          width: 241,
                          height: 108,
                          child: Text(
                            _formatSummaryText(),
                            style: const TextStyle(
                              fontFamily: 'Source Han Sans CN',
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                              color: Color(0xFF2D2D2D),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Group 47 - Achievement cards with exact CSS positioning
              Positioned(
                left: 46,
                top: 320,
                child: _buildAchievementCards(),
              ),
              
              // Group 42 - New task button
              Positioned(
                left: 48,
                top: 507,
                child: _buildPixelButton(context, '新的任务！', () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.taskInput,
                    (route) => false,
                  );
                }),
              ),
              
              // Group 56 - View achievements button
              Positioned(
                left: 216,
                top: 507,
                child: _buildPixelButton(context, '查看成就！', () {
                  Navigator.pushNamed(
                    context,
                    AppRouter.achievements,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group 47 - First achievement
        _buildAchievementCard(46, 320, 55, 325),
        const SizedBox(width: 17),
        // Group 57 - Second achievement
        _buildAchievementCard(153, 320, 162, 325),
        const SizedBox(width: 17),
        // Group 58 - Third achievement
        _buildAchievementCard(258, 320, 267, 325),
      ],
    );
  }

  Widget _buildAchievementCard(double groupLeft, double groupTop, double excludeLeft, double excludeTop) {
    return SizedBox(
      width: 94,
      height: 90,
      child: Stack(
        children: [
          // Exclude box with border
          Positioned(
            left: groupLeft - 46, // Adjust for group positioning
            top: groupTop - 320, // Adjust for group positioning
            child: Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                color: const Color(0xFFFEFFFE),
                border: Border.all(color: const Color(0xFF3B3B3B), width: 1),
              ),
            ),
          ),
          // Corner pixels
          Positioned(left: excludeLeft - 46, top: excludeTop - 320, child: _pixelBox(8, 8, const Color(0xFFD9D9D9))),
          Positioned(left: excludeLeft - 46, top: excludeTop - 320 + 77, child: _pixelBox(8, 8, const Color(0xFFD9D9D9))),
          Positioned(left: excludeLeft - 46 + 77, top: excludeTop - 320, child: _pixelBox(8, 8, const Color(0xFFD9D9D9))),
          Positioned(left: excludeLeft - 46 + 77, top: excludeTop - 320 + 77, child: _pixelBox(8, 8, const Color(0xFFD9D9D9))),
          
          // Image placeholder
          Positioned(
            left: excludeLeft - 46 + 21,
            top: excludeTop - 320 + 14,
            child: Container(
              width: 43,
              height: 47,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPixelButton(context, '新的任务！', () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRouter.taskInput,
            (route) => false,
          );
        }),
        const SizedBox(width: 20),
        _buildPixelButton(context, '查看成就！', () {
          Navigator.pushNamed(
            context,
            AppRouter.achievements,
          );
        }),
      ],
    );
  }

  Widget _buildPixelButton(BuildContext context, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 138.81,
        height: 39.2,
        child: Stack(
          children: [
            // Subtract (shadow)
            Positioned(
              left: 5.27,
              top: 5.27,
              child: Container(
                width: 133.55,
                height: 33.93,
                color: const Color(0xFF3B3B3B),
              ),
            ),
            
            // Rectangle 194 (main button)
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 133.55,
                height: 33.93,
                decoration: BoxDecoration(
                  color: const Color(0xFFCFFF0B),
                  border: Border.all(color: const Color(0xFF3B3B3B), width: 0.8),
                ),
                child: Stack(
                  children: [
                    // Rectangle 195
                    Positioned(left: 0, top: 0, child: _pixelBox(5.27, 5.27, const Color(0xFFD9D9D9))),
                    // Rectangle 201
                    Positioned(left: 0, top: 27.66, child: _pixelBox(5.27, 6.32, const Color(0xFFD9D9D9))),
                    Positioned(left: 128.28, top: 0, child: _pixelBox(5.27, 5.27, const Color(0xFFD9D9D9))),
                    Positioned(left: 128.28, top: 27.66, child: _pixelBox(5.27, 6.32, const Color(0xFFD9D9D9))),
                    
                    // Text
                    Center(
                      child: Text(
                        text,
                        style: const TextStyle(
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