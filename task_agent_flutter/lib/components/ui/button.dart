import 'package:flutter/material.dart';
import '../../theme/shadcn_theme.dart';

enum ButtonVariant { primary, secondary, outline, ghost, destructive }

class ShadcnButton extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final Size? size;
  final bool disabled;
  final Widget? icon;

  const ShadcnButton({
    super.key,
    this.child,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size,
    this.disabled = false,
    this.icon,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonSize = size ?? const Size(double.infinity, 40);

    Color backgroundColor = ShadcnColors.primary;
    Color foregroundColor = ShadcnColors.primaryForeground;
    Color borderColor = Colors.transparent;

    switch (variant) {
      case ButtonVariant.primary:
        backgroundColor = ShadcnColors.primary;
        foregroundColor = ShadcnColors.primaryForeground;
        break;
      case ButtonVariant.secondary:
        backgroundColor = ShadcnColors.secondary;
        foregroundColor = ShadcnColors.secondaryForeground;
        break;
      case ButtonVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = ShadcnColors.foreground;
        borderColor = ShadcnColors.border;
        break;
      case ButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = ShadcnColors.foreground;
        break;
      case ButtonVariant.destructive:
        backgroundColor = ShadcnColors.destructive;
        foregroundColor = ShadcnColors.destructiveForeground;
        break;
    }

    final button = ElevatedButton(
      onPressed: disabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        side: BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minimumSize: buttonSize,
        elevation: 0,
      ).copyWith(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return backgroundColor.withOpacity(0.5);
            }
            if (states.contains(WidgetState.hovered)) {
              return backgroundColor.withOpacity(0.9);
            }
            return backgroundColor;
          },
        ),
      ),
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon!,
                const SizedBox(width: 8),
                if (child != null) child!,
              ],
            )
          : child,
    );

    return button;
  }
}