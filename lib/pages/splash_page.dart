import 'dart:math' as math;
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF020508),
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
        // Background layers
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
                        // Scanner frame
                        Transform.scale(
                          scale: _scaleIn.value,
                          child: _HolographicScannerFrame(
                            pulseController: _pulseController,
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Brand section
                        _BrandSection(slideUp: _slideUp.value),

                        const SizedBox(height: 36),

                        // Feature pills
                        _FeaturePills(fade: _fadeIn.value),

                        const SizedBox(height: 44),

                        // Loading bar
                        const _NeonLoadingBar(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Vignette overlay
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF020508).withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════
//  BACKGROUND LAYER
// ══════════════════════════════════════════════════════════
class _BackgroundLayer extends StatelessWidget {
  const _BackgroundLayer();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.3),
              radius: 1.4,
              colors: [Color(0xFF051520), Color(0xFF020508)],
            ),
          ),
        ),
        // Top glow
        Positioned(
          top: -100,
          left: 0,
          right: 0,
          child: Container(
            height: 300,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.0,
                colors: [
                  const Color(0xFF00FFD1).withOpacity(0.06),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Bottom glow
        Positioned(
          bottom: -80,
          left: 0,
          right: 0,
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.bottomCenter,
                radius: 1.0,
                colors: [
                  const Color(0xFF0080FF).withOpacity(0.07),
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
//  DOT GRID BACKGROUND
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
    const spacing = 36.0;
    const dotRadius = 0.8;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        final dx = (x / size.width - 0.5).abs();
        final dy = (y / size.height - 0.5).abs();
        final dist = math.sqrt(dx * dx + dy * dy);
        final opacity = (0.12 - dist * 0.15).clamp(0.02, 0.12);

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
//  ORBITAL RINGS PAINTER
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

    // Outer ring arc
    drawArc(
      170,
      angle1,
      math.pi * 0.6,
      const Color(0xFF00FFD1).withOpacity(0.15),
      1.0,
    );
    drawArc(
      170,
      angle1 + math.pi,
      math.pi * 0.4,
      const Color(0xFF00FFD1).withOpacity(0.08),
      0.5,
    );

    // Middle ring arc
    drawArc(
      210,
      angle2,
      math.pi * 0.5,
      const Color(0xFF0080FF).withOpacity(0.12),
      0.8,
    );

    // Glowing dot on outer ring
    final dotX = center.dx + 170 * math.cos(angle1);
    final dotY = center.dy + 170 * math.sin(angle1);
    canvas.drawCircle(
      Offset(dotX, dotY),
      3,
      Paint()..color = const Color(0xFF00FFD1).withOpacity(0.5),
    );
    canvas.drawCircle(
      Offset(dotX, dotY),
      6,
      Paint()..color = const Color(0xFF00FFD1).withOpacity(0.15),
    );
  }

  @override
  bool shouldRepaint(covariant _OrbitalRingsPainter old) =>
      old.progress != progress;
}

// ══════════════════════════════════════════════════════════
//  HOLOGRAPHIC SCANNER FRAME
// ══════════════════════════════════════════════════════════
class _HolographicScannerFrame extends StatelessWidget {
  final AnimationController pulseController;
  const _HolographicScannerFrame({required this.pulseController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer pulse ring
          AnimatedBuilder(
            animation: pulseController,
            builder: (_, __) {
              final pulse = pulseController.value;
              return Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(
                      0xFF00FFD1,
                    ).withOpacity(0.06 + pulse * 0.08),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFF00FFD1,
                      ).withOpacity(0.03 + pulse * 0.05),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              );
            },
          ),

          // Second ring
          Container(
            width: 185,
            height: 185,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF00FFD1).withOpacity(0.08),
                width: 0.5,
              ),
            ),
          ),

          // QR pattern background
          Container(
            width: 148,
            height: 148,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFF040D14),
              border: Border.all(
                color: const Color(0xFF00FFD1).withOpacity(0.25),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: CustomPaint(painter: _QRPatternPainter()),
            ),
          ),

          // Scan line
          const _NeonScanLine(),

          // Corner brackets (neon style)
          ..._buildNeonCorners(),

          // Center glow
          AnimatedBuilder(
            animation: pulseController,
            builder: (_, __) {
              return Container(
                width: 148,
                height: 148,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFF00FFD1,
                      ).withOpacity(0.04 + pulseController.value * 0.06),
                      blurRadius: 20,
                      spreadRadius: 2,
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
    const double size = 22;
    const double bw = 2.5;
    const Color c = Color(0xFF00FFD1);
    const double off = 22;

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
            boxShadow: const [
              BoxShadow(
                color: Color(0xFF00FFD1),
                blurRadius: 6,
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
      ..color = const Color(0xFF00FFD1).withOpacity(0.18)
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
      ..color = const Color(0xFF00FFD1).withOpacity(0.35)
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
            const Radius.circular(1),
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
    // Outer square
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, cell * 3, cell * 3),
        const Radius.circular(2),
      ),
      paint,
    );
    // Clear inner
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + cell * 0.6, y + cell * 0.6, cell * 1.8, cell * 1.8),
        const Radius.circular(1),
      ),
      Paint()
        ..color = const Color(0xFF040D14)
        ..style = PaintingStyle.fill,
    );
    // Center dot
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + cell, y + cell, cell, cell),
        const Radius.circular(1),
      ),
      Paint()
        ..color = const Color(0xFF00FFD1).withOpacity(0.5)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ══════════════════════════════════════════════════════════
