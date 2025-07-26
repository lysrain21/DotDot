import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Reusable components matching lucian_s_application style

class LucianAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  const LucianAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Text(
        title,
        style: AppTextStyles.title16DotGothic,
      ),
      leading: leading,
      actions: actions,
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class LucianCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double? width;
  final double? height;

  const LucianCard({
    Key? key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primaryDark,
          width: 2,
        ),
      ),
      child: child,
    );
  }
}

class LucianButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;

  const LucianButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 138,
      height: height ?? 39,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryDark,
          foregroundColor: textColor ?? AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(
            color: onPressed != null ? AppColors.accent : AppColors.gray,
            width: 2,
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: AppTextStyles.title16DotGothic.copyWith(
            color: textColor ?? AppColors.white,
          ),
        ),
      ),
    );
  }
}

class LucianTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final bool obscureText;

  const LucianTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.maxLines,
    this.onChanged,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primaryDark,
          width: 2,
        ),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        obscureText: obscureText,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(12),
          hintStyle: AppTextStyles.body12Gray,
        ),
        style: AppTextStyles.body12Inter.copyWith(fontSize: 14),
      ),
    );
  }
}

class LucianEmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const LucianEmptyState({
    Key? key,
    required this.message,
    this.icon = Icons.inbox_outlined,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: AppColors.gray,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTextStyles.body12Gray,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class LucianSpeechBubble extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const LucianSpeechBubble({
    Key? key,
    required this.text,
    this.backgroundColor = AppColors.primaryDark,
    this.textColor = AppColors.accent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: AppTextStyles.title20DotGothic.copyWith(
          color: textColor,
          height: 1.4,
        ),
      ),
    );
  }
}

class LucianProgressBar extends StatelessWidget {
  final double progress;
  final String label;

  const LucianProgressBar({
    Key? key,
    required this.progress,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.title16DotGothic,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryDark, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.background,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}