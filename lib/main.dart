import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:design_system/design_system.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Dark mode only - sistem ayarını zorla
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF000000),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(const XDeskApp());
}

class XDeskApp extends StatelessWidget {
  const XDeskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XDesk',
      debugShowCheckedModeBanner: false,
      // Dark mode only - Design System kullanılıyor
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.surfacePrimary,
          surface: AppColors.backgroundPrimary,
          background: AppColors.backgroundPrimary,
          onPrimary: AppColors.textPrimary,
          onSurface: AppColors.textPrimary,
          onBackground: AppColors.textPrimary,
        ),
        scaffoldBackgroundColor: AppColors.backgroundPrimary,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surfacePrimary,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
        ),
      ),
      // Light mode'i tamamen devre dışı bırak
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.surfacePrimary,
          surface: AppColors.backgroundPrimary,
          background: AppColors.backgroundPrimary,
          onPrimary: AppColors.textPrimary,
          onSurface: AppColors.textPrimary,
          onBackground: AppColors.textPrimary,
        ),
        scaffoldBackgroundColor: AppColors.backgroundPrimary,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surfacePrimary,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
        ),
      ),
      themeMode: ThemeMode.dark, // Her zaman dark mode
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('XDesk'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.dashboard,
              size: 64,
              color: AppColors.textPrimary,
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'XDesk\'e Hoş Geldiniz',
              style: AppTypography.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Hyperscale • Zero-Latency',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'Modüler yapı hazır!',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
