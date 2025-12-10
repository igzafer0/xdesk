import 'package:get_it/get_it.dart';
import 'package:core/core.dart';
import '../data/data_sources/currency_remote_source.dart';
import '../data/repositories/currency_repository_impl.dart';
import '../domain/repositories/currency_repository.dart';
import '../domain/use_cases/get_dollar_history.dart';
import '../domain/use_cases/get_euro_history.dart';
import '../presentation/stores/dollar_chart_store.dart';
import '../presentation/stores/euro_chart_store.dart';

/// Finance modülü bağımlılıklarını kaydeder
///
/// Bu fonksiyon finance modülünün tüm bağımlılıklarını GetIt'e kaydeder.
void setupFinanceDependencies() {
  final getIt = GetIt.instance;

  // Data Sources
  final currencyRemoteSource = CurrencyRemoteSource(getIt<ApiClient>());
  getIt.registerLazySingleton<CurrencyRemoteSource>(() => currencyRemoteSource);

  // Repositories
  final currencyRepository = CurrencyRepositoryImpl(
    remoteSource: getIt<CurrencyRemoteSource>(),
    cache: getIt<LocalStorage>(),
  );
  getIt.registerLazySingleton<CurrencyRepository>(() => currencyRepository);

  // Use Cases
  final getDollarHistory = GetDollarHistory(getIt<CurrencyRepository>());
  getIt.registerLazySingleton<GetDollarHistory>(() => getDollarHistory);

  final getEuroHistory = GetEuroHistory(getIt<CurrencyRepository>());
  getIt.registerLazySingleton<GetEuroHistory>(() => getEuroHistory);

  // Stores
  final dollarChartStore = DollarChartStore(getIt<GetDollarHistory>());
  getIt.registerLazySingleton<DollarChartStore>(() => dollarChartStore);

  final euroChartStore = EuroChartStore(getIt<GetEuroHistory>());
  getIt.registerLazySingleton<EuroChartStore>(() => euroChartStore);
}
