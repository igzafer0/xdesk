import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:design_system/design_system.dart';
import 'package:core/core.dart';
import 'package:finance/finance.dart';
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
  _setupFinanceDependencies();
  
  runApp(const XDeskApp());
}

/// Finance modülü bağımlılıklarını kaydeder
void _setupFinanceDependencies() {
  final getIt = GetIt.instance;

  // Data Sources
  final currencyRemoteSource = CurrencyRemoteSource(
    getIt<ApiClient>(),
  );
  getIt.registerLazySingleton<CurrencyRemoteSource>(
    () => currencyRemoteSource,
  );

  // Repositories
  final currencyRepository = CurrencyRepositoryImpl(
    remoteSource: getIt<CurrencyRemoteSource>(),
    cache: getIt<LocalStorage>(),
  );
  getIt.registerLazySingleton<CurrencyRepository>(
    () => currencyRepository,
  );

  // Use Cases
  final getDollarHistory = GetDollarHistory(
    getIt<CurrencyRepository>(),
  );
  getIt.registerLazySingleton<GetDollarHistory>(
    () => getDollarHistory,
  );

  final getEuroHistory = GetEuroHistory(
    getIt<CurrencyRepository>(),
  );
  getIt.registerLazySingleton<GetEuroHistory>(
    () => getEuroHistory,
  );

  // Stores
  final dollarChartStore = DollarChartStore(
    getIt<GetDollarHistory>(),
  );
  getIt.registerLazySingleton<DollarChartStore>(
    () => dollarChartStore,
  );

  final euroChartStore = EuroChartStore(
    getIt<GetEuroHistory>(),
  );
  getIt.registerLazySingleton<EuroChartStore>(
    () => euroChartStore,
  );
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
          centerTitle: false,
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
          centerTitle: false,
        ),
      ),
      themeMode: ThemeMode.dark, // Her zaman dark mode
      home: const HomePage(),
    );
  }
}

/// Ana Sayfa
/// 
/// Dolar chart'ı gösterir
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final DollarChartStore _dollarStore;
  late final EuroChartStore _euroStore;

  @override
  void initState() {
    super.initState();
    _dollarStore = GetIt.instance<DollarChartStore>();
    _euroStore = GetIt.instance<EuroChartStore>();
    // Chart'ları yükle
    _dollarStore.loadChart();
    _euroStore.loadChart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              DollarChartWidget(store: _dollarStore),
              const SizedBox(height: AppSpacing.md),
              EuroChartWidget(store: _euroStore),
            ],
          ),
        ),
      ),
    );
  }
}
