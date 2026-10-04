# App Structure — `stripe` (Flutter)

> Root: `c:\Users\codin\Desktop\stripe\stripe`
> Package name: `stripe` · Dart SDK `^3.13.5`

## 1. Architecture at a glance

The project follows a **layered "GetX Clean Architecture"** layout with a barrel-export style.

```
lib/
├── main.dart                 # App entry point
├── core/                     # Foundation: DI, networking, services, models, utils
├── localization/             # i18n (GetX Translations)
├── presentation/             # Feature screens (one folder per feature)
├── routes/                   # Named routes / GetPage list
├── theme/                    # Design system (colors, text, buttons, decorations)
└── widgets/                  # Reusable UI components + vendored 3rd-party widgets
```

**Intended dependency direction:**

```
presentation  ->  routes  ->  core (services, network, models)
                          ->  core/utils (helpers, state, storage)
                          ->  localization, theme, widgets
```

Rule of thumb enforced in code: **almost every file imports a single barrel, `/core/app_export.dart`**, instead of importing packages one-by-one. That barrel re-exports every third-party package *and* every project folder.

---

## 2. File-by-file and folder-by-folder purpose
### 2.4 `lib/core/services/`
All are **singletons** (`X._internal()` + `static final instance`), i.e. usable without GetX registration.

| File | Purpose |
|---|---|
| `connectivity.dart` | `ConnectivityController extends GetxController` — wraps `connectivity_plus`; exposes `RxBool isConnected` and `connectionStream`, re-evaluated in `onInit`/`onClose`. Registered in GetX so `Api` can `Get.find<ConnectivityController>()`. |
| `location_service.dart` | `LocationService` — resolves current device coordinates into a human-readable address (`getCurrentAddress(LatLng)`), delegating the lookup to `NominatimService` and caching through `Preference`. |
| `nominatim_service.dart` | `NominatimService` — thin wrapper over `nominatim_flutter`; performs forward/reverse geocoding search calls through `Api`. |
| `permission_service.dart` | `PermissionService` — runtime permission orchestration: `check()` (refresh every `Permissions.all` status and report whether all required ones are granted, skipping `ignore`d ones), `status(Permission)`, and `request(Permission)` with re-entrancy guards (`_requesting` / `_currentRequest`) so concurrent calls cannot double-trigger the OS dialog. |
| `stripe_service.dart` | `StripeService` — configures `flutter_stripe` at startup: sets `Stripe.publishableKey` (from `Preference`, falling back to a test key), `merchantIdentifier` (`merchant.flutter.stripe.test`), `urlScheme` (`flutterstripe`), then `Stripe.instance.applySettings()`. Required before any PaymentSheet call. |
| `export.dart` | Barrel for services. |

### 2.5 `lib/core/utils/`
| File | Purpose |
|---|---|
| `preference.dart` | `Preference` singleton over **Hive** (`Box` named `preferences`). Holds `static baseUrl` (`http://192.168.1.11:8000`) and typed getters — `accessToken`, `refreshToken`, `publishableKey`, `merchantIdentifier`, `urlScheme`, `become`, `languageCode`, `currencyCode`, `currencySymbol`, `countryCode`, `countryPhoneCode`, `onboarding`. CRUD helpers: `init()`, `getKey()`, `saveKey()`, `saveKeys()`, `deleteKey()`, `clear()`, `readAll()`, `toJson()`. |
| `props.dart` | `Props<T>` — **the app's generic async-state container**, a `GetxController` holding reactive `data`, `state` (`PropState`: initial/loading/refreshing/success/error), `error`, `type` (`ErrorType`: none/network), `paginator`, and `extra`. Exposes `isLoading` / `isSuccess` / … getters and `setInitial/setLoading/setRefreshing/setSuccess/setError/clear`. Internally drives the global `ProgressDialog`, **appends** list data when `hasMore` is set (pagination), and preserves old data on `null` (background refresh). This is the standard way controllers expose state to widgets. |
| `paginator.dart` | `Paginator` — Laravel-style pagination metadata (`perPage`, `page`, `nextPageUrl`, `hasMorePages`) with `fromJson`, `toJson`, `copyWith`, and a `nextPage` getter. Consumed by the `Props.hasMore` logic. |
| `exception.dart` | Exception hierarchy: `AppException` (abstract) → `NetworkException`, `InternalError`; plus `CustomException` and `BadResponse` (both carry `message`, `status`, `success`, `data`, `errors` and expose `toJson`). Thrown by `Api`, caught by `Props.setError`. |
| `toast.dart` | Toast system: `ToastParams` (title/message), `ToastOptions` (colors, radius, gravity, durations, icon, iconSize, dismissible), and `Toast` — a singleton wrapper over `fluttertoast`'s `FToast` with `init(context)`, `show()`, and presets (`success`, `error`, `custom`, …). Builds an SVG-icon-capable rounded container via `_buildToast` / `_buildIconWidget`. |
| `progress_dialog.dart` | `ProgressDialog.onStart()` / `onStop()` — global blocking `Get.dialog` + `CircularProgressIndicator` tinted with `appTheme.primary`, guarded by a static `isVisible` flag. Pairs with the `indicator` flag in `Api` and `Props`. |
| `console.dart` | `Console` logging utility (wraps `debugPrint`, prefixes a labelled `name:`) used by `Api`'s `LogInterceptor`, `Preference`, and `Props.setError`. |
| `validator.dart` | Form validators returning localized `String?` errors: `isEmailAddress`, `isFullName`, `isMobileNumber`, `isPassword` (min 8), `isConfirmPassword`, `isPinCode` (6 digits) — each with an `isRequired` toggle and `.trParams` messages. |
| `size_utils.dart` | Responsive scaling. Figma reference viewport (`fdw = 375`, `fdh = 812`), `ResponsiveExtension` so any `num` gets `.h` / `.fSize` (used as e.g. `15.fSize`), `FormatExtension` (`toDoubleValue`, `isNonZero`), `DeviceType` enum, and `SizeUtils` (static `width`/`height`/`orientation`/`statusBarHeight`) populated by the `Sizer` widget (`LayoutBuilder` + `OrientationBuilder`). |
| `function.dart` | `FileUtils` — large extension→MIME lookup (image/video/audio/font/text/document/archive), plus `extension()`, `mimeType()`, `type()` classification and `isImage/isVideo/isAudio/isFont/isText/isApplication` checks with custom-extension overrides. `Fn.uploadFileMeta()` builds the `{alt, name, size, mime_type, type, extension}` metadata map sent with uploads. |
| `file_picker.dart` | `FilePickers` — unified file acquisition returning `dart:io File`: `pickFile()` (wraps `file_picker` with platform options) and `pickImageFromCamera()`, `pickImageFromGallery()`, `pickVideo()` (via `image_picker`). |
| `image_constant.dart` | Central asset path registry — `logo`, `customerService`, `marker`, `background` (`assets/icons/*.svg`, `assets/images/background.png`). **Note:** the `assets/` folders currently contain 0 files. |
| `firebase_options.dart` | Generated Firebase config (`apiKey`, `appId`, `messagingSenderId`, `projectId`, …) for `Firebase.initializeApp`. |
| `export.dart` | Barrel for all utils. |

