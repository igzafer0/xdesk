import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../cache/hive_storage.dart';
import '../cache/local_storage.dart';
import '../network/api_client.dart';
import '../store/app_store.dart';
import 'injection.config.dart';

/// GetIt instance
final getIt = GetIt.instance;

/// Initializes dependency injection
/// 
/// Injectable annotation'ları ile otomatik DI setup
@InjectableInit(initializerName: 'init', preferRelativeImports: true, asExtension: true)
Future<void> configureDependencies({
  required String apiBaseUrl,
}) async {
  // Hive Storage'ı başlat (Injectable ile otomatik register edilecek ama init gerekli)
  final storage = HiveStorage();
  final storageInitResult = await storage.init();
  
  storageInitResult.fold(
    (failure) => throw Exception('Storage başlatılamadı: ${failure.message}'),
    (_) => null,
  );

  // Injectable ile otomatik register (HiveStorage)
  getIt.init();

  // API Client için config gerekli, manuel register (Injectable değil, config gerekiyor)
  if (!getIt.isRegistered<ApiClient>()) {
    final apiClient = ApiClient(
      config: ApiConfig(baseUrl: apiBaseUrl),
    );
    getIt.registerLazySingleton<ApiClient>(() => apiClient);
  }

  // AppStore'u kaydet (Injectable değil, manuel)
  final appStore = AppStore();
  getIt.registerLazySingleton<AppStore>(() => appStore);
}

/// Clears all registered dependencies
/// 
/// Test veya logout sonrası kullanılabilir.
void resetDependencies() {
  getIt.reset();
}

