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

### 2.1 `lib/main.dart`
Dart entry point calling `runApp()`. Currently it contains the **default Flutter counter demo** (`MyApp` / `MyHomePage`) — it is **not yet wired to the real app shell**. Intended responsibilities:

- `WidgetsFlutterBinding.ensureInitialized()`
- Initialize Firebase (`Firebase.initializeApp(options: FirebaseOptions)`) and Hive (`Preference.instance.init()`)
- Configure Stripe (`StripeService.instance.onInit()`)
- Register GetX bindings/services and build `GetMaterialApp` with `AppRoutes.pages`, `AppLocalization`, `appTheme`, `navigatorKey`, plus `Toast.init(context)`

### 2.2 `lib/core/` — Foundation layer
Everything non-visual that the whole app depends on: DI, controllers, models, networking, platform services, helpers.

| Path | Purpose |
|---|---|
| `core/app_export.dart` | **The master barrel.** Re-exports ~40 pub packages (GetX, Dio, Firebase, flutter_stripe, flutter_map, Hive, permission_handler…) with `hide` clauses for name collisions, plus every project folder barrel (`/core/bindings/export.dart`, `/core/utils/export.dart`, `/routes/app_routes.dart`, …). Also declares the global `navigatorKey` used for deep links / navigation. |
| `core/bindings/` | GetX **dependency-injection bindings** (extend `Bindings`, register controllers/services via `Get.put` / `Get.lazyPut`). `export.dart` is currently **empty (0 bytes)** — placeholder. |
| `core/controllers/` | GetX **controllers** (presentation logic / view-models). `export.dart` is **empty** — placeholder. Business logic is meant to live here, not inside widgets. |
| `core/models/` | Domain + transport models, split into `data/` and `http/`. |
| `core/models/export.dart` | Barrel: `export 'data/export.dart'; export 'http/export.dart';` |
| `core/models/data/` | Local / UI-facing data models. |
| `core/models/data/export.dart` | Barrel: `export 'permission.dart';` |
| `core/models/data/permission.dart` | `Permissions` model plus static `Permissions.all` catalogue (location, camera, notifications) holding `title`, `icon`, `key` (permission_handler `Permission`), `description` and a reactive `Rx<PermissionStatus> status`. Drives the runtime permission screen. |
| `core/models/http/` | HTTP envelope / response-wrapper models (`.data`, `.message`, `.errors`, `.status`, `.success`) consumed by `Api.responseHandler` through a `transform()` contract. `export.dart` is **empty** — placeholder. |

### 2.3 `lib/core/network/`
| File | Purpose |
|---|---|
| `api_client.dart` | Singleton `Api` on **Dio**. Interceptors inject `Accept`, `Content-Type`, `Accept-Language`, `Accept-Currency` and `Authorization: Bearer <token>` from `Preference`; a `{{baseUrl}}` placeholder in paths is swapped for `Preference.baseUrl` at request time; a `LogInterceptor` routes output through the project `console`. `get()` / `post()` short-circuit when offline (`connectivity.isConnected.isFalse` → `NetworkException`), auto show/hide `ProgressDialog` via the `indicator` flag, and normalize results/errors through `responseHandler()` / `handleDioException()` (Dio timeout / connection / bad-response → `CustomException`, `NetworkException`, `BadResponse`, `InternalError`). |
| `endpoints.dart` | `Endpoints` class of `static const` API paths (all `{{baseUrl}}/api/v2/...`). Groups: **Auth** (signIn, signUp, resetPassword, changePassword), **Sync**, **Preference**, **Localization** (translations, languages), **Geo/Finance** (countries, cities, currencies, exchangeRates), **Catalog** (services, serviceQuestions, howItWorks, categories, options, subOptions, tags, features, plans, privacyPolicies), **Bookings/Payments** (bookings, booking, jobs, payments, paymentIntent, uploadBooking). |
| `export.dart` | Barrel for the network layer. |

### 2.4 `lib/core/services/`
All are **singletons** (`X._internal()` + `static final instance`), i.e. usable without GetX registration.

