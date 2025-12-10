import 'package:get_it/get_it.dart';
import '../presentation/stores/home_store.dart';

/// Home modülü bağımlılıklarını kaydeder
///
/// Bu fonksiyon home modülünün tüm bağımlılıklarını GetIt'e kaydeder.
/// Finance modülüne bağımlı değil, callback'ler dışarıdan verilir.
void setupHomeDependencies({
  required List<void Function()> refreshCallbacks,
}) {
  final getIt = GetIt.instance;

  // Home Store
  final homeStore = HomeStore(
    refreshCallbacks: refreshCallbacks,
  );
  getIt.registerLazySingleton<HomeStore>(
    () => homeStore,
  );
}

