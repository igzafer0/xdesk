# 🏛️ PROJECT CONSTITUTION (MİMARİ ANAYASA)

| Proje Bilgileri | Detaylar |
| :--- | :--- |
| **Proje Adı** | [XDesk] |
| **Vizyon** | Hyperscale (10 Milyar Kullanıcı), Zero-Latency (Mutlak Performans) |
| **Mimari** | Modular Monolith (Melos) + Clean Architecture |
| **State Management** | MobX + GetIt (Provider Yok) |
| **Öncelik** | Offline-First & Dark Mode Only |

 ---

## 0: DAY 1 ACTION PLAN (Başlangıç Listesi)

Projeyi sıfırdan kurarken takip edilecek sıralı adımlar:

- [ ] **1. Ortam Hazırlığı:**
  - `dart pub global activate melos` komutu ile Melos'u kur.
  - VS Code kullanıyorsan "Melos" ve "Flutter MobX" eklentilerini yükle.

- [ ] **2. Klasör İskeleti:**
  - Proje kök dizinini oluştur.
  - `apps/super_app` ve `packages/core` klasörlerini fiziksel olarak yarat.
  - Kök dizine `melos.yaml` dosyasını ekle.

- [ ] **3. Core Modülü Kurulumu (Kritik):**
  - `packages/core` içine gir ve `flutter create --template=package .` çalıştır.
  - `pubspec.yaml` içine `mobx`, `flutter_mobx`, `dio`, `get_it`, `injectable`, `fpdart` ekle.

- [ ] **4. Bağlama (Bootstrap):**
  - Kök dizine dön ve terminalde `melos bootstrap` komutunu çalıştır.
  - Başarılı olduysa, artık modüler yapın kodlamaya hazır demektir. 🚀
---


## 1. ⚔️ THE IRON RULES (Temel Prensipler)

Bu kurallar projenin performans ve sürdürülebilirliği için tartışmaya kapalıdır.

| Kategori | Kural | Uygulama Yöntemi |
| :--- | :--- | :--- |
| **PERFORMANS** | **Main Thread Kutsaldır** | JSON parse, filtreleme ve ağır matematiksel işlemler kesinlikle `Isolates` (compute) içinde yapılacaktır. UI asla donmamalıdır. |
| **PERFORMANS** | **Atomik Rebuild** | Sayfalar `setState` ile çizilmez. Sadece değişen veri `Observer` widget'ı içine alınır. |
| **PERFORMANS** | **Tree Shaking** | Kullanılmayan kodlar ve kütüphaneler projede barınamaz. Paket boyutu minimumda tutulur. |
| **OFFLINE** | **Cache-First** | Veri varsa önce Cache'den gösterilir, sonra internetten güncellenir. İnternet yoksa uygulama tam fonksiyon çalışmaya devam eder. |
| **HATA YÖNETİMİ** | **Explicit Error** | `try-catch` ile hata yutulmaz. Fonksiyonlar `Either<Failure, Success>` döndürür. Kullanıcıya teknik hata (404) değil, anlamlı mesaj gösterilir. |
| **MODÜLERLİK** | **Strict Boundaries** | Feature modülleri (Finance, News) birbirini **ASLA** import etmez. Haberleşme `Core` üzerinden yapılır. |
| **BAĞIMLILIK** | **Context-Free** | `Provider` veya `InheritedWidget` kullanılmaz. Logic sınıflarına `BuildContext` sokulmaz. Her şey `GetIt` ile inject edilir. |

## 2. 🛠️ TECH STACK (Teknoloji Yığını)

