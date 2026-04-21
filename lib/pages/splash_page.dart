import 'dart:math' as math;
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0A0E27),
      body: _SplashBody(),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  MAIN BODY
// ══════════════════════════════════════════════════════════
class _SplashBody extends StatefulWidget {
  const _SplashBody();

  @override
  State<_SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<_SplashBody>
    with TickerProviderStateMixin {
  late AnimationController _masterController;
  late AnimationController _pulseController;
  late AnimationController _rotateController;

  late Animation<double> _fadeIn;
  late Animation<double> _scaleIn;
  late Animation<double> _slideUp;

  @override
  void initState() {
    super.initState();

    _masterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _fadeIn = CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _scaleIn = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _slideUp = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _masterController.forward();
  }

  @override
  void dispose() {
    _masterController.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background layers dengan gradient yang lebih sophisticated
        const _BackgroundLayer(),

        // Rotating orbital rings
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _rotateController,
            builder: (_, __) => CustomPaint(
              painter: _OrbitalRingsPainter(_rotateController.value),
            ),
          ),
        ),

        // Animated dot grid
        const Positioned.fill(child: _DotGridBackground()),

        // Main content
        SafeArea(
          child: AnimatedBuilder(
            animation: _masterController,
            builder: (_, __) {
              return Opacity(
                opacity: _fadeIn.value,
                child: Transform.translate(
                  offset: Offset(0, _slideUp.value),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Scanner frame dengan design yang lebih premium
                        Transform.scale(
                          scale: _scaleIn.value,
                          child: _HolographicScannerFrame(
                            pulseController: _pulseController,
                          ),
                        ),

                        const SizedBox(height: 56),

                        // Brand section dengan typography yang lebih baik
                        _BrandSection(slideUp: _slideUp.value),

                        const SizedBox(height: 40),

                        // Feature pills dengan design refresh
                        _FeaturePills(fade: _fadeIn.value),

                        const SizedBox(height: 50),

                        // Loading bar dengan visual yang lebih menarik
                        const _NeonLoadingBar(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Enhanced vignette overlay
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.3,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF0A0E27).withOpacity(0.6),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Corner accents untuk design yang lebih premium
        const Positioned(
          top: 0,
          left: 0,
          child: _CornerAccent(top: true, left: true),
        ),
        const Positioned(
          top: 0,
          right: 0,
          child: _CornerAccent(top: true, left: false),
        ),
        const Positioned(
          bottom: 0,
          left: 0,
          child: _CornerAccent(top: false, left: true),
        ),
        const Positioned(
          bottom: 0,
          right: 0,
          child: _CornerAccent(top: false, left: false),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════
//  CORNER ACCENT
// ══════════════════════════════════════════════════════════
class _CornerAccent extends StatelessWidget {
  final bool top;
  final bool left;

  const _CornerAccent({required this.top, required this.left});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: CustomPaint(
        painter: _CornerAccentPainter(top: top, left: left),
      ),
    );
  }
}

class _CornerAccentPainter extends CustomPainter {
  final bool top;
  final bool left;

  _CornerAccentPainter({required this.top, required this.left});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00FFD1).withOpacity(0.08)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final brightPaint = Paint()
      ..color = const Color(0xFF00FFD1).withOpacity(0.15)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    if (top && left) {
      canvas.drawLine(const Offset(20, 0), const Offset(20, 25), paint);
      canvas.drawLine(const Offset(0, 20), const Offset(25, 20), paint);
      canvas.drawLine(const Offset(15, 0), const Offset(15, 15), brightPaint);
      canvas.drawLine(const Offset(0, 15), const Offset(15, 15), brightPaint);
    } else if (top && !left) {
      canvas.drawLine(
        Offset(size.width - 20, 0),
        Offset(size.width - 20, 25),
        paint,
      );
      canvas.drawLine(
        Offset(size.width - 25, 20),
        Offset(size.width, 20),
        paint,
      );
      canvas.drawLine(
        Offset(size.width - 15, 0),
        Offset(size.width - 15, 15),
        brightPaint,
      );
      canvas.drawLine(
        Offset(size.width - 15, 15),
        Offset(size.width, 15),
        brightPaint,
      );
    } else if (!top && left) {
      canvas.drawLine(
        Offset(20, size.height),
        Offset(20, size.height - 25),
        paint,
      );
      canvas.drawLine(
        Offset(0, size.height - 20),
        Offset(25, size.height - 20),
        paint,
      );
      canvas.drawLine(
        Offset(15, size.height),
        Offset(15, size.height - 15),
        brightPaint,
      );
      canvas.drawLine(
        Offset(0, size.height - 15),
        Offset(15, size.height - 15),
        brightPaint,
      );
    } else {
      canvas.drawLine(
        Offset(size.width - 20, size.height),
        Offset(size.width - 20, size.height - 25),
        paint,
      );
      canvas.drawLine(
        Offset(size.width - 25, size.height - 20),
        Offset(size.width, size.height - 20),
        paint,
      );
      canvas.drawLine(
        Offset(size.width - 15, size.height),
        Offset(size.width - 15, size.height - 15),
        brightPaint,
      );
      canvas.drawLine(
        Offset(size.width - 15, size.height - 15),
        Offset(size.width, size.height - 15),
        brightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ══════════════════════════════════════════════════════════
//  BACKGROUND LAYER - Enhanced dengan gradients yang lebih sophisticated
// ══════════════════════════════════════════════════════════
class _BackgroundLayer extends StatelessWidget {
  const _BackgroundLayer();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient dengan dark theme yang lebih elegant
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.4),
              radius: 1.6,
              colors: [Color(0xFF1a1f3a), Color(0xFF0A0E27)],
            ),
          ),
        ),

        // Top glow dengan accent cyan
        Positioned(
          top: -150,
          left: -100,
          right: -100,
          child: Container(
            height: 400,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.2,
                colors: [
                  const Color(0xFF00FFD1).withOpacity(0.08),
                  const Color(0xFF0080FF).withOpacity(0.04),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Bottom glow dengan accent purple
        Positioned(
          bottom: -120,
          left: -100,
          right: -100,
          child: Container(
            height: 350,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.bottomCenter,
                radius: 1.3,
                colors: [
                  const Color(0xFF6366F1).withOpacity(0.06),
                  const Color(0xFF0080FF).withOpacity(0.04),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Side accent glows untuk lebih depth
        Positioned(
          top: 100,
          left: -150,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF00FFD1).withOpacity(0.04),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          right: -150,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF6366F1).withOpacity(0.04),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════
//  DOT GRID BACKGROUND - dengan pattern yang lebih refined
// ══════════════════════════════════════════════════════════
class _DotGridBackground extends StatelessWidget {
  const _DotGridBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DotGridPainter(),
      isComplex: false,
      willChange: false,
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 40.0;
    const dotRadius = 0.7;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        final dx = (x / size.width - 0.5).abs();
        final dy = (y / size.height - 0.5).abs();
        final dist = math.sqrt(dx * dx + dy * dy);
        final opacity = (0.08 - dist * 0.12).clamp(0.01, 0.08);

        canvas.drawCircle(
          Offset(x, y),
          dotRadius,
          Paint()..color = const Color(0xFF00FFD1).withOpacity(opacity),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ══════════════════════════════════════════════════════════
//  ORBITAL RINGS PAINTER - Enhanced dengan visual yang lebih sophisticated
// ══════════════════════════════════════════════════════════
class _OrbitalRingsPainter extends CustomPainter {
  final double progress;
  _OrbitalRingsPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 - 60);

    void drawArc(
      double radius,
      double startAngle,
      double sweepAngle,
      Color color,
      double strokeWidth,
    ) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }

    final angle1 = progress * math.pi * 2;
    final angle2 = -progress * math.pi * 2;

    // Outer ring - dengan gradient effect
    drawArc(
      170,
      angle1,
      math.pi * 0.6,
      const Color(0xFF00FFD1).withOpacity(0.18),
      1.2,
    );
    drawArc(
      170,
      angle1 + math.pi,
      math.pi * 0.4,
      const Color(0xFF00FFD1).withOpacity(0.09),
      0.6,
    );

    // Middle ring - dengan accent warna biru
    drawArc(
      210,
      angle2,
      math.pi * 0.5,
      const Color(0xFF0080FF).withOpacity(0.14),
      0.9,
    );

    // Inner ring tambahan untuk lebih depth
    drawArc(
      130,
      angle1 + math.pi * 0.5,
      math.pi * 0.7,
      const Color(0xFF6366F1).withOpacity(0.1),
      0.7,
    );

    // Glowing dot on outer ring - lebih prominent
    final dotX = center.dx + 170 * math.cos(angle1);
    final dotY = center.dy + 170 * math.sin(angle1);

    canvas.drawCircle(
      Offset(dotX, dotY),
      4,
      Paint()..color = const Color(0xFF00FFD1).withOpacity(0.7),
    );
    canvas.drawCircle(
      Offset(dotX, dotY),
      8,
      Paint()..color = const Color(0xFF00FFD1).withOpacity(0.12),
    );

    // Secondary dot untuk visual interest
    final dotX2 = center.dx + 210 * math.cos(angle2);
    final dotY2 = center.dy + 210 * math.sin(angle2);
    canvas.drawCircle(
      Offset(dotX2, dotY2),
      2.5,
      Paint()..color = const Color(0xFF0080FF).withOpacity(0.5),
    );
  }

  @override
  bool shouldRepaint(covariant _OrbitalRingsPainter old) =>
      old.progress != progress;
}

// ══════════════════════════════════════════════════════════
//  HOLOGRAPHIC SCANNER FRAME - Premium Design Update
// ══════════════════════════════════════════════════════════
class _HolographicScannerFrame extends StatelessWidget {
  final AnimationController pulseController;
  const _HolographicScannerFrame({required this.pulseController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background glow layer
          AnimatedBuilder(
            animation: pulseController,
            builder: (_, __) {
              final pulse = pulseController.value;
              return Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFF00FFD1,
                      ).withOpacity(0.04 + pulse * 0.06),
                      blurRadius: 50,
                      spreadRadius: 15,
                    ),
                  ],
                ),
              );
            },
          ),

          // Outer pulse ring - lebih refined
          AnimatedBuilder(
            animation: pulseController,
            builder: (_, __) {
              final pulse = pulseController.value;
              return Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(
                      0xFF00FFD1,
                    ).withOpacity(0.08 + pulse * 0.07),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFF00FFD1,
                      ).withOpacity(0.04 + pulse * 0.04),
                      blurRadius: 25,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              );
            },
          ),

          // Second ring - subtle
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF00FFD1).withOpacity(0.06),
                width: 0.5,
              ),
            ),
          ),

          // Third ring - accent color
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF0080FF).withOpacity(0.08),
                width: 0.5,
              ),
            ),
          ),

          // QR pattern background dengan design refresh
          Container(
            width: 155,
            height: 155,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: const Color(0xFF0F1633),
              border: Border.all(
                color: const Color(0xFF00FFD1).withOpacity(0.28),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00FFD1).withOpacity(0.08),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: CustomPaint(painter: _QRPatternPainter()),
            ),
          ),

          // Scan line
          const _NeonScanLine(),

          // Corner brackets - lebih elegant dengan rounded style
          ..._buildNeonCorners(),

          // Center glow - enhanced
          AnimatedBuilder(
            animation: pulseController,
            builder: (_, __) {
              return Container(
                width: 155,
                height: 155,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFF00FFD1,
                      ).withOpacity(0.05 + pulseController.value * 0.07),
                      blurRadius: 25,
                      spreadRadius: 3,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNeonCorners() {
    const double size = 24;
    const double bw = 2.2;
    const Color c = Color(0xFF00FFD1);
    const double off = 20;
    const double cornerRadius = 3.0;

    Widget corner(
      double? top,
      double? bottom,
      double? left,
      double? right,
      Border border,
    ) {
      return Positioned(
        top: top,
        bottom: bottom,
        left: left,
        right: right,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: border,
            borderRadius: BorderRadius.circular(cornerRadius),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFF00FFD1),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
        ),
      );
    }

    return [
      corner(
        off,
        null,
        off,
        null,
        const Border(
          top: BorderSide(color: c, width: bw),
          left: BorderSide(color: c, width: bw),
        ),
      ),
      corner(
        off,
        null,
        null,
        off,
        const Border(
          top: BorderSide(color: c, width: bw),
          right: BorderSide(color: c, width: bw),
        ),
      ),
      corner(
        null,
        off,
        off,
        null,
        const Border(
          bottom: BorderSide(color: c, width: bw),
          left: BorderSide(color: c, width: bw),
        ),
      ),
      corner(
        null,
        off,
        null,
        off,
        const Border(
          bottom: BorderSide(color: c, width: bw),
          right: BorderSide(color: c, width: bw),
        ),
      ),
    ];
  }
}

