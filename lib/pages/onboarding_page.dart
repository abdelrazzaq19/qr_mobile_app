import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_app/core/routes.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _navigateToLogin();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  void _navigateToLogin() {
    Future.delayed(const Duration(milliseconds: 4000), () {
      Get.offNamed(AppRoutes.login);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020508),
      body: Stack(
        children: [
          // Background
          const _OnboardingBackground(),

          // Particle field
          const Positioned.fill(child: _ParticleField()),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // QR Hero Section
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: const AnimatedQRContainer(),
                      ),
                    ),

                    const SizedBox(height: 44),

                    // Title
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: const OnboardingTitle(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Description
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: const OnboardingDescription(),
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Feature cards row
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: const _FeatureCards(),
                      ),
                    ),

                    const SizedBox(height: 44),

                    // Get Started Button
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: const GetStartedButton(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Skip
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: TextButton(
                        onPressed: () => Get.offNamed(AppRoutes.login),
                        child: const Text(
                          'Skip for now',
                          style: TextStyle(
                            color: Color(0xFF00FFD1),
                            fontSize: 13,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),

          // Vignette
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.3,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF020508).withOpacity(0.45),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  BACKGROUND
// ══════════════════════════════════════════════════════════
class _OnboardingBackground extends StatelessWidget {
  const _OnboardingBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base
        Container(color: const Color(0xFF020508)),

        // Top radial glow (cyan)
        Positioned(
          top: -120,
          left: -60,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF00FFD1).withOpacity(0.07),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Bottom radial glow (blue)
        Positioned(
          bottom: -100,
          right: -80,
          child: Container(
            width: 380,
            height: 380,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF0066FF).withOpacity(0.09),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Subtle grid lines
        Positioned.fill(child: CustomPaint(painter: _GridPainter())),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00FFD1).withOpacity(0.035)
      ..strokeWidth = 0.5;

    const spacing = 44.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ══════════════════════════════════════════════════════════
//  PARTICLE FIELD
// ══════════════════════════════════════════════════════════
class _ParticleField extends StatefulWidget {
  const _ParticleField();

  @override
  State<_ParticleField> createState() => _ParticleFieldState();
}

class _ParticleFieldState extends State<_ParticleField>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => CustomPaint(painter: _ParticlePainter(_ctrl.value)),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double t;
  static final _rng = math.Random(7);
  static final _particles = List.generate(
    20,
    (i) => [
      _rng.nextDouble(), // x
      _rng.nextDouble(), // y
      _rng.nextDouble(), // speed
      _rng.nextDouble(), // size
    ],
  );

  _ParticlePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final x = p[0] * size.width;
      final y = ((p[1] + t * p[2] * 0.3) % 1.0) * size.height;
      final radius = 0.8 + p[3] * 1.5;
      final opacity = 0.1 + p[3] * 0.25;

      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()
          ..color = const Color(0xFF00FFD1).withOpacity(opacity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => old.t != t;
}

// ══════════════════════════════════════════════════════════
//  ANIMATED QR CONTAINER
// ══════════════════════════════════════════════════════════
class AnimatedQRContainer extends StatefulWidget {
  const AnimatedQRContainer({super.key});

  @override
  State<AnimatedQRContainer> createState() => _AnimatedQRContainerState();
}

class _AnimatedQRContainerState extends State<AnimatedQRContainer>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late AnimationController _scanController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _scanController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer rotating dashed ring
          AnimatedBuilder(
            animation: _rotateController,
            builder: (_, __) => Transform.rotate(
              angle: _rotateController.value * math.pi * 2,
              child: CustomPaint(
                size: const Size(240, 240),
                painter: _DashedRingPainter(240),
              ),
            ),
          ),

          // Counter-rotating ring
          AnimatedBuilder(
            animation: _rotateController,
            builder: (_, __) => Transform.rotate(
              angle: -_rotateController.value * math.pi * 2 * 0.6,
              child: CustomPaint(
                size: const Size(200, 200),
                painter: _DashedRingPainter(200, dashes: 6, opacity: 0.1),
              ),
            ),
          ),

          // Pulse glow ring
          AnimatedBuilder(
            animation: _pulseController,
            builder: (_, __) => Container(
              width: 175 + _pulseController.value * 8,
              height: 175 + _pulseController.value * 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(
                    0xFF00FFD1,
                  ).withOpacity(0.08 + _pulseController.value * 0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0xFF00FFD1,
                    ).withOpacity(0.04 + _pulseController.value * 0.06),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
            ),
          ),

          // Main QR box
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFF040D14),
                border: Border.all(
                  color: const Color(0xFF00FFD1).withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00FFD1).withOpacity(0.12),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: CustomPaint(painter: _QRPatternPainter()),
              ),
            ),
          ),

          // Scan line over QR
          AnimatedBuilder(
            animation: _scanController,
            builder: (_, __) {
              final progress = CurvedAnimation(
                parent: _scanController,
                curve: Curves.easeInOut,
              ).value;
              return Positioned(
                top: 40 + (120 * progress),
                left: 40,
                right: 40,
                child: Container(
                  height: 1.5,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.transparent,
                        Color(0xFF00FFD1),
                        Colors.white,
                        Color(0xFF00FFD1),
                        Colors.transparent,
                      ],
                      stops: [0, 0.2, 0.5, 0.8, 1],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00FFD1).withOpacity(0.8),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Neon corners
          ..._buildCorners(),
        ],
      ),
    );
  }

  List<Widget> _buildCorners() {
    const double s = 22;
    const double bw = 2.5;
    const Color c = Color(0xFF00FFD1);
    const double off = 40;

    Widget corner(
      double? top,
      double? bottom,
      double? left,
      double? right,
      Border b,
    ) {
      return Positioned(
        top: top,
        bottom: bottom,
        left: left,
        right: right,
        child: Container(
          width: s,
          height: s,
          decoration: BoxDecoration(
            border: b,
            boxShadow: const [
              BoxShadow(color: Color(0xFF00FFD1), blurRadius: 5),
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
//  DASHED RING PAINTER
// ══════════════════════════════════════════════════════════
class _DashedRingPainter extends CustomPainter {
  final double diameter;
  final int dashes;
  final double opacity;

  _DashedRingPainter(this.diameter, {this.dashes = 12, this.opacity = 0.15});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = diameter / 2;
    final paint = Paint()
      ..color = const Color(0xFF00FFD1).withOpacity(opacity)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dashAngle = (math.pi * 2) / dashes;
    final gapFraction = 0.35;

    for (int i = 0; i < dashes; i++) {
      final start = i * dashAngle;
      final sweep = dashAngle * (1 - gapFraction);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ══════════════════════════════════════════════════════════
//  QR PATTERN PAINTER
// ══════════════════════════════════════════════════════════
class _QRPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00FFD1).withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final cellSize = size.width / 7;

    _drawFinder(canvas, paint, 0, 0, cellSize);
    _drawFinder(canvas, paint, 4 * cellSize, 0, cellSize);
    _drawFinder(canvas, paint, 0, 4 * cellSize, cellSize);

    final rng = math.Random(99);
    final bright = Paint()
      ..color = const Color(0xFF00FFD1).withOpacity(0.4)
      ..style = PaintingStyle.fill;

    for (int r = 0; r < 7; r++) {
      for (int c = 0; c < 7; c++) {
        if ((r < 3 && c < 3) || (r < 3 && c > 3) || (r > 3 && c < 3)) continue;
        if (rng.nextBool()) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(
                c * cellSize + 1,
                r * cellSize + 1,
                cellSize - 2,
                cellSize - 2,
              ),
              const Radius.circular(1.5),
            ),
            rng.nextDouble() > 0.5 ? bright : paint,
          );
        }
      }
    }
  }

  void _drawFinder(
    Canvas canvas,
    Paint paint,
    double x,
    double y,
    double cell,
  ) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, cell * 3, cell * 3),
        const Radius.circular(2),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + cell * 0.6, y + cell * 0.6, cell * 1.8, cell * 1.8),
        const Radius.circular(1),
      ),
      Paint()
        ..color = const Color(0xFF040D14)
        ..style = PaintingStyle.fill,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + cell, y + cell, cell, cell),
        const Radius.circular(1),
      ),
      Paint()
        ..color = const Color(0xFF00FFD1).withOpacity(0.55)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// ══════════════════════════════════════════════════════════
