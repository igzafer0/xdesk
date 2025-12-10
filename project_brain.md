# 🧠 PROJECT BRAIN (Proje Beyni)

> **⚠️ KRİTİK:** Her geliştirme yapılmadan önce bu dosya kontrol edilmelidir. Bu dosya projenin "beyni"dir ve tüm kararlar buradan çıkar.

---

## 📋 GELİŞTİRME ÖNCESİ CHECKLIST

Her yeni feature, modül veya değişiklik yapılmadan önce aşağıdaki maddeler kontrol edilmelidir:

### ✅ Mimari Kontrolleri

- [ ] **Modül Bağımsızlığı:** Yeni feature başka bir feature modülünü import ediyor mu? ❌ YASAK!
- [ ] **Core Bağımlılığı:** Tüm ortak işlevler `packages/core` üzerinden mi yapılıyor?
- [ ] **Katman Ayrımı:** Domain, Data, Presentation katmanları doğru ayrılmış mı?
- [ ] **Context-Free:** Logic sınıflarında `BuildContext` kullanılıyor mu? ❌ YASAK!

### ✅ State Management Kontrolleri

- [ ] **MobX Kullanımı:** `setState` kullanılıyor mu? ❌ YASAK! Sadece MobX Store + Observer.
- [ ] **Provider Kullanımı:** `Provider` veya `InheritedWidget` kullanılıyor mu? ❌ YASAK!
- [ ] **GetIt Injection:** Tüm bağımlılıklar `GetIt` ile inject ediliyor mu?
- [ ] **Atomik Rebuild:** Sadece değişen widget'lar `Observer` içinde mi?

### ✅ Performans Kontrolleri

- [ ] **Main Thread:** JSON parse, filtreleme, ağır işlemler `Isolates` (compute) içinde mi?
- [ ] **JSON Parsing:** JSON parsing işlemleri top-level fonksiyonlar ile `compute()` içinde mi?
- [ ] **Tree Shaking:** Kullanılmayan import'lar ve kütüphaneler temizlenmiş mi?
- [ ] **Cache-First:** Veri önce cache'den mi gösteriliyor, sonra güncelleniyor mu?

### ✅ Hata Yönetimi Kontrolleri

- [ ] **Explicit Error:** `try-catch` ile hata yutulmuş mu? ❌ YASAK!
- [ ] **Either Tipi:** Fonksiyonlar `Either<Failure, Success>` döndürüyor mu?
- [ ] **Kullanıcı Mesajı:** Teknik hata (404, 500) yerine anlamlı mesaj gösteriliyor mu?
- [ ] **Hata Loglama:** Kritik olmayan hatalar (cache parse) loglanıyor mu? (debugPrint)
- [ ] **fold() Async:** `fold()` içinde async callback kullanılmış mı? ❌ YASAK!

### ✅ UI/UX Kontrolleri

