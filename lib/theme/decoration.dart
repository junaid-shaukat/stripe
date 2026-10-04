import 'package:flutter/material.dart';

import '/core/app_export.dart';

class Decorations {
  static BoxDecoration get white => BoxDecoration(color: appTheme.white);

  /// Splash — circular white brand emblem card.
  static BoxDecoration get splashBadge => BoxDecoration(
    color: appTheme.white,
    shape: BoxShape.circle,
    boxShadow: AppShadows.splashBadge,
  );

  /// Splash — soft ambient glow painted behind the emblem.
  static const BoxDecoration splashAmbientGlow = BoxDecoration(
    gradient: Gradients.splashAmbient,
  );

  /// Splash — tagline dot indicators.
  static BoxDecoration taglineDot(bool isMagenta) => BoxDecoration(
    color: isMagenta ? appTheme.aintisMagenta : appTheme.dotIndigo,
    shape: BoxShape.circle,
    boxShadow: isMagenta ? AppShadows.glowMagentaDot : AppShadows.glowIndigoDot,
  );

  /// Splash — android style navigation bar.
  static BoxDecoration get systemNavBar =>
      BoxDecoration(color: appTheme.systemNavBar);

  /// Splash — device frame surface.
  static BoxDecoration get splashSurface => BoxDecoration(
    color: appTheme.splashSurface,
    border: Border.all(color: appTheme.splashFrameBorder, width: 0.5),
  );
}
