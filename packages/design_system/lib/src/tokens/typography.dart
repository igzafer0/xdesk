import 'package:flutter/material.dart';
import 'colors.dart';

/// Typography Tokens for XDesk
/// 
/// Tüm text stilleri buradan kullanılacak.
class AppTypography {
  AppTypography._();

  // Font families (şu an sistem fontu kullanılıyor)
  static const String fontFamily = 'Roboto';

  // Font sizes
  static const double fontSizeXs = 12.0;
  static const double fontSizeSm = 14.0;
  static const double fontSizeMd = 16.0;
  static const double fontSizeLg = 18.0;
  static const double fontSizeXl = 20.0;
  static const double fontSizeXxl = 24.0;
  static const double fontSizeXxxl = 32.0;

  // Font weights
  static const FontWeight weightRegular = FontWeight.w400;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightSemiBold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.w700;

  // Text Styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: fontSizeXxxl,
    fontWeight: weightBold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: fontSizeXxl,
    fontWeight: weightBold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: fontSizeXl,
    fontWeight: weightSemiBold,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: fontSizeLg,
    fontWeight: weightSemiBold,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: fontSizeMd,
    fontWeight: weightMedium,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: fontSizeMd,
    fontWeight: weightRegular,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: fontSizeSm,
    fontWeight: weightRegular,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: fontSizeXs,
    fontWeight: weightRegular,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: fontSizeSm,
    fontWeight: weightMedium,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: fontSizeXs,
    fontWeight: weightMedium,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: fontSizeXs,
    fontWeight: weightRegular,
    color: AppColors.textSecondary,
    height: 1.4,
  );
}

