import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// Text Input Field
/// 
/// Standart text input widget'ı.
class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.onChanged,
    this.onTap,
    this.suffixIcon,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.labelMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          maxLength: maxLength,
          enabled: enabled,
          onChanged: onChanged,
          onTap: onTap,
          style: AppTypography.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
            errorText: errorText,
            errorStyle: AppTypography.bodySmall.copyWith(
              color: AppColors.error,
            ),
            filled: true,
            fillColor: AppColors.backgroundSecondary,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
              borderSide: const BorderSide(
                color: AppColors.borderPrimary,
                width: 1,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
              borderSide: const BorderSide(
                color: AppColors.borderSecondary,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
              borderSide: const BorderSide(
                color: AppColors.textPrimary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
          ),
        ),
      ],
    );
  }
}