//  ONBOARDING TITLE
// ══════════════════════════════════════════════════════════
class OnboardingTitle extends StatelessWidget {
  const OnboardingTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Label badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFF00FFD1).withOpacity(0.3)),
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
                'WELCOME',
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

        const SizedBox(height: 14),

        // Main title
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Color(0xFF00FFD1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            'QR Scanner',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 1.5,
              height: 1,
            ),
          ),
        ),

        const SizedBox(height: 6),

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
                fontSize: 10,
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
//  ONBOARDING DESCRIPTION
// ══════════════════════════════════════════════════════════
class OnboardingDescription extends StatelessWidget {
  const OnboardingDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Scan QR codes instantly and access information faster than ever before. Simple, secure, and lightning fast.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: Colors.white.withOpacity(0.45),
          height: 1.7,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  FEATURE CARDS
// ══════════════════════════════════════════════════════════
class _FeatureCards extends StatelessWidget {
  const _FeatureCards();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _FeatureCard(
            icon: Icons.bolt_rounded,
            title: 'Instant',
            subtitle: 'Real-time decode',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _FeatureCard(
            icon: Icons.shield_outlined,
            title: 'Secure',
            subtitle: 'Privacy first',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _FeatureCard(
            icon: Icons.wifi_off_rounded,
            title: 'Offline',
            subtitle: 'No internet needed',
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF00FFD1).withOpacity(0.04),
        border: Border.all(
          color: const Color(0xFF00FFD1).withOpacity(0.12),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF00FFD1).withOpacity(0.08),
              border: Border.all(
                color: const Color(0xFF00FFD1).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(icon, color: const Color(0xFF00FFD1), size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              color: Colors.white.withOpacity(0.35),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  GET STARTED BUTTON
// ══════════════════════════════════════════════════════════
class GetStartedButton extends StatefulWidget {
  const GetStartedButton({super.key});

  @override
  State<GetStartedButton> createState() => _GetStartedButtonState();
}

class _GetStartedButtonState extends State<GetStartedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerCtrl;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.offNamed(AppRoutes.login),
      child: AnimatedBuilder(
        animation: _shimmerCtrl,
        builder: (_, __) {
          return Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: const [
                  Color(0xFF004D3D),
                  Color(0xFF00FFD1),
                  Color(0xFF0080FF),
                  Color(0xFF004D3D),
                ],
                stops: [
                  0,
                  (_shimmerCtrl.value * 1.5).clamp(0, 0.5),
                  (_shimmerCtrl.value * 1.5 + 0.3).clamp(0.3, 1),
                  1,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00FFD1).withOpacity(0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
