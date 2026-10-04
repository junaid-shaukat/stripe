import 'package:flutter/material.dart';

import '/core/app_export.dart';

/// A class that offers pre-defined button styles for customizing button appearance.
class ButtonStyles {
  // text button style
  static ButtonStyle get none => ButtonStyle(
    backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
    elevation: WidgetStateProperty.all<double>(0),
  );

  static ButtonStyle get fillPrimary => ElevatedButton.styleFrom(
    backgroundColor: appTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.h)),
  );

  /// Splash — transparent system navigation button (back / home / recents).
  static ButtonStyle get systemNavIcon => ButtonStyle(
    backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
    foregroundColor: WidgetStateProperty.all<Color>(appTheme.systemNavIcon),
    overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
    padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
      EdgeInsets.all(8),
    ),
    minimumSize: const WidgetStatePropertyAll<Size>(Size(40, 40)),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    shape: const WidgetStatePropertyAll<OutlinedBorder>(CircleBorder()),
    elevation: const WidgetStatePropertyAll<double>(0),
  );

  /// Splash — active opacity for pressed system navigation buttons.
  static ButtonStyle get systemNavIconPressed => systemNavIcon.copyWith(
    foregroundColor: WidgetStateProperty.all<Color>(appTheme.white),
  );
}
