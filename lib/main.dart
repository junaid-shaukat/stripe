import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;

import '/core/app_export.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      // Controllers
      Get.put(ConnectivityController());

      // Local storage
      await HiveInitializer.initialize();
      await Preference.instance.init();
      // Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Crashlytics
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        !kDebugMode,
      );

      // Flutter framework errors
      FlutterError.onError = (FlutterErrorDetails details) {
        console.error(
          details.exception,
          stackTrace: details.stack,
          name: 'main',
        );
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      };

      // Async/platform errors
      PlatformDispatcher.instance.onError = (error, stack) {
        console.error(error, stackTrace: stack, name: 'main');
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);

        return true;
      };

      // Deep links
      // await DeepLinkService.instance.init();

      // Orientation
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

      runApp(const MyApp());

      // Initialize Toast after first frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = navigatorKey.currentContext;

        if (context != null) {
          Toast.init(context);
        }
      });
    },
    (error, stack) {
      console.error(error, stackTrace: stack, name: 'main');
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          theme: theme,
          title: 'Seyanah',
          getPages: AppRoutes.pages,
          navigatorKey: navigatorKey,
          locale: AppLocalization.locale,
          translations: AppLocalization(),
          debugShowCheckedModeBanner: false,
          initialBinding: InitialBindings(),
          initialRoute: AppRoutes.initialRoute,
          fallbackLocale: AppLocalization.fallbackLocale,
          supportedLocales: AppLocalization.supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: ft.FToastBuilder()(context, child),
            );
          },
        );
      },
    );
  }
}
