import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '/core/app_export.dart';

/// AINTIS splash screen.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spinnerController;

  @override
  void initState() {
    super.initState();
    _spinnerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _spinnerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: appTheme.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: appTheme.systemNavBar,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: appTheme.transparent,
      ),
      child: Scaffold(
        backgroundColor: appTheme.splashSurface,
        body: Sizer(
          builder: (context, orientation, deviceType) {
            return Stack(
              fit: StackFit.expand,
              children: [
                // Background ambient light
                Positioned.fill(
                  child: IgnorePointer(
                    child: ColoredBox(
                      color: appTheme.splashSurface,
                      child: DecoratedBox(
                        decoration: Decorations.splashAmbientGlow,
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),
                ),

                // Main content
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Central circular emblem card
                        const BrandEmblemCard(),

                        // Tagline with dual ambient dots
                        SizedBox(height: 80.h),
                        const SplashTagline(),

                        // Pulsing activity indicator
                        SizedBox(height: 56.h),
                        SplashLoadingSpinner(
                          animation: _spinnerController,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Circular white card holding the AINTIS emblem.
class BrandEmblemCard extends StatelessWidget {
  const BrandEmblemCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 224.h,
      height: 224.h,
      decoration: Decorations.splashBadge,
      alignment: Alignment.center,
      child: CustomPaint(
        size: Size(160.h, 160.h),
        painter: AintisEmblemPainter(),
      ),
    );
  }
}

/// "Powered by AI" tagline flanked by glowing dots.
class SplashTagline extends StatelessWidget {
  const SplashTagline({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.h,
          height: 10.h,
          decoration: Decorations.taglineDot(true),
        ),
        SizedBox(width: 10.h),
        Text('Powered by AI', style: TextStyles.tagline()),
        SizedBox(width: 10.h),
        Container(
          width: 10.h,
          height: 10.h,
          decoration: Decorations.taglineDot(false),
        ),
      ],
    );
  }
}

/// Rotating arc loader.
class SplashLoadingSpinner extends StatelessWidget {
  const SplashLoadingSpinner({super.key, required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final size = 48.h;
    return SizedBox(
      width: size,
      height: size,
      child: RotationTransition(
        turns: animation,
        child: CustomPaint(
          painter: SplashSpinnerPainter(strokeWidth: 3.5.h),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

/// Paints the magenta arc followed by three transparent segments.
class SplashSpinnerPainter extends CustomPainter {
  const SplashSpinnerPainter({required this.strokeWidth});

  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(strokeWidth / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Top arc — solid magenta
    paint.color = appTheme.loaderArc;
    canvas.drawArc(rect, -1.5708, 1.5708, false, paint);

    // Remaining segments — transparent
    paint.color = appTheme.transparent;
    canvas.drawArc(rect, 0, 4.7124, false, paint);
  }

  @override
  bool shouldRepaint(covariant SplashSpinnerPainter oldDelegate) =>
      oldDelegate.strokeWidth != strokeWidth;
}

/// Paints the AINTIS swirl emblem (port of the source 240x240 SVG artwork).
class AintisEmblemPainter extends CustomPainter {
  /// Original SVG viewbox dimension used as the normalisation space.
  static const double viewBox = 240;

  /// Maps the SVG `userSpaceOnUse` gradient onto the emblem bounds.
  Paint _gradient(
    List<Color> colors,
    Offset from,
    Offset to,
    Rect bounds,
  ) {
    return Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment(
          (from.dx - bounds.center.dx) / bounds.width,
          (from.dy - bounds.center.dy) / bounds.height,
        ),
        end: Alignment(
          (to.dx - bounds.center.dx) / bounds.width,
          (to.dy - bounds.center.dy) / bounds.height,
        ),
        colors: colors,
      ).createShader(bounds);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Work in a normalised 240x240 space so the artwork scales cleanly.
    canvas.save();
    canvas.scale(size.width / viewBox, size.height / viewBox);

    const bounds = Rect.fromLTWH(0, 0, viewBox, viewBox);
    final pink = _gradient(
      Gradients.emblemPinkLinear.colors,
      const Offset(20, 20),
      const Offset(220, 180),
      bounds,
    );
    final navy = _gradient(
      Gradients.emblemNavyLinear.colors,
      const Offset(60, 40),
      const Offset(220, 220),
      bounds,
    );
    final blend = _gradient(
      Gradients.emblemBlendLinear.colors,
      const Offset(0, 120),
      const Offset(240, 200),
      bounds,
    );
    final deep = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = appTheme.aintisDeepNavy;

    // Top pink ribbon
    canvas.drawPath(
      ui.Path()
        ..moveTo(120, 28)
        ..cubicTo(101.4, 28, 84.8, 33.6, 70.8, 43.2)
        ..cubicTo(81.2, 40.2, 92.5, 41.5, 102.8, 47.4)
        ..cubicTo(118.8, 56.5, 137.6, 54.8, 152, 46)
        ..cubicTo(142.2, 35, 128.8, 28, 120, 28)
        ..close(),
      pink,
    );

    // Upper magenta swirl wave
    canvas.drawPath(
      ui.Path()
        ..moveTo(57, 60)
        ..cubicTo(51.6, 71, 49.8, 84.2, 52.4, 97)
        ..cubicTo(56.6, 88.6, 63.8, 82, 72.8, 78.4)
        ..cubicTo(93.4, 70.2, 118.8, 77.2, 136.4, 69.2)
        ..cubicTo(151.2, 62.4, 163.6, 50.8, 169.2, 38)
        ..cubicTo(154.2, 31.8, 137.4, 28.6, 120, 28)
        ..cubicTo(92, 28, 66.8, 40.4, 50, 60)
        ..cubicTo(52.4, 59.8, 54.8, 59.8, 57, 60)
        ..close(),
      pink,
    );

    // Left flank pink hook
    canvas.drawPath(
      ui.Path()
        ..moveTo(44.8, 84)
        ..cubicTo(42.2, 95.2, 42.6, 107.2, 46.2, 118.8)
        ..cubicTo(48.6, 110.8, 53.6, 104.2, 60.8, 100.2)
        ..cubicTo(71.8, 94.2, 74.4, 83.4, 71.4, 75)
        ..cubicTo(59.6, 74.2, 50.4, 77.8, 44.8, 84)
        ..close(),
      pink,
    );

    // Top-right navy wave swirl
    canvas.drawPath(
      ui.Path()
        ..moveTo(148, 42)
        ..cubicTo(136, 49.2, 120, 50.8, 106, 44)
        ..cubicTo(136, 50, 162, 70, 168, 102)
        ..cubicTo(172, 86, 170, 70, 162, 56)
        ..cubicTo(178, 70, 188, 90, 191, 112)
        ..cubicTo(194, 92, 186, 68, 172, 52)
        ..cubicTo(164.8, 47.6, 156.8, 44.4, 148, 42)
        ..close(),
      navy,
    );

    // Middle right navy ribbon
    canvas.drawPath(
      ui.Path()
        ..moveTo(152, 90)
        ..cubicTo(166, 98, 184, 102, 192, 116)
        ..cubicTo(194, 126, 193, 137, 189, 146)
        ..cubicTo(192, 136, 190, 120, 180, 110)
        ..cubicTo(168, 98, 150, 96, 138, 92)
        ..lineTo(152, 90)
        ..close(),
      navy,
    );
    // Bottom magenta sweep swirl
    canvas.drawPath(
      ui.Path()
        ..moveTo(43.2, 125)
        ..cubicTo(42.6, 136.2, 45.4, 147.4, 51.6, 157.2)
        ..cubicTo(56.8, 147.8, 66, 142.2, 76.8, 141.4)
        ..cubicTo(102, 139.6, 126.8, 126.2, 144, 116)
        ..cubicTo(124, 126, 98, 132, 76, 126)
        ..cubicTo(60.8, 121.8, 49.8, 120, 43.2, 125)
        ..close(),
      pink,
    );

    // Dynamic bottom deep indigo wave
    canvas.drawPath(
      ui.Path()
        ..moveTo(57, 165)
        ..cubicTo(74, 182, 96, 192, 120, 192)
        ..cubicTo(146, 192, 170, 180, 184, 162)
        ..cubicTo(164, 172, 138, 170, 120, 160)
        ..cubicTo(100, 150, 78, 152, 64, 160)
        ..cubicTo(61.4, 161.4, 59.2, 163.2, 57, 165)
        ..close(),
      blend,
    );

    // Bottom navy whirl sweep
    canvas.drawPath(
      ui.Path()
        ..moveTo(68, 174)
        ..cubicTo(82, 196, 106, 208, 134, 206)
        ..cubicTo(162, 204, 184, 188, 190, 168)
        ..cubicTo(182, 182, 166, 192, 148, 192)
        ..cubicTo(122, 192, 98, 178, 88, 166)
        ..cubicTo(80, 166, 74, 169, 68, 174)
        ..close(),
      navy,
    );

    // Deep navy bottom arc
    canvas.drawPath(
      ui.Path()
        ..moveTo(96, 198)
        ..cubicTo(112, 204, 128, 205, 144, 200)
        ..cubicTo(166, 193, 182, 178, 188, 160)
        ..cubicTo(178, 184, 148, 204, 116, 199)
        ..cubicTo(108, 198, 102, 197, 96, 198)
        ..close(),
      deep,
    );

    // AINTIS central wordmark
    final wordmark = TextPainter(
      text: TextSpan(
        text: 'AINTIS',
        style: TextStyles.wordmark(fontSize: 29 * size.width / viewBox),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();
    wordmark.paint(
      canvas,
      Offset(
        viewBox / 2 - wordmark.width / 2,
        132 - wordmark.height / 2,
      ),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant AintisEmblemPainter oldDelegate) => false;
}