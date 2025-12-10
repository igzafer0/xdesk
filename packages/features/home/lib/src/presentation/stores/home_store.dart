import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'home_store.g.dart';

/// Home Store
///
/// Ana sayfa state'ini ve otomatik yenileme mantığını yönetir.
/// Finance modülüne bağımlı değil, callback'ler üzerinden çalışır.
@StoreConfig()
class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  /// Chart'ları yenilemek için callback fonksiyonlar
  final List<VoidCallback> refreshCallbacks;

  Timer? _refreshTimer;
  static const Duration _refreshInterval = Duration(seconds: 10);

  _HomeStore({
    required this.refreshCallbacks,
  });

  /// Chart'ları yükler ve otomatik yenilemeyi başlatır
  @action
  void initialize() {
    // İlk yükleme
    for (final callback in refreshCallbacks) {
      callback();
    }

    // Otomatik yenileme timer'ını başlat
    _refreshTimer = Timer.periodic(
      _refreshInterval,
      (_) {
        for (final callback in refreshCallbacks) {
          callback();
        }
      },
    );
  }

  /// Otomatik yenilemeyi durdurur
  @action
  void dispose() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }
}