| File | Purpose |
|---|---|
| `connectivity.dart` | `ConnectivityController extends GetxController` — wraps `connectivity_plus`; exposes `RxBool isConnected` and `connectionStream`, re-evaluated in `onInit` / `onClose`. Registered in GetX so `Api` can `Get.find<ConnectivityController>()`. |
| `location_service.dart` | `LocationService` — resolves current device coordinates into a human-readable address (`getCurrentAddress(LatLng)`), delegating the lookup to `NominatimService` and caching through `Preference`. |
| `nominatim_service.dart` | `NominatimService` — thin wrapper over `nominatim_flutter`; performs forward / reverse geocoding search calls through `Api`. |
| `permission_service.dart` | `PermissionService` — runtime permission orchestration: `check()` (refresh every `Permissions.all` status and report whether all required ones are granted, skipping `ignore`d ones), `status(Permission)`, and `request(Permission)` with re-entrancy guards (`_requesting` / `_currentRequest`) so concurrent calls cannot double-trigger the OS dialog. |
| `stripe_service.dart` | `StripeService` — configures `flutter_stripe` at startup: sets `Stripe.publishableKey` (from `Preference`, falling back to a test key), `merchantIdentifier` (`merchant.flutter.stripe.test`), `urlScheme` (`flutterstripe`), then `Stripe.instance.applySettings()`. Required before any PaymentSheet call. |
| `export.dart` | Barrel for services. |

### 2.5 `lib/core/utils/`
| File | Purpose |
|---|---|
| `preference.dart` | `Preference` singleton over **Hive** (`Box` named `preferences`). Holds `static baseUrl` (`http://192.168.1.11:8000`) and typed getters — `accessToken`, `refreshToken`, `publishableKey`, `merchantIdentifier`, `urlScheme`, `become`, `languageCode`, `currencyCode`, `currencySymbol`, `countryCode`, `countryPhoneCode`, `onboarding`. CRUD helpers: `init()`, `getKey()`, `saveKey()`, `saveKeys()`, `deleteKey()`, `clear()`, `readAll()`, `toJson()`. |
| `props.dart` | `Props<T>` — **the app's generic async-state container**, a `GetxController` holding reactive `data`, `state` (`PropState`: initial / loading / refreshing / success / error), `error`, `type` (`ErrorType`: none / network), `paginator`, and `extra`. Exposes `isLoading` / `isSuccess` / … getters and `setInitial` / `setLoading` / `setRefreshing` / `setSuccess` / `setError` / `clear`. Internally drives the global `ProgressDialog`, **appends** list data when `hasMore` is set (pagination), and preserves old data on `null` (background refresh). This is the standard way controllers expose state to widgets. |
| `paginator.dart` | `Paginator` — Laravel-style pagination metadata (`perPage`, `page`, `nextPageUrl`, `hasMorePages`) with `fromJson`, `toJson`, `copyWith` and a `nextPage` getter. Consumed by the `Props.hasMore` logic. |
| `exception.dart` | Exception hierarchy: `AppException` (abstract) → `NetworkException`, `InternalError`; plus `CustomException` and `BadResponse` (both carry `message`, `status`, `success`, `data`, `errors` and expose `toJson`). Thrown by `Api`, caught by `Props.setError`. |
| `toast.dart` | Toast system: `ToastParams` (title / message), `ToastOptions` (colors, radius, gravity, durations, icon, iconSize, dismissible), and `Toast` — a singleton wrapper over `fluttertoast`'s `FToast` with `init(context)`, `show()`, and presets (`success`, `error`, `custom`, …). Builds an SVG-icon-capable rounded container via `_buildToast` / `_buildIconWidget`. |
| `progress_dialog.dart` | `ProgressDialog.onStart()` / `onStop()` — global blocking `Get.dialog` + `CircularProgressIndicator` tinted with `appTheme.primary`, guarded by a static `isVisible` flag. Pairs with the `indicator` flag in `Api` and `Props`. |
| `console.dart` | `Console` logging utility (wraps `debugPrint`, prefixes a labelled `name:`) used by the `LogInterceptor` in `Api`, by `Preference`, and by `Props.setError`. |
| `validator.dart` | Form validators returning localized `String?` errors: `isEmailAddress`, `isFullName`, `isMobileNumber`, `isPassword` (min 8), `isConfirmPassword`, `isPinCode` (6 digits) — each with an `isRequired` toggle and `.trParams` messages. |
| `size_utils.dart` | Responsive scaling. Figma reference viewport (`fdw = 375`, `fdh = 812`), `ResponsiveExtension` so any `num` gets `.h` / `.fSize` (used as e.g. `15.fSize`), `FormatExtension` (`toDoubleValue`, `isNonZero`), a `DeviceType` enum, and `SizeUtils` (static `width` / `height` / `orientation` / `statusBarHeight`) populated by the `Sizer` widget (`LayoutBuilder` + `OrientationBuilder`). |
| `function.dart` | `FileUtils` — large extension→MIME lookup (image / video / audio / font / text / document / archive), plus `extension()`, `mimeType()`, `type()` classification and `isImage` / `isVideo` / `isAudio` / `isFont` / `isText` / `isApplication` checks with custom-extension overrides. `Fn.uploadFileMeta()` builds the `{alt, name, size, mime_type, type, extension}` metadata map sent with uploads. |
| `file_picker.dart` | `FilePickers` — unified file acquisition returning `dart:io File`: `pickFile()` (wraps `file_picker` with platform options) and `pickImageFromCamera()`, `pickImageFromGallery()`, `pickVideo()` (via `image_picker`). |
| `image_constant.dart` | Central asset path registry — `logo`, `customerService`, `marker`, `background` (`assets/icons/*.svg`, `assets/images/background.png`). **Note:** the `assets/` folders currently contain 0 files. |
| `firebase_options.dart` | Generated Firebase config (`apiKey`, `appId`, `messagingSenderId`, `projectId`, …) for `Firebase.initializeApp`. |
| `export.dart` | Barrel for all utils. |

