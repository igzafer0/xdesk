import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

/// Error Widget
/// 
/// Chart yüklenirken hata oluşursa gösterilir
class ChartErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ChartErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfacePrimary,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        border: Border.all(color: AppColors.error),
      ),
      child: Column(
        children: [
          Text(
            message,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(text: 'Tekrar Dene', onPressed: onRetry),
        ],
      ),
    );
  }
}