// ══════════════════════════════════════════════════════════
//  QR PATTERN PAINTER (decorative)
// ══════════════════════════════════════════════════════════
class _QRPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00FFD1).withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final cellSize = size.width / 7;

    // Finder pattern top-left
    _drawFinderPattern(canvas, paint, 0, 0, cellSize);
    // Finder pattern top-right
    _drawFinderPattern(canvas, paint, 4 * cellSize, 0, cellSize);
    // Finder pattern bottom-left
    _drawFinderPattern(canvas, paint, 0, 4 * cellSize, cellSize);

    // Random data dots
    final rng = math.Random(42);
    final brightPaint = Paint()
      ..color = const Color(0xFF00FFD1).withOpacity(0.32)
      ..style = PaintingStyle.fill;

    for (int row = 0; row < 7; row++) {
      for (int col = 0; col < 7; col++) {
        if ((row < 3 && col < 3) ||
            (row < 3 && col > 3) ||
            (row > 3 && col < 3))
          continue;
        if (rng.nextBool()) {
          final rect = RRect.fromRectAndRadius(
            Rect.fromLTWH(
              col * cellSize + 1,
              row * cellSize + 1,
              cellSize - 2,
              cellSize - 2,
            ),
            const Radius.circular(1.2),
          );
          canvas.drawRRect(rect, rng.nextDouble() > 0.6 ? brightPaint : paint);
        }
      }
    }
  }

  void _drawFinderPattern(
    Canvas canvas,
    Paint paint,
    double x,
    double y,
    double cell,
  ) {
    // Outer square dengan rounded corners
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, cell * 3, cell * 3),
        const Radius.circular(2.5),
      ),
      paint,
    );
    // Clear inner
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + cell * 0.6, y + cell * 0.6, cell * 1.8, cell * 1.8),
        const Radius.circular(1.2),
      ),
      Paint()
        ..color = const Color(0xFF0F1633)
        ..style = PaintingStyle.fill,
    );
    // Center dot
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + cell, y + cell, cell, cell),
        const Radius.circular(1.2),
      ),
      Paint()
        ..color = const Color(0xFF00FFD1).withOpacity(0.45)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ══════════════════════════════════════════════════════════
