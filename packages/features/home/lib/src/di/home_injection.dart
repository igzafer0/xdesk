import 'package:get_it/get_it.dart';
import 'package:finance/finance.dart';
import '../presentation/stores/home_store.dart';

/// Home modülü bağımlılıklarını kaydeder
///
/// Bu fonksiyon home modülünün tüm bağımlılıklarını GetIt'e kaydeder.
void setupHomeDependencies() {
  final getIt = GetIt.instance;

  // Home Store
  final homeStore = HomeStore(
    dollarChartStore: getIt<DollarChartStore>(),
    euroChartStore: getIt<EuroChartStore>(),
  );
  getIt.registerLazySingleton<HomeStore>(
    () => homeStore,
  );
}

