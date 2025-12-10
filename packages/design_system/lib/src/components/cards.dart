import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/spacing.dart';

/// Base Card Widget
/// 
/// Tüm card'ların temel yapısı.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin ?? const EdgeInsets.all(AppSpacing.md),
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfacePrimary,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        border: Border.all(
          color: AppColors.borderPrimary,
          width: 1,
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        child: card,
      );
    }

    return card;
  }
}

/// Elevated Card
/// 
/// Daha yüksek elevation'a sahip card.
class ElevatedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;

  const ElevatedCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      backgroundColor: AppColors.surfaceElevated,
      child: child,
    );
  }
}

