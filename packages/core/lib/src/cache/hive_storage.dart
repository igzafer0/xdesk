import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../errors/failures.dart';
import 'local_storage.dart';

/// Hive implementation of LocalStorage
/// 
/// Hive kullanarak local storage işlemlerini gerçekleştirir.
/// Interface arkasında gizlenmiştir.
@LazySingleton(as: LocalStorage)
class HiveStorage implements LocalStorage {
  static const String _boxName = 'xdesk_storage';
  Box? _box;

  /// Initializes Hive and opens the storage box
  Future<Either<Failure, void>> init() async {
    try {
      await Hive.initFlutter();
      _box = await Hive.openBox(_boxName);
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure(
          message: 'Storage başlatılamadı: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  /// Closes the storage box
  Future<Either<Failure, void>> close() async {
    try {
      await _box?.close();
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure(
          message: 'Storage kapatılamadı: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> save<T>({
    required String key,
    required T value,
  }) async {
    try {
      if (_box == null) {
        return Left(
          const CacheFailure(
            message: 'Storage başlatılmamış. Lütfen init() çağırın.',
          ),
        );
      }

      await _box!.put(key, value);
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure(
          message: 'Veri kaydedilemedi: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, T?>> get<T>({
    required String key,
  }) async {
    try {
      if (_box == null) {
        return Left(
          const CacheFailure(
            message: 'Storage başlatılmamış. Lütfen init() çağırın.',
          ),
        );
      }

      final value = _box!.get(key) as T?;
      return Right(value);
    } catch (e) {
      return Left(
        CacheFailure(
          message: 'Veri okunamadı: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> delete({
    required String key,
  }) async {
    try {
      if (_box == null) {
        return Left(
          const CacheFailure(
            message: 'Storage başlatılmamış. Lütfen init() çağırın.',
          ),
        );
      }

      await _box!.delete(key);
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure(
          message: 'Veri silinemedi: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> containsKey({
    required String key,
  }) async {
    try {
      if (_box == null) {
        return Left(
          const CacheFailure(
            message: 'Storage başlatılmamış. Lütfen init() çağırın.',
          ),
        );
      }

      return Right(_box!.containsKey(key));
    } catch (e) {
      return Left(
        CacheFailure(
          message: 'Key kontrolü yapılamadı: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> clear() async {
    try {
      if (_box == null) {
        return Left(
          const CacheFailure(
            message: 'Storage başlatılmamış. Lütfen init() çağırın.',
          ),
        );
      }

      await _box!.clear();
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure(
          message: 'Storage temizlenemedi: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAllKeys() async {
    try {
      if (_box == null) {
        return Left(
          const CacheFailure(
            message: 'Storage başlatılmamış. Lütfen init() çağırın.',
          ),
        );
      }

      return Right(_box!.keys.cast<String>().toList());
    } catch (e) {
      return Left(
        CacheFailure(
          message: 'Key\'ler alınamadı: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }
}