### 2.6 `lib/localization/`
| File | Purpose |
|---|---|
| `app_localization.dart` | `AppLocalization extends GetX Translations`. Declares supported locales **`en`, `ar`, `ur`** (English, Arabic, Urdu), resolves `locale` from `Get.deviceLocale` with `en` fallback, and holds the in-code `translations` map (`seyanah`, `initializing...`, `premium_home_services`, `dependable_expert_care`) exposed through `keys`. The `/translations` + `/languages` endpoints exist, so remote strings can later override this map. |

### 2.7 `lib/presentation/` — Feature screens
One folder per feature, each with an `index.dart` barrel so `presentation/export.dart` can re-export screens. **All are currently empty placeholders (0–2 bytes) — the UI is not implemented yet.**

| Folder | Intended screen | `index.dart` |
|---|---|---|
| `splash/` | App launch / bootstrap while Firebase, Hive, Stripe and permissions initialize | empty |
| `onboarding/` | First-run carousel intro (`carousel_slider_plus`, `smooth_page_indicator`) | empty |
| `permission/` | Runtime permission rationale screen driven by `Permissions.all` + `PermissionService` | empty |
| `sign_in/` | Email / password login (validators from `Validator`) | empty |
| `sign_up/` | Registration / account creation | empty |
| `forgot_password/` | Password reset flow (`Endpoints.resetPassword`) | empty |
| `home/` | Main post-login shell with `custom_bottom_nav_bar` | empty |
| `export.dart` | Barrel exporting all seven feature barrels | — |

### 2.8 `lib/routes/`
| File | Purpose |
|---|---|
| `app_routes.dart` | `AppRoutes` — declares `initialRoute = '/'`, `splash = '/splash'`, and the `static List<GetPage> pages` consumed by `GetMaterialApp(getPages: AppRoutes.pages)`. The `GetPage` entries for splash / initial are present but **commented out**, so routing is not wired yet. Constants for `signIn` / `signUp` / `forgotPassword` / `home` are expected here. |

### 2.9 `lib/theme/` — Design system
| File | Purpose |
|---|---|
| `theme_helper.dart` | The largest theme file (~26 KB). Exposes `ThemeData get theme => ThemeHelper().themeData()`. Contains `ThemeHelper` (builds `ThemeData`), `TextThemes.textTheme(colorScheme)`, `ColorSchemes.light`, `Gradients` (`signature`, `primaryAction`, `orb`, `warm`, `cool` and their `LinearGradient`s), `AppShadows` (`card`, `cta`, `floating`, `focusGlow`), `AppInputs` (`InputDecoration` factory), `ColorCodes` (raw hex palette), `Rounded` (radius scale sm→full), and `Spacing` (4-pt spacing scale, per-breakpoint margins, `maxContentWidth`). |
| `button_style.dart` | Button `ButtonStyle` definitions (intended). **Empty (0 bytes).** |
| `text_style.dart` | Named `TextStyle` tokens (intended). **Empty (0 bytes).** |
| `decoration.dart` | Shared `BoxDecoration` / `Border` builders (intended). **Empty (0 bytes).** |
| `export.dart` | Barrel: `decoration.dart`, `button_style.dart`, `text_style.dart`, `theme_helper.dart`. |

### 2.10 `lib/widgets/` — Reusable UI
App-specific components plus two **vendored third-party widget libraries** copied into the project (so they can be themed/customized freely).

**App-specific widgets**