- [ ] **Dark Mode:** Sadece dark mode renkleri kullanılmış mı? (#000000, #121212)
- [ ] **Türkçe:** Tüm metinler Türkçe mi?
- [ ] **Feedback:** Kullanıcı aksiyonlarında Snackbar/Toast gösteriliyor mu?

### ✅ Kod Kalitesi Kontrolleri

- [ ] **Code Generation:** MobX, Retrofit, JSON için `build_runner` çalıştırılmış mı?
- [ ] **Linter:** `flutter analyze` hatasız geçiyor mu?
- [ ] **Test:** Yeni kod için unit test yazılmış mı? (Domain ve Data katmanları için zorunlu)

---

## 🚫 YAPILMAYACAKLAR LİSTESİ (KIRMIZI ÇİZGİLER)

Bu maddeler **ASLA** yapılmamalıdır:

1. ❌ **Feature modülleri birbirini import etmez** → Core üzerinden haberleşme (ADR-008)
2. ❌ **Provider veya InheritedWidget kullanılmaz** → Sadece GetIt + MobX
3. ❌ **setState kullanılmaz** → Sadece MobX Store + Observer
4. ❌ **BuildContext logic katmanına sokulmaz** → Context-free architecture
5. ❌ **try-catch ile hata yutulmaz** → Either<Failure, Success> kullanılır
6. ❌ **Main thread'de ağır işlem yapılmaz** → Isolates (compute) kullanılır (ADR-010)
7. ❌ **fold() içinde async callback kullanılmaz** → Async işlemler fold() dışında yapılır
8. ❌ **Skeleton loading veya loading yapısı kullanılmaz** → Loading state gösterilmez
9. ❌ **Light mode desteği eklenmez** → Sadece dark mode
10. ❌ **Kullanılmayan kod ve kütüphane bırakılmaz** → Tree shaking

---

## 🎯 MİMARİ KARARLAR (ARCHITECTURE DECISIONS)

### ADR-001: MobX vs Provider
**Karar:** MobX kullanılacak, Provider kullanılmayacak.
**Neden:** Granüler rebuild, yüksek performans, atomik güncellemeler.
**Alternatifler:** Provider, Riverpod, Bloc → Reddedildi.

### ADR-002: GetIt vs Provider
**Karar:** GetIt + Injectable kullanılacak.
**Neden:** Context-free architecture, test edilebilirlik, compile-time safety.
**Alternatifler:** Provider, Riverpod → Reddedildi.

### ADR-003: fpdart Either vs Exception
**Karar:** Either<Failure, Success> pattern kullanılacak.
**Neden:** Fonksiyonel hata yönetimi, explicit error handling, type safety.
**Alternatifler:** try-catch, Result pattern → Reddedildi.

### ADR-004: Hive vs SQLite
**Karar:** Hive kullanılacak (interface arkasında).
**Neden:** Ultra hızlı, NoSQL, şifrelenebilir, basit API.
**Not:** Interface sayesinde değiştirilebilir.
**Alternatifler:** SQLite, Drift, SharedPreferences → Reddedildi.

### ADR-005: Offline-First Strategy
**Karar:** Cache-first yaklaşımı kullanılacak.
**Neden:** Kullanıcı deneyimi, offline çalışma, performans.
**Uygulama:** Veri varsa cache'den göster → Arka planda güncelle → UI'ı güncelle.

### ADR-006: Dark Mode Only
**Karar:** Sadece dark mode desteklenecek.
**Neden:** Tutarlılık, geliştirme hızı, kullanıcı deneyimi odaklı.
**Alternatifler:** Light/Dark toggle → Reddedildi (gelecekte eklenebilir).

### ADR-007: Authentication Token Mekanizması
**Karar:** Token mekanizması kaldırıldı. Tüm API istekleri authentication olmadan yapılır.
**Neden:** Şu an için authentication gerekmemesi, basitlik ve geliştirme hızı.
**Not:** Gelecekte authentication gerektiğinde token mekanizması tekrar eklenebilir.
**Alternatifler:** JWT Token, OAuth, API Key → Şu an için gerekli değil.

### ADR-008: Module Independence Pattern
**Karar:** Feature modülleri birbirini import etmez. Modüller arası iletişim callback pattern ile yapılır.
**Neden:** Modülerlik, bağımsızlık, test edilebilirlik, gelecekte ayrı paketlere dönüştürülebilirlik.
**Uygulama:** Ana uygulama (main.dart) modülleri birleştirir ve callback'ler üzerinden haberleştirir.
**Örnek:** Home modülü finance modülünü import etmez, refresh callback'leri alır.

### ADR-009: Auto-Refresh Mechanism
**Karar:** Chart verileri 10 saniyede bir otomatik olarak yenilenir.
**Neden:** Güncel veri gösterimi, kullanıcı deneyimi.
**Uygulama:** HomeStore içinde Timer.periodic kullanılır, callback'ler üzerinden chart'lar yenilenir.

### ADR-010: JSON Parsing in Isolates
**Karar:** Tüm JSON parsing işlemleri `compute()` ile isolate'te yapılır.
**Neden:** Main thread'i bloklamamak, UI performansı, kullanıcı deneyimi.
**Uygulama:** Top-level fonksiyonlar oluşturulur ve `compute()` ile çağrılır.

---

## 📊 PROJE DURUMU (PROJECT STATUS)

### ✅ Tamamlanan Modüller

#### Core Paketi (packages/core)
- ✅ **Errors Modülü:** Failure sınıfları ve error mapping
- ✅ **Cache Modülü:** LocalStorage interface ve Hive implementation
- ✅ **Network Modülü:** API Client (Dio), Interceptors (Logging)
- ✅ **Store Modülü:** Global AppStore (MobX) - User state yönetimi
- ✅ **DI Modülü:** GetIt + Injectable dependency injection setup
- ✅ **Export:** Tüm modüller core.dart üzerinden export edildi

#### Design System Paketi (packages/design_system)
- ✅ **Tokens:** Colors, Spacing, Typography
- ✅ **Components:** Buttons, Cards, Inputs
- ✅ **Dark Mode:** Sadece dark mode renkleri

#### Finance Modülü (packages/features/finance)
- ✅ **Domain:** CurrencyChart, CurrencyChartPoint entities, UseCases, Repository interface
- ✅ **Data:** CurrencyRemoteSource, CurrencyRepositoryImpl, DTOs
- ✅ **Presentation:** DollarChartStore, EuroChartStore, Chart widgets (fl_chart)
- ✅ **Features:** Dollar ve Euro chart'ları, son 24 saat verisi, cache-first yaklaşım
- ✅ **DI:** Finance injection setup (Injectable annotations)

#### Home Modülü (packages/features/home)
- ✅ **Presentation:** HomePage, HomeStore
- ✅ **Features:** Auto-refresh mekanizması (10 saniye), callback pattern ile modül bağımsızlığı
- ✅ **DI:** Home injection setup

#### Ana Uygulama
- ✅ Dark mode tema kuruldu (Design System kullanılıyor)
- ✅ Core, Finance, Home modülleri entegre edildi
- ✅ Dependency Injection setup tamamlandı
- ✅ Ana sayfa: Dollar ve Euro chart'ları gösteriliyor
- ✅ Auto-refresh: Chart'lar 10 saniyede bir otomatik yenileniyor

#### Konfigürasyon
- ✅ Melos workspace kuruldu
- ✅ VS Code launch.json yapılandırıldı
- ✅ Proje dokümantasyonu hazır

### 🚧 Devam Eden / Planlanan

- ⏳ **Test Coverage:** Unit testler (Domain ve Data katmanları için)
- ⏳ **Yeni Feature Modülleri:** News, Account (gelecekte)
- ⏳ **Error Monitoring:** Production error tracking (gelecekte)

---

## 📐 KATMAN MİMARİSİ KURALLARI

### Domain Katmanı
- ✅ **Saf Dart kodu** (Flutter import'u yok)
- ✅ **Entities, UseCases, Repository Interfaces**
- ✅ **Dış dünyadan habersiz** (API/DB bilgisi yok)
- ❌ Flutter widget'ları, BuildContext, Material/Cupertino import'u

### Data Katmanı
- ✅ **DTOs, DataSources, Repository Implementations**
- ✅ **API ve Cache ile konuşur**
- ✅ **Hataları yakalayıp `Failure` nesnesine çevirir**
- ✅ **Either<Failure, Success> döndürür**

### Presentation Katmanı
- ✅ **MobX Stores, Screens, Widgets**
- ✅ **Sadece Store'u dinler (`Observer`) ve çizer**
- ❌ UI mantığı içermez (mantık Store'da)
- ❌ Provider kullanılmaz

---

## 🔄 GELİŞTİRME AKIŞI (DEVELOPMENT FLOW)

### Yeni Feature Ekleme

1. **Planlama:**
   - [ ] Feature modülü `packages/features/` altında oluşturulacak
   - [ ] Domain, Data, Presentation katmanları planlanacak
   - [ ] Core'dan hangi servisler kullanılacak belirlenecek

2. **Oluşturma:**
   ```bash
   cd packages/features
   flutter create --template=package feature_name
   ```

3. **Katmanlar:**
   ```
   feature_name/
   ├── lib/
   │   ├── domain/
   │   │   ├── entities/
   │   │   ├── use_cases/
   │   │   └── repositories/
   │   ├── data/
   │   │   ├── dtos/
   │   │   ├── data_sources/
   │   │   └── repositories/
   │   └── presentation/
   │       ├── stores/
   │       ├── screens/
   │       └── widgets/
   ```

4. **Bağımlılıklar:**
   - Core paketi path dependency olarak eklenir
   - Feature modülleri birbirini import etmez

5. **Kod Üretimi:**
   ```bash
   melos run build
   ```

6. **Test:**
   ```bash
   melos run test:diff
   ```

---

## 🧪 TEST STRATEJİSİ

### Zorunlu Testler

- ✅ **Domain Katmanı:** Tüm UseCases için unit test
- ✅ **Data Katmanı:** Repository implementations için unit test
- ✅ **Core:** Tüm utility ve servisler için test

### İsteğe Bağlı Testler

- ⚠️ **Presentation:** Widget testleri (kritik widget'lar için)
- ⚠️ **Integration:** E2E testler (öncelikli feature'lar için)

### Test Komutları

```bash
# Sadece değişen paketler
melos run test:diff

# Tüm paketler
melos run test:all

# Belirli bir paket
cd packages/core && flutter test
```

---

## 🎨 UI STANDARTLARI

### Renk Paleti (Dark Mode Only)

```dart
// Sadece bu renkler kullanılacak
const Color black = Color(0xFF000000);        // #000000
const Color darkGrey = Color(0xFF121212);     // #121212
const Color grey = Color(0xFF1E1E1E);         // #1E1E1E (opsiyonel)
```

### Error States

- ✅ **Error State:** Anlamlı hata mesajı + retry butonu

### Feedback

- ✅ **Snackbar:** Başarılı işlemler için
- ✅ **Toast:** Bilgilendirme mesajları için
- ✅ **Dialog:** Kritik onaylar için

---

## 📦 PAKET YÖNETİMİ

### Melos Komutları

```bash
# Bootstrap (ilk kurulum veya bağımlılık değişikliği sonrası)
melos bootstrap

# Kod üretimi (MobX, Retrofit, JSON)
melos run build

# Temizlik
melos run clean

# Test (değişen paketler)
melos run test:diff

# Test (tüm paketler)
melos run test:all
```

### Yeni Paket Ekleme

1. Paketi oluştur: `flutter create --template=package package_name`
2. `melos.yaml`'a ekle (otomatik algılanır)
3. `melos bootstrap` çalıştır
4. Bağımlılıkları ekle ve `melos bootstrap` tekrar çalıştır

---

## 🔍 CODE REVIEW CHECKLIST

Her PR/MR öncesi kontrol edilecekler:

- [ ] Tüm checklist maddeleri geçti mi?
- [ ] `flutter analyze` hatasız mı?
- [ ] Testler geçiyor mu?
- [ ] `melos run build` başarılı mı?
- [ ] Kullanılmayan kod temizlenmiş mi?
- [ ] Dokümantasyon güncellenmiş mi? (gerekirse)

---

## 📝 NOTLAR VE ÖNEMLİ HATIRLATMALAR

1. **Main Thread Kutsaldır:** UI asla donmamalı, ağır işlemler Isolates'te (ADR-010).
2. **Cache-First:** Her zaman cache'den başla, sonra güncelle (ADR-005).
3. **Explicit Errors:** Hata yutma, Either kullan. Cache parse hataları loglanır (debugPrint).
4. **Modülerlik:** Feature'lar birbirinden bağımsız, callback pattern ile haberleşir (ADR-008).
5. **Context-Free:** Logic'te BuildContext yok.
6. **Dark Mode Only:** Sadece dark renkler (ADR-006).
7. **Türkçe:** Tüm kullanıcı metinleri Türkçe.
8. **Auth Yok:** Tüm API istekleri authentication olmadan yapılır (ADR-007).
9. **Auto-Refresh:** Chart verileri 10 saniyede bir otomatik yenilenir (ADR-009).
10. **fold() Sync:** `fold()` içinde async callback kullanılmaz, async işlemler dışarıda yapılır.

---

## 🚀 HIZLI REFERANS

### Yeni Feature Başlatma
```bash
cd packages/features
flutter create --template=package feature_name
cd ../../..
melos bootstrap
```

### Kod Üretimi
```bash
melos run build
```

### Test
```bash
melos run test:diff
```

### Temizlik
```bash
melos run clean
```

---

**Son Güncelleme:** Finance ve Home modülleri tamamlandı, Design System eklendi  
**Versiyon:** 1.2.0  
**Bakım:** Bu dosya her önemli mimari karar sonrası güncellenmelidir.

---

## 📝 DEĞİŞİKLİK GEÇMİŞİ (CHANGELOG)

### v1.2.0 - Finance ve Home Modülleri Tamamlandı
- ✅ Design System paketi tamamlandı (Tokens, Components)
- ✅ Finance modülü tamamlandı (Dollar ve Euro chart'ları)
- ✅ Home modülü tamamlandı (HomePage, HomeStore, auto-refresh)
- ✅ Module independence pattern uygulandı (ADR-008)
- ✅ Auto-refresh mekanizması eklendi (10 saniye, ADR-009)
- ✅ JSON parsing isolate'te yapılıyor (ADR-010)
- ✅ Cache parse hataları loglanıyor (debugPrint)
- ✅ `fold()` içinde async callback sorunu düzeltildi
- ✅ Injectable annotations kullanılıyor
- ✅ Ana uygulama entegrasyonu tamamlandı

### v1.1.0 - Core Paketi Tamamlandı
- ✅ Core paketi modülleri tamamlandı (Errors, Cache, Network, Store, DI)
- ✅ Token mekanizması kaldırıldı (ADR-007)
- ✅ VS Code launch.json yapılandırıldı
- ✅ Proje dokümantasyonu güncellendi

### v1.0.0 - İlk Kurulum
- ✅ Melos workspace kuruldu
- ✅ Proje yapısı oluşturuldu
- ✅ Mimari anayasa hazırlandı