//  NEON SCAN LINE - Enhanced dengan better visual
// ══════════════════════════════════════════════════════════
class _NeonScanLine extends StatefulWidget {
  const _NeonScanLine();

  @override
  State<_NeonScanLine> createState() => _NeonScanLineState();
}

class _NeonScanLineState extends State<_NeonScanLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final y = 23 + (109 * _anim.value);
        return Positioned(
          top: y,
          left: 23,
          right: 23,
          child: Column(
            children: [
              // Glow above dengan gradient yang lebih soft
              Container(
                height: 10,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF00FFD1).withOpacity(0.06),
                    ],
                  ),
                ),
              ),
              // Main line dengan enhanced glow
              Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.transparent,
                      Color(0xFF00FFD1),
                      Color(0xFFFFFFFF),
                      Color(0xFF00FFD1),
                      Colors.transparent,
                    ],
                    stops: [0, 0.15, 0.5, 0.85, 1],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00FFD1).withOpacity(0.85),
                      blurRadius: 10,
                      spreadRadius: 1.5,
                    ),
                    BoxShadow(
                      color: const Color(0xFF00FFD1).withOpacity(0.4),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════════════
//  BRAND SECTION - Typography & Design Upgrade
// ══════════════════════════════════════════════════════════
class _BrandSection extends StatelessWidget {
  final double slideUp;
  const _BrandSection({required this.slideUp});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top label dengan design yang lebih premium
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: const Color(0xFF00FFD1).withOpacity(0.25),
              width: 0.8,
            ),
            color: const Color(0xFF00FFD1).withOpacity(0.04),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00FFD1).withOpacity(0.05),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 4.5,
                height: 4.5,
                decoration: const BoxDecoration(
                  color: Color(0xFF00FFD1),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'INSTANT DECODE',
                style: TextStyle(
                  fontSize: 8.5,
                  color: Color(0xFF00FFD1),
                  letterSpacing: 2.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Main title dengan gradient yang lebih refined
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFE8E8F0), Color(0xFF00FFD1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            'QR SCANNER',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 2.5,
              height: 1.1,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Subtitle dengan accent lines
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 1.2,
              decoration: BoxDecoration(
                color: const Color(0xFF00FFD1).withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'P R O',
              style: TextStyle(
                fontSize: 10.5,
                color: Color(0xFF00FFD1),
                letterSpacing: 5.5,
                fontWeight: FontWeight.w200,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 32,
              height: 1.2,
              decoration: BoxDecoration(
                color: const Color(0xFF00FFD1).withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════
//  FEATURE PILLS - Design Refresh
// ══════════════════════════════════════════════════════════
class _FeaturePills extends StatelessWidget {
  final double fade;
  const _FeaturePills({required this.fade});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: fade,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _pill(Icons.flash_on_rounded, 'FAST'),
          const SizedBox(width: 12),
          _pill(Icons.security_rounded, 'SECURE'),
          const SizedBox(width: 12),
          _pill(Icons.cloud_off_rounded, 'OFFLINE'),
        ],
      ),
    );
  }

  Widget _pill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF00FFD1).withOpacity(0.04),
        border: Border.all(
          color: const Color(0xFF00FFD1).withOpacity(0.12),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FFD1).withOpacity(0.03),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF00FFD1), size: 17),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 7.5,
              color: Color(0xFF00FFD1),
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  NEON LOADING BAR - Enhanced Visual Design
// ══════════════════════════════════════════════════════════
class _NeonLoadingBar extends StatelessWidget {
  const _NeonLoadingBar();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 2800),
      curve: Curves.easeInOutCubic,
      builder: (_, progress, __) {
        return Column(
          children: [
            // Progress bar container dengan better visuals
            Stack(
              children: [
                // Track dengan subtle gradient
                Container(
                  width: 190,
                  height: 3.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF00FFD1).withOpacity(0.06),
                    border: Border.all(
                      color: const Color(0xFF00FFD1).withOpacity(0.08),
                      width: 0.5,
                    ),
                  ),
                ),
                // Fill dengan gradient yang lebih menarik
                Container(
                  width: 190 * progress,
                  height: 3.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0080FF), Color(0xFF00FFD1)],
                      stops: [0, 1],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00FFD1).withOpacity(0.7),
                        blurRadius: 8,
                        spreadRadius: 0.5,
                      ),
                      BoxShadow(
                        color: const Color(0xFF0080FF).withOpacity(0.4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                // Leading dot dengan enhanced glow
                if (progress > 0.01)
                  Positioned(
                    left: (190 * progress) - 4.5,
                    top: -3,
                    child: Container(
                      width: 9.5,
                      height: 9.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00FFD1).withOpacity(0.95),
                            blurRadius: 10,
                            spreadRadius: 2.5,
                          ),
                          BoxShadow(
                            color: const Color(0xFF0080FF).withOpacity(0.4),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 14),

            // Status text dengan better styling
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  progress < 0.4
                      ? 'INITIALIZING'
                      : progress < 0.8
                      ? 'CALIBRATING'
                      : 'READY',
                  style: TextStyle(
                    fontSize: 8.5,
                    color: const Color(0xFF00FFD1).withOpacity(0.45),
                    letterSpacing: 1.8,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 9.5,
                    color: Color(0xFF00FFD1),
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
