# NamHockey

A Flutter application for managing and following a hockey league. Supports multiple user roles — **admin**, **coach**, **player**, and regular user — each with tailored features. Powered by **Supabase** as the backend.

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `≥ 3.7.2`
- A [Supabase](https://supabase.com) project with the URL and anon key ready
- Android Studio / Xcode for device/emulator builds

### Installation

1. **Clone the repository**
   ```bash
   git clone <repo-url>
   cd namhockey
   ```

2. **Install all dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase secrets**  
   Add your Supabase URL and anon key to `lib/core/secrets/app_secrets.dart`:
   ```dart
   class AppSecrets {
     static const supabaseUrl = 'YOUR_SUPABASE_URL';
     static const supabaseKey = 'YOUR_SUPABASE_ANON_KEY';
   }
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

---

## Dependencies

### Quick Reference

| Package | Version | Install command |
|---|---|---|
| `flutter_bloc` | `^9.1.0` | `flutter pub add flutter_bloc` |
| `supabase_flutter` | `^2.8.4` | `flutter pub add supabase_flutter` |
| `get_it` | `^8.0.3` | `flutter pub add get_it` |
| `fpdart` | `^1.1.1` | `flutter pub add fpdart` |
| `dartz` | `^0.10.1` | `flutter pub add dartz` |
| `equatable` | `^2.0.5` | `flutter pub add equatable` |
| `iconly` | `^1.0.1` | `flutter pub add iconly` |
| `image_picker` | `^1.1.2` | `flutter pub add image_picker` |
| `cached_network_image` | `^3.4.1` | `flutter pub add cached_network_image` |
| `flutter_lints` *(dev)* | `^5.0.0` | `flutter pub add dev:flutter_lints` |

---

### `flutter_bloc` `^9.1.0`

State management library implementing the BLoC (Business Logic Component) pattern with `Bloc` and `Cubit` classes built on Dart streams.

**Used for:** Every feature has its own BLoC (`AuthBloc`, `GamesBloc`, `NewsBloc`, `LiveMatchBloc`, `DiscussionBloc`). `AppUserCubit` tracks the global logged-in user. UI uses `BlocProvider`, `BlocBuilder`, `BlocConsumer`, and `BlocListener`.

```bash
flutter pub add flutter_bloc
```

---

### `supabase_flutter` `^2.8.4`

Official Flutter client for [Supabase](https://supabase.com) — provides PostgreSQL database, Auth, and Storage APIs.

**Used for:** User sign-up/login/logout/session restore, all database reads and writes (games, news, messages, teams), and file uploads (profile pictures, team logos).

```bash
flutter pub add supabase_flutter
```

> **Platform setup:**
> - **Android:** Set `minSdkVersion 21` in `android/app/build.gradle`
> - **iOS:** Add OAuth URL schemes to `ios/Runner/Info.plist` if using OAuth sign-in
> - **All:** Call `await Supabase.initialize(url: ..., anonKey: ...)` before `runApp()`

---

### `get_it` `^8.0.3`

Simple service locator / dependency injection container for Dart. No code generation required.

**Used for:** A global `serviceLocator` wires all data sources, repositories, use cases, and BLoCs in `init_dependencies.dart`. Uses `registerLazySingleton` for stateless objects and `registerFactory` for BLoCs.

```bash
flutter pub add get_it
```

---

### `fpdart` `^1.1.1`

Functional programming library for Dart providing `Either`, `Option`, `Task`, and more.

**Used for:** Every repository method returns `Future<Either<Failure, T>>`. BLoCs use `.fold()` to handle `Left` (failure) and `Right` (success) outcomes cleanly without scattered try/catch blocks.

```bash
flutter pub add fpdart
```

---

### `dartz` `^0.10.1`

Older functional programming library for Dart with a similar `Either` / `Option` API. Predecessor to `fpdart`.

**Used for:** Present for compatibility in some older parts of the codebase not yet migrated to `fpdart`.

```bash
flutter pub add dartz
```

---

### `equatable` `^2.0.5`

Simplifies value equality in Dart by overriding `==` and `hashCode` based on a `props` list.

**Used for:** `NewsEntity` extends `Equatable`, enabling value-based equality comparisons without manual operator overriding.

```bash
flutter pub add equatable
```

---

### `iconly` `^1.0.1`

A clean, modern icon pack with **light** (outline) and **bold** (filled) variants for each icon.

**Used for:** Bottom navigation bar icons in `main_nav.dart`. Each tab icon switches between `IconlyLight.*` (unselected) and `IconlyBold.*` (selected) for visual feedback.

```bash
flutter pub add iconly
```

---

### `image_picker` `^1.1.2`

Flutter plugin for accessing the device camera and photo gallery.

**Used for:** Picking profile pictures (`UpdateProfileEvent`) and team logos when promoting a user to coach (`MakeCoachEvent`). Selected files are uploaded to Supabase Storage.

```bash
flutter pub add image_picker
```

> **Platform setup:**
> - **iOS** — Add to `ios/Runner/Info.plist`:
>   ```xml
>   <key>NSPhotoLibraryUsageDescription</key>
>   <string>Used to pick profile and team logo images.</string>
>   <key>NSCameraUsageDescription</key>
>   <string>Used to take a profile photo.</string>
>   ```
> - **Android** — No extra setup for API 33+. For older versions add `READ_EXTERNAL_STORAGE` to `AndroidManifest.xml`.

---

### `cached_network_image` `^3.4.1`

Flutter widget for loading and caching images from a URL with placeholder and error widget support.

**Used for:** Displaying all remotely stored images (team logos, profile pictures, news images) from Supabase Storage. Caches images on-device so they load instantly on repeat visits.

```bash
flutter pub add cached_network_image
```

---

## Dev Dependencies

### `flutter_test` (SDK)

The standard Flutter testing framework — built into the SDK, no install needed. Provides `testWidgets`, `expect`, and pump utilities used in the `test/` directory.

### `flutter_lints` `^5.0.0`

Recommended Dart/Flutter lint rules configured via `analysis_options.yaml`. Enforces code style and catches common mistakes at analysis time — no runtime effect.

```bash
flutter pub add dev:flutter_lints
```

---

## Useful Commands

```bash
# Install all dependencies
flutter pub get

# Upgrade packages to latest compatible versions
flutter pub upgrade

# Check for newer package versions
flutter pub outdated

# Run the app
flutter run

# Build for release (Android)
flutter build apk

# Build for release (iOS)
flutter build ios
```

---

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Supabase Documentation](https://supabase.com/docs)
- [flutter_bloc Documentation](https://bloclibrary.dev)
- [pub.dev](https://pub.dev) — Dart & Flutter package registry
