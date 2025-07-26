import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:task_agent_flutter/navigation/app_router.dart';

class CompletionReviewPage extends StatelessWidget {
  final String taskId;
  final String summary;

  const CompletionReviewPage({
    Key? key,
    required this.taskId,
    required this.summary,
  }) : super(key: key);

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
              Column(
                children: [
                  // Stats display
                  const SizedBox(height: 157),
                  _buildStatsDisplay(),
                  
                  // Achievement cards
                  const SizedBox(height: 65),
                  _buildAchievementCards(),
                  
                  const Spacer(),
                  
                  // Buttons
                  _buildButtons(context),
                  const SizedBox(height: 53),
                ],
              ),
            ],
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

  Widget _buildStatsDisplay() {
    return Container(
      width: 241,
      height: 108,
      margin: const EdgeInsets.only(left: 54),
      child: Stack(
        children: [
          // Background text
          Positioned(
            top: 0,
            left: 0,
            child: SizedBox(
              width: 241,
              height: 108,
              child: Text(
                '你今天做完了 3 件事， 17 个步骤。 用时 2h45min',
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
          
          // Highlight boxes
          Positioned(left: 0, top: 38, child: _pixelBox(30, 29, const Color(0xFFCFFF0B))),
          Positioned(left: 56, top: 74, child: _pixelBox(99, 29, const Color(0xFFCFFF0B))),
          Positioned(left: 144, top: 3, child: _pixelBox(30, 29, const Color(0xFFCFFF0B))),
        ],
      ),
    );
  }

  Widget _buildAchievementCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAchievementCard(),
        const SizedBox(width: 17),
        _buildAchievementCard(),
        const SizedBox(width: 17),
        _buildAchievementCard(),
      ],
    );
  }

  Widget _buildAchievementCard() {
    return Container(
      width: 85,
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF3B3B3B), width: 1),
      ),
      child: Stack(
        children: [
          // Corner pixels
          Positioned(left: 0, top: 0, child: _pixelBox(8, 8, const Color(0xFFD9D9D9))),
          Positioned(left: 0, bottom: 0, child: _pixelBox(8, 8, const Color(0xFFD9D9D9))),
          Positioned(right: 0, top: 0, child: _pixelBox(8, 8, const Color(0xFFD9D9D9))),
          Positioned(right: 0, bottom: 0, child: _pixelBox(8, 8, const Color(0xFFD9D9D9))),
          
          // Image placeholder
          Center(
            child: Container(
              width: 43,
              height: 47,
              color: Colors.grey[300], // Placeholder for achievement image
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
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRouter.achievements,
            (route) => false,
          );
        }),
      ],
    );
  }

  Widget _buildPixelButton(BuildContext context, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 133.55,
        height: 33.93,
        margin: const EdgeInsets.only(top: 5.27, left: 5.27),
        decoration: BoxDecoration(
          color: const Color(0xFFCFFF0B),
          border: Border.all(color: const Color(0xFF3B3B3B), width: 0.8),
        ),
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
            
            // Button
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
                  
                  // Text
                  Center(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontFamily: 'Source Han Sans CN',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
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