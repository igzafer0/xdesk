/// Spacing Tokens for XDesk
/// 
/// Tüm spacing değerleri buradan kullanılacak.
/// 8px base unit sistemi.
class AppSpacing {
  AppSpacing._();

  // Base unit: 8px
  static const double base = 8.0;

  // Spacing scale
  static const double xs = 4.0;   // 0.5x base
  static const double sm = 8.0;    // 1x base
  static const double md = 16.0;  // 2x base
  static const double lg = 24.0;   // 3x base
  static const double xl = 32.0;   // 4x base
  static const double xxl = 48.0; // 6x base
  static const double xxxl = 64.0; // 8x base

  // Specific use cases
  static const double padding = md;
  static const double margin = md;
  static const double gap = sm;
  static const double borderRadius = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusSmall = 4.0;
}