| File | Purpose |
|---|---|
| `base_button.dart` | `BaseButton` — shared button primitive (text, width / height, margin, alignment, disabled flag, `ButtonStyle`, text style). **Stub:** `build` currently returns `SizedBox.shrink()`. |
| `custom_app_bar.dart` | Themed app bar. **Empty placeholder.** |
| `custom_bottom_nav_bar.dart` | Bottom navigation for the `home` shell. **Empty placeholder.** |
| `custom_button.dart` | Branded primary / secondary button. **Empty placeholder.** |
| `custom_card.dart` | Surface card using `AppShadows.card`. **Empty placeholder.** |
| `custom_image_view.dart` | Network / asset / SVG image with placeholder + cache. **Empty placeholder.** |
| `custom_input.dart` | Form field wrapper using `AppInputs.decoration`. **Empty placeholder.** |
| `custom_pin_code_field.dart` | OTP entry field (wraps `pin_code_fields`). **Empty placeholder.** |
| `custom_radio_button.dart` | Themed radio control. **Empty placeholder.** |
| `custom_skeletonizer.dart` | App-level loading placeholder built on the bundled skeletonizer. **Empty placeholder.** |
| `custom_toggle.dart` | Themed switch (wraps `flutter_switch`). **Empty placeholder.** |
| `custom_input_mask_formatter.dart` | `Masked implements TextInputFormatter` (plus private `_TextMatcher`) — a fully implemented text-masking formatter (phone, card number, etc.) with named mask patterns. |
| `export.dart` | Barrel exporting all custom widgets, `dropdown_button/dropdown_button2.dart`, and `skeletonizer/export.dart`. |

**`widgets/dropdown_button/` — vendored copy of the `dropdown_button2` package** (advanced dropdown with search, tags and custom item rendering)

| File | Purpose |
|---|---|
| `dropdown_button2.dart` | Main `DropdownButton2` widget — the public API and its controller. |
| `dropdown_menu.dart` | `DropdownMenu` / item-scaffolding logic for the open list. |
| `dropdown_menu_item.dart` | Item widget: title, subtitle, leading icon, trailing widgets, selected state. |
| `dropdown_route.dart` | The full-screen / overlay route that renders the open dropdown list. |
| `dropdown_style_data.dart` | Style & metrics configuration (heights, padding, decoration, elevation, scrollbar). |
| `button_style_data.dart` | Style configuration for the closed-state button. |
| `dropdown_menu_separators.dart` | Divider / separator widgets used between items. |
| `enums.dart` | `DropdownSearchMode`, `DropdownMenuAlignment` and related enums. |
| `seperated_sliver_child_builder_delegate.dart` | Sliver delegate for separated (divider-between-items) scrollable lists. *(filename spelling "seperated" comes from the vendored source.)* |
| `utils.dart` | Small internal helpers. |

**`widgets/skeletonizer/` — vendored copy of the `skeletonizer` package** (shimmer / pulse loading placeholders implemented with a custom render object)

| File | Purpose |
|---|---|
| `skeletonizer.dart` | `Skeletonizer` abstract StatefulWidget — wraps `child`, `enabled`, `effect` and config; paints the child as a skeleton. |
| `skeleton.dart` | `Skeleton` — the concrete user-facing widget (`dark` / `light` variants) used in screens. |
| `skeletonizer_render_object_widget.dart` | `SkeletonizerRenderObjectWidget` — `SingleChildRenderObjectWidget` that creates the `RenderSkeletonizer`. |
| `render_skeletonizer.dart` | `RenderSkeletonizer` — layout / paint logic that replaces the child with skeleton shapes. |
| `skeletonizer_config.dart` | `SkeletonizerConfigData extends ThemeExtension` — theme-level config (bone colors, radius, spacing, `TextBoneBorderRadius`, dark / light defaults). |
| `skeletonizer_painting_context.dart` | `SkeletonizerPaintingContext extends PaintingContext` — converts `Text` / `Icon` / `Image` renderers into bones. |
| `uniting_painting_context.dart` | `UnitingCanvas` — unites all painted rects into a single rect so adjacent bones merge into one shape. |
| `bone.dart` | `Bone` widget — the animated skeleton block (highlight, direction, ignore pointer). |
| `bone_mock.dart` | `BoneMock` — non-animated bone used for measurement / preview. |
| `painting_effect.dart` | `PaintingEffect` abstract base for shimmer / pulse / solid effects. |
| `shimmer_effect.dart` | `ShimmerEffect` — travelling highlight gradient. |
| `pulse_effect.dart` | `PulseEffect` — opacity pulsing animation. |
| `solid_color_effect.dart` | `SolidColorEffect` — static non-animated fill (plus the deprecated `SoldColorEffect` typedef for back-compat). |
| `text_utils.dart` | `lineToRect(...)` — approximates the bounding `Rect` of a text line (handles justification / alignment). |
| `utils.dart` | `PaintX.copyWith()` — clones a `Paint` with a different color / shader. |
| `widgets.dart` | Convenience barrel: `skeletonizer.dart` + `bone.dart`. |
| `export.dart` | Full barrel for the skeletonizer library. |