| Alan | Teknoloji | Seçim Nedeni |
| :--- | :--- | :--- |
| **Workspace** | `Melos` | Çoklu paket yönetimi ve script otomasyonu. |
| **Language** | `Dart 3.x` | Pattern matching, Records, Null-safety. |
| **State Mng.** | `MobX` | Granüler rebuild ve yüksek performans. |
| **DI** | `GetIt` + `Injectable` | Bağımlılık enjeksiyonu ve test edilebilirlik. |
| **Network** | `Dio` + `Retrofit` | Type-safe HTTP istemcisi ve Interceptor yeteneği. |
| **Data Type** | `fpdart` | Fonksiyonel hata yönetimi (`Either` tipi). |
| **Local DB** | `Hive` | NoSQL, şifrelenebilir, ultra hızlı yerel veritabanı. |
| **Navigation** | `GoRouter` | String bazlı, deep-link destekli routing. |
| **Code Gen** | `build_runner` | MobX, JsonSerializable otomasyonu. |

---

## 3. 📂 MONOREPO MAP (Klasör Yapısı)

```text
root/
├── melos.yaml             # Orkestra Şefi
├── apps/
│   └── super_app/         # (SHELL) Sadece birleştirici kabuk.
│
└── packages/
    ├── core/              # ⚡️ ALTYAPI (HERKES BURAYA BAĞLI)
    │   ├── network/       # Dio Client & Interceptors
    │   ├── store/         # Global AppStore (MobX - User/Auth)
    │   ├── cache/         # LocalStorage Interface (Hive gizlenmiş)
    │   └── errors/        # Failure Sınıfları
    │
    ├── design_system/     # 🎨 GÖRSEL DİL
    │   ├── tokens/        # Colors, Spacings
    │   └── components/    # Buttons, Cards, Inputs
    │
    └── features/          # 🚀 İŞ MODÜLLERİ (BİRBİRİNDEN BAĞIMSIZ)
        ├── finance/       # Borsa & Finans Modülü
        ├── news/          # Haber Modülü
        └── account/       # Profil Modülü

## 4. 🧱 FEATURE ARCHITECTURE (Katman Mimarisi)

Her feature modülü (Örn: `finance`) kendi içinde şu katmanlara ayrılır:

| Katman | İçerik | Görevi | Kurallar |
| :--- | :--- | :--- | :--- |
| **DOMAIN** | `Entities`, `UseCases`, `Repo Interfaces` | **İş Kuralları** | Saf Dart. Flutter kodu barındıramaz. Dış dünyadan (API/DB) habersizdir. |
| **DATA** | `DTOs`, `DataSources`, `Repo Impl` | **Veri Yönetimi** | API ve Cache ile konuşur. Hataları yakalayıp `Failure` nesnesine çevirir. |
| **PRESENTATION** | `MobX Stores`, `Screens`, `Widgets` | **Kullanıcı Arayüzü** | UI mantığı içermez. Sadece Store'u dinler (`Observer`) ve çizer. `Provider` kullanılmaz. |


## 5. 🎨 UI & UX STANDARTLARI

| Özellik | Standart |
| :--- | :--- |
| **Tema** | **Sadece Dark Mode**. Siyah (#000000) ve Koyu Gri (#121212) tonları. |
| **Dil** | Türkçe (tr). Altyapı `l10n` uyumlu kurulur. |
| **Feedback** | Kullanıcı aksiyonlarında görsel geri bildirim (Snackbar/Toast) zorunludur. |
| **Loading** | "Skeleton" (İskelet) yükleme ekranları kullanılır. Boş ekran gösterilmez. |

---

## 6. 🚀 MELOS CHEAT SHEET (Komutlar)

Geliştirme sırasında kullanılacak temel komutlar:

| Komut | Açıklama |
| :--- | :--- |
| `melos bootstrap` | Projeyi kurar, paketleri birbirine bağlar ve `pub get` yapar. |
| `melos run build` | Tüm paketlerdeki kod üretimini (MobX, Retrofit, JSON) çalıştırır. |
| `melos run clean` | Projedeki tüm `build` dosyalarını ve cache'leri temizler. |
| `melos run test:diff` | Sadece üzerinde değişiklik yapılan paketin testlerini çalıştırır. |

