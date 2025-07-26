import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomLucianButton extends StatefulWidget {
  const CustomLucianButton({
    Key? key,
    this.height,
    this.width,
    this.backgroundColor,
    this.text,
    this.textStyle,
    this.onTap,
    this.hoverScale,
    this.activeScale,
    this.borderRadius,
  }) : super(key: key);

  final double? height;
  final double? width;
  final Color? backgroundColor;
  final String? text;
  final TextStyle? textStyle;
  final VoidCallback? onTap;
  final double? hoverScale;
  final double? activeScale;
  final double? borderRadius;

  @override
  State<CustomLucianButton> createState() => _CustomLucianButtonState();
}

class _CustomLucianButtonState extends State<CustomLucianButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final buttonHeight = widget.height ?? 39.0;
    final buttonWidth = widget.width ?? 138.0;
    final borderRadius = widget.borderRadius ?? 8.0;
    final hoverScaleFactor = widget.hoverScale ?? 1.05;
    final activeScaleFactor = widget.activeScale ?? 0.95;

    return AnimatedScale(
      scale: _isPressed 
          ? activeScaleFactor 
          : _isHovered 
              ? hoverScaleFactor 
              : 1.0,
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: Container(
            height: buttonHeight,
            width: buttonWidth,
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? AppColors.primaryDark,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: AppColors.accent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withOpacity(0.2),
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.text ?? '',
                style: widget.textStyle ?? AppTextStyles.title16DotGothic.copyWith(
                  color: AppColors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Simple button that matches lucian_s_application style
class LucianElevatedButton extends StatelessWidget {
  const LucianElevatedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primaryDark,
        foregroundColor: foregroundColor ?? AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        side: BorderSide(
          color: onPressed != null ? AppColors.accent : AppColors.gray,
          width: 2,
        ),
        textStyle: AppTextStyles.title16DotGothic,
      ),
      child: child,
    );
  }
}