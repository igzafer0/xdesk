import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:design_system/design_system.dart';
import 'package:core/core.dart';
import 'package:finance/finance.dart';
import 'package:home/home.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Dark mode only - sistem ayarını zorla
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.backgroundPrimary,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Dependency Injection Setup
  await configureDependencies(
    apiBaseUrl: 'http://144.91.97.183:8080',
  );

  // Finance modülü bağımlılıklarını kaydet
  setupFinanceDependencies();

  // Home modülü bağımlılıklarını kaydet
  setupHomeDependencies();

  // Home store'u başlat (timer'ı başlatır)
  final homeStore = GetIt.instance<HomeStore>();
  homeStore.initialize();
  
  runApp(XDeskApp(homeStore: homeStore));
}

class XDeskApp extends StatelessWidget {
  final HomeStore homeStore;

  const XDeskApp({
    super.key,
    required this.homeStore,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XDesk',
      debugShowCheckedModeBanner: false,
      // Dark mode only - Design System kullanılıyor
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.surfacePrimary,
          surface: AppColors.backgroundPrimary,
          onPrimary: AppColors.textPrimary,
          onSurface: AppColors.textPrimary,
        ),
        scaffoldBackgroundColor: AppColors.backgroundPrimary,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surfacePrimary,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      themeMode: ThemeMode.dark, // Her zaman dark mode
      home: HomePage(store: homeStore),
    );
  }
}
