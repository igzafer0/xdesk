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
/// Injectable annotation'ları eklendi ama cross-module dependency'ler
/// (ApiClient, LocalStorage) manuel register ediliyor.
/// Gelecekte Injectable module system ile tam otomatik hale getirilebilir.
void setupFinanceDependencies() {
  final getIt = GetIt.instance;

  // Data Sources (Injectable annotation var ama cross-module dependency manuel)
  final currencyRemoteSource = CurrencyRemoteSource(getIt<ApiClient>());
  getIt.registerLazySingleton<CurrencyRemoteSource>(() => currencyRemoteSource);

  // Repositories (Injectable annotation var ama cross-module dependency manuel)
  final currencyRepository = CurrencyRepositoryImpl(
    remoteSource: getIt<CurrencyRemoteSource>(),
    cache: getIt<LocalStorage>(),
  );
  getIt.registerLazySingleton<CurrencyRepository>(() => currencyRepository);

  // Use Cases (Injectable annotation var)
  final getDollarHistory = GetDollarHistory(getIt<CurrencyRepository>());
  getIt.registerLazySingleton<GetDollarHistory>(() => getDollarHistory);

  final getEuroHistory = GetEuroHistory(getIt<CurrencyRepository>());
  getIt.registerLazySingleton<GetEuroHistory>(() => getEuroHistory);

  // Stores (Injectable annotation var)
  final dollarChartStore = DollarChartStore(getIt<GetDollarHistory>());
  getIt.registerLazySingleton<DollarChartStore>(() => dollarChartStore);

  final euroChartStore = EuroChartStore(getIt<GetEuroHistory>());
  getIt.registerLazySingleton<EuroChartStore>(() => euroChartStore);
}
