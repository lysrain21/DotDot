import 'package:flutter/material.dart';

class ShadcnCard extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Border? border;
  final void Function()? onTap;

  const ShadcnCard({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.borderRadius,
    this.border,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderSide = BorderSide(
      color: theme.dividerTheme.color ?? Colors.grey.shade200,
      width: 1,
    );
    
    final card = Card(
      color: color ?? theme.cardTheme.color,
      elevation: elevation ?? 0,
      margin: margin ?? EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        side: border != null ? border!.top : borderSide,
      ),
      child: child != null
          ? Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: child,
            )
          : null,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        child: card,
      );
    }

    return card;
  }
}