<!-- APPEND-MARKER -->

### 2.1 `lib/main.dart`
Dart entry point calling `runApp()`. Currently it contains the **default Flutter counter demo** (`MyApp` / `MyHomePage`) — it is **not yet wired to the real app shell**. Intended responsibilities:
- `WidgetsFlutterBinding.ensureInitialized()`
- Initialize Firebase (`Firebase.initializeApp(options: FirebaseOptions)`) and Hive (`Preference.instance.init()`)
- Configure Stripe (`StripeService.instance.onInit()`)
- Register GetX bindings/services and build `GetMaterialApp` with `AppRoutes.pages`, `AppLocalization`, `appTheme`, `navigatorKey`, and call `Toast.init(context)`

### 2.2 `lib/core/` — Foundation layer
Everything non-visual the whole app depends on: DI, controllers, models, networking, platform services, helpers.

| Path | Purpose |
|---|---|
| `core/app_export.dart` | **The master barrel.** Re-exports ~40 pub packages (GetX, Dio, Firebase, flutter_stripe, flutter_map, Hive, permission_handler…) with `hide` clauses for name collisions, plus every project folder barrel (`/core/bindings/export.dart`, `/core/utils/export.dart`, `/routes/app_routes.dart`, …). Also declares the global `navigatorKey` used for deep links / navigation. |
| `core/bindings/` | GetX **dependency-injection bindings** (extend `Bindings`, register controllers/services via `Get.put`/`Get.lazyPut`). `export.dart` is currently **empty (0 bytes)** — placeholder. |
| `core/controllers/` | GetX **controllers** (presentation logic / view-models). `export.dart` is **empty** — placeholder. Business logic is meant to live here, not inside widgets. |
| `core/models/` | Domain + transport models, split into `data/` and `http/`. |
| `core/models/export.dart` | Barrel: `export 'data/export.dart'; export 'http/export.dart';` |
| `core/models/data/` | Local / UI-facing data models. |
| `core/models/data/export.dart` | Barrel: `export 'permission.dart';` |
| `core/models/data/permission.dart` | `Permissions` model + static `Permissions.all` catalogue (location, camera, notifications) holding `title`, `icon`, `key` (permission_handler `Permission`), `description`, and a reactive `Rx<PermissionStatus> status`. Drives the runtime permission screen. |
| `core/models/http/` | HTTP envelope / response-wrapper models (`.data`, `.message`, `.errors`, `.status`, `.success`) consumed by `Api.responseHandler` through a `transform()` contract. `export.dart` is **empty** — placeholder. |

### 2.3 `lib/core/network/`
| File | Purpose |
|---|---|
| `api_client.dart` | Singleton `Api` on **Dio**. Interceptors inject `Accept`, `Content-Type`, `Accept-Language`, `Accept-Currency` and `Authorization: Bearer <token>` from `Preference`; a `{{baseUrl}}` placeholder in paths is swapped for `Preference.baseUrl` at request time; a `LogInterceptor` routes output through the project `console`. `get()`/`post()` short-circuit when offline (`connectivity.isConnected.isFalse` → `NetworkException`), auto show/hide `ProgressDialog` via the `indicator` flag, and normalize results/errors via `responseHandler()` / `handleDioException()` (Dio timeout/connection/bad-response → `CustomException`, `NetworkException`, `BadResponse`, `InternalError`). |
| `endpoints.dart` | `Endpoints` class of `static const` API paths (all `{{baseUrl}}/api/v2/...`). Groups: **Auth** (signIn, signUp, resetPassword, changePassword), **Sync**, **Preference**, **Localization** (translations, languages), **Geo/Finance** (countries, cities, currencies, exchangeRates), **Catalog** (services, serviceQuestions, howItWorks, categories, options, subOptions, tags, features, plans, privacyPolicies), **Bookings/Payments** (bookings, booking, jobs, payments, paymentIntent, uploadBooking). |
| `export.dart` | Barrel for the network layer. |

<!-- APPEND-MARKER -->