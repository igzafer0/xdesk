/// Core Package - Infrastructure Layer for XDesk
/// 
/// Bu paket tüm feature modüllerinin kullandığı altyapıyı sağlar.
/// 
/// İçerik:
/// - Errors: Failure sınıfları ve error mapping
/// - Cache: LocalStorage interface ve Hive implementation
/// - Network: API Client, Interceptors
/// - Store: Global AppStore (MobX)
/// - DI: Dependency Injection setup

// Errors
export 'src/errors/failures.dart';
export 'src/errors/error_mapper.dart';

// Cache
export 'src/cache/local_storage.dart';
export 'src/cache/hive_storage.dart';

// Network
export 'src/network/api_client.dart';
export 'src/network/interceptors/logging_interceptor.dart';

// Store
export 'src/store/app_store.dart';

// DI
export 'src/di/injection.dart';
