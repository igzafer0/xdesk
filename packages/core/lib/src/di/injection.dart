import 'package:get_it/get_it.dart';

import '../cache/hive_storage.dart';
import '../cache/local_storage.dart';
import '../network/api_client.dart';
import '../store/app_store.dart';

/// GetIt instance
final getIt = GetIt.instance;

/// Initializes dependency injection
/// 
/// Tüm bağımlılıkları GetIt'e kaydeder.
/// Injectable annotation'ları build_runner ile generate edilecek.
Future<void> configureDependencies({
  required String apiBaseUrl,
}) async {
  // Hive Storage'ı başlat
  final storage = HiveStorage();
  final storageInitResult = await storage.init();
  
  storageInitResult.fold(
    (failure) => throw Exception('Storage başlatılamadı: ${failure.message}'),
    (_) => null,
  );

  // LocalStorage'ı kaydet (interface olarak)
  getIt.registerLazySingleton<LocalStorage>(() => storage);

  // AppStore'u kaydet
  final appStore = AppStore();
  getIt.registerLazySingleton<AppStore>(() => appStore);

  // API Client'ı kaydet (auth olmadan)
  final apiClient = ApiClient(
    config: ApiConfig(baseUrl: apiBaseUrl),
  );
  getIt.registerLazySingleton<ApiClient>(() => apiClient);
}

/// Clears all registered dependencies
/// 
/// Test veya logout sonrası kullanılabilir.
void resetDependencies() {
  getIt.reset();
}