//  NEON SCAN LINE
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
        final y = 22 + (104 * _anim.value);
        return Positioned(
          top: y,
          left: 22,
          right: 22,
          child: Column(
            children: [
              // Glow above
              Container(
                height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF00FFD1).withOpacity(0.08),
                    ],
                  ),
                ),
              ),
              // Main line
              Container(
                height: 1.5,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.transparent,
                      Color(0xFF00FFD1),
                      Color(0xFFFFFFFF),
                      Color(0xFF00FFD1),
                      Colors.transparent,
                    ],
                    stops: [0, 0.2, 0.5, 0.8, 1],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00FFD1).withOpacity(0.8),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                    const BoxShadow(color: Color(0xFF00FFD1), blurRadius: 2),
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
//  BRAND SECTION
// ══════════════════════════════════════════════════════════
class _BrandSection extends StatelessWidget {
  final double slideUp;
  const _BrandSection({required this.slideUp});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: const Color(0xFF00FFD1).withOpacity(0.3),
              width: 1,
            ),
            color: const Color(0xFF00FFD1).withOpacity(0.05),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: Color(0xFF00FFD1),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'INSTANT DECODE',
                style: TextStyle(
                  fontSize: 9,
                  color: Color(0xFF00FFD1),
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Main title
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFF00FFD1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            'QR SCANNER',
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 3,
              height: 1,
            ),
          ),
        ),

        const SizedBox(height: 6),

        // Subtitle
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 1,
              color: const Color(0xFF00FFD1).withOpacity(0.4),
            ),
            const SizedBox(width: 10),
            const Text(
              'P R O',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF00FFD1),
                letterSpacing: 5,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 28,
              height: 1,
              color: const Color(0xFF00FFD1).withOpacity(0.4),
            ),
          ],
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════
//  FEATURE PILLS
// ══════════════════════════════════════════════════════════
class _FeaturePills extends StatelessWidget {
  final double fade;
  const _FeaturePills({required this.fade});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _pill(Icons.bolt_rounded, 'FAST'),
        const SizedBox(width: 10),
        _pill(Icons.lock_outline_rounded, 'SECURE'),
        const SizedBox(width: 10),
        _pill(Icons.all_inclusive_rounded, 'OFFLINE'),
      ],
    );
  }

  Widget _pill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF00FFD1).withOpacity(0.05),
        border: Border.all(
          color: const Color(0xFF00FFD1).withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF00FFD1), size: 16),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 8,
              color: Color(0xFF00FFD1),
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  NEON LOADING BAR
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
            // Progress bar container
            Stack(
              children: [
                // Track
                Container(
                  width: 180,
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF00FFD1).withOpacity(0.08),
                  ),
                ),
                // Fill
                Container(
                  width: 180 * progress,
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0080FF), Color(0xFF00FFD1)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00FFD1).withOpacity(0.6),
                        blurRadius: 6,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
                // Leading dot
                if (progress > 0.01)
                  Positioned(
                    left: (180 * progress) - 4,
                    top: -2.5,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00FFD1).withOpacity(0.9),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Status text
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
                    fontSize: 9,
                    color: const Color(0xFF00FFD1).withOpacity(0.5),
                    letterSpacing: 2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFF00FFD1),
                    letterSpacing: 1,
                    fontWeight: FontWeight.w700,
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
