import 'package:fpdart/fpdart.dart';
import '../errors/failures.dart';

/// Local Storage Interface
/// 
/// Cache işlemleri için abstraction layer.
/// Hive implementation'ı bu interface'in arkasında gizlenir.
/// Böylece gelecekte Hive yerine başka bir storage kullanılabilir.
abstract class LocalStorage {
  /// Saves a value with the given key
  /// 
  /// Returns Either<Failure, void> - Explicit error handling
  Future<Either<Failure, void>> save<T>({
    required String key,
    required T value,
  });

  /// Gets a value by key
  /// 
  /// Returns Either<Failure, T?> - Explicit error handling
  Future<Either<Failure, T?>> get<T>({
    required String key,
  });

  /// Deletes a value by key
  /// 
  /// Returns Either<Failure, void> - Explicit error handling
  Future<Either<Failure, void>> delete({
    required String key,
  });

  /// Checks if a key exists
  /// 
  /// Returns Either<Failure, bool> - Explicit error handling
  Future<Either<Failure, bool>> containsKey({
    required String key,
  });

  /// Clears all stored data
  /// 
  /// Returns Either<Failure, void> - Explicit error handling
  Future<Either<Failure, void>> clear();

  /// Gets all keys
  /// 
  /// Returns Either<Failure, List<String>> - Explicit error handling
  Future<Either<Failure, List<String>>> getAllKeys();
}