---

## 3. Supporting directories outside `lib/`

| Path | Purpose |
|---|---|
| `android/`, `ios/` | Platform host projects. |
| `assets/` | Declared in `pubspec.yaml` (`assets/`, `assets/fonts/`, `assets/icons/`, `assets/images/`). Sub-folders `fonts/`, `icons/`, `images/` exist but are **currently empty (0 files)** — needed before `ImageConstant` paths resolve. |
| `pubspec.yaml` | Dependencies: GetX 4, Dio 5, Hive CE, Firebase (auth / core / messaging / crashlytics), **flutter_stripe 14**, flutter_map + geolocator + latlong2 + nominatim_flutter, permission_handler, connectivity_plus, cached_network_image, carousel_slider_plus, easy_date_timeline, Google ML Kit translate / language-id, flutter_secure_storage, file_picker / image_picker, flutter_local_notifications and more. Dev: build_runner + hive_ce_generator. |
| `analysis_options.yaml` | Lint configuration (`flutter_lints 6`). |
| `.dart_tool/`, `.idea/`, `stripe.iml` | IDE / tooling generated files. |
| `README.md` | Project readme. |

---

## 4. Request / data flow (how the pieces connect)

```
Widget (presentation/*)
  |  reads reactive state
  v
Props<T> / GetX Controller        (core/utils/props.dart, core/controllers/)
  |  calls
  v
Service (core/services/*)   ---or---   Api.instance.get/post   (core/network)
                                         |  interceptors: auth header, baseUrl swap,
                                         |                  Accept-Language, logging
                                         v
                                       Dio  ->  Laravel /api/v2/*   (Endpoints)
                                         |  errors -> CustomException / BadResponse
                                         v
                                       Props.setError(...) -> ProgressDialog + Toast + state
```

State is persisted in **Hive** through `Preference` (tokens, locale, currency, Stripe keys) and read back by `Api`'s interceptor on every request.

---

## 5. Current implementation status / gaps

1. **`main.dart` is the stock Flutter counter demo** — not bootstrapped with Firebase, Hive, Stripe, GetX bindings, routes or theme.
2. **`AppRoutes.pages` entries are commented out** — navigation is not connected.
3. **`core/bindings/export.dart`, `core/controllers/export.dart` and `core/models/http/export.dart` are empty** — DI, controllers and HTTP envelope models are still to be written.
4. **All 7 `presentation/*/index.dart` files are empty** — no screens exist yet.
5. **`theme/button_style.dart`, `theme/text_style.dart` and `theme/decoration.dart` are empty** — only `theme_helper.dart` is implemented.
6. **Most `widgets/custom_*.dart` files are empty stubs**; only `custom_input_mask_formatter.dart` has real code, and `base_button.dart` is stubbed (`SizedBox.shrink()`).
7. **`assets/` folders are empty** — the SVG / PNG paths in `ImageConstant` and the toast icons will not render until assets are added.
8. `Preference.baseUrl` is a hardcoded LAN address (`http://192.168.1.11:8000`) — consider `--dart-define` / flavors before release.
9. `FileUtils` / `FilePickers` use `dart:io`, so they will not compile for web targets.

---

## 6. Conventions to follow when adding code

- Import `/core/app_export.dart`; do not add per-package imports in feature files.
- Add the new file to the nearest `export.dart` barrel, and that barrel to `app_export.dart`.
- Screens go in `lib/presentation/<feature>/index.dart`; register a `GetPage` in `AppRoutes.pages` and add the path constant in `AppRoutes`.
- Controllers extend `GetxController` and expose `Props<T>`; call `setLoading()` → `setSuccess(data)` / `setError(message)`.
- Singleton services: `X._internal()` + `static final instance = X._internal();`
- Register global services in a `Bindings` class under `core/bindings/`.
- User-facing strings: add the key to **all three** locale maps in `app_localization.dart`, then use `.tr` / `.trParams`.
- Spacing / sizing: prefer `Spacing.*`, `Rounded.*`, and the `16.h` / `15.fSize` extensions over raw numbers.
- Show loading with `ProgressDialog.onStart()` / `onStop()` (or `indicator: true` on API calls) and feedback with `Toast.success` / `Toast.error` / `Toast.custom`.
- New API paths go in `core/network/endpoints.dart` prefixed with `{{baseUrl}}`.
