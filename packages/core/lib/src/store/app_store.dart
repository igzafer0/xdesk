import 'package:mobx/mobx.dart';

part 'app_store.g.dart';

/// Global Application Store
/// 
/// Uygulama genelinde kullanılan state'leri tutar.
/// User, Auth, Theme gibi global state'ler burada.
@StoreConfig()
class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  /// User authentication state
  @observable
  bool isAuthenticated = false;

  /// Current user ID (if authenticated)
  @observable
  String? userId;

  /// Current user email (if authenticated)
  @observable
  String? userEmail;

  /// Loading state
  @observable
  bool isLoading = false;

  /// Error message (if any)
  @observable
  String? errorMessage;

  /// Sets authentication state
  @action
  void setAuthenticated({
    required bool value,
    String? userId,
    String? userEmail,
  }) {
    isAuthenticated = value;
    this.userId = userId;
    this.userEmail = userEmail;
    
    // Eğer logout ise, tüm user bilgilerini temizle
    if (!value) {
      this.userId = null;
      this.userEmail = null;
    }
  }

  /// Sets loading state
  @action
  void setLoading(bool value) {
    isLoading = value;
  }

  /// Sets error message
  @action
  void setError(String? message) {
    errorMessage = message;
  }

  /// Clears error message
  @action
  void clearError() {
    errorMessage = null;
  }

  /// Logout action
  @action
  void logout() {
    setAuthenticated(value: false);
    clearError();
  }
}

