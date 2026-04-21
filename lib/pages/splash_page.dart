import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_app/core/themes.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: AppTheme.bg, body: _SplashBody());
  }
}

class _SplashBody extends StatefulWidget {
  const _SplashBody();

  @override
  State<_SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<_SplashBody>
    with TickerProviderStateMixin {
  late AnimationController _masterCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _rotateCtrl;
  late AnimationController _loadCtrl;

  late Animation<double> _fade;
  late Animation<double> _scale;
  late Animation<double> _slideUp;

  @override
  void initState() {
    super.initState();
    _masterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
    _loadCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..forward();

    _fade = CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0, 0.6, curve: Curves.easeOut),
    );
    _scale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterCtrl,
        curve: const Interval(0, 0.7, curve: Curves.elasticOut),
      ),
    );
    _slideUp = Tween<double>(begin: 36, end: 0).animate(
      CurvedAnimation(
        parent: _masterCtrl,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  void dispose() {
    _masterCtrl.dispose();
    _pulseCtrl.dispose();
    _rotateCtrl.dispose();
    _loadCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Background ──────────────────────────────────────────
        Positioned.fill(child: _Background()),
        // ── Orbital rings ───────────────────────────────────────
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _rotateCtrl,
            builder: (_, __) =>
                CustomPaint(painter: _OrbitalPainter(_rotateCtrl.value)),
          ),
        ),
        // ── Content ─────────────────────────────────────────────
        SafeArea(
          child: AnimatedBuilder(
            animation: _masterCtrl,
            builder: (_, __) => Opacity(
              opacity: _fade.value,
              child: Transform.translate(
                offset: Offset(0, _slideUp.value),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.scale(
                        scale: _scale.value,
                        child: _ScannerFrame(pulse: _pulseCtrl),
                      ),
                      const SizedBox(height: 52),
                      _Brand(),
                      const SizedBox(height: 36),
                      _FeaturePills(fade: _fade.value),
                      const SizedBox(height: 48),
                      _LoadingBar(ctrl: _loadCtrl),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Background ───────────────────────────────────────────────────────────────
class _Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.5),
              radius: 1.5,
              colors: [Color(0xFF0E1630), AppTheme.bg],
            ),
          ),
        ),
        Positioned(
          top: -120,
          left: -100,
          right: -100,
          child: Container(
            height: 360,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.2,
                colors: [AppTheme.accent.withOpacity(0.07), Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -100,
          left: -100,
          right: -100,
          child: Container(
            height: 300,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.bottomCenter,
                radius: 1.2,
                colors: [
                  AppTheme.accentAlt.withOpacity(0.05),
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

// ── Orbital rings ─────────────────────────────────────────────────────────────
class _OrbitalPainter extends CustomPainter {
  final double progress;
  _OrbitalPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2 - 50);
    final a1 = progress * math.pi * 2;
    final a2 = -progress * math.pi * 2;

    void arc(double r, double start, double sweep, Color color, double sw) {
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r),
        start,
        sweep,
        false,
        Paint()
          ..color = color
          ..strokeWidth = sw
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }

    arc(165, a1, math.pi * 0.65, AppTheme.accent.withOpacity(0.14), 1.2);
    arc(
      165,
      a1 + math.pi,
      math.pi * 0.35,
      AppTheme.accent.withOpacity(0.06),
      0.6,
    );
    arc(205, a2, math.pi * 0.5, AppTheme.accentAlt.withOpacity(0.10), 0.9);
    arc(
      125,
      a1 + math.pi * 0.5,
      math.pi * 0.7,
      AppTheme.info.withOpacity(0.08),
      0.7,
    );

    final dotX = c.dx + 165 * math.cos(a1);
    final dotY = c.dy + 165 * math.sin(a1);
    canvas.drawCircle(
      Offset(dotX, dotY),
      3.5,
      Paint()..color = AppTheme.accent.withOpacity(0.75),
    );
    canvas.drawCircle(
      Offset(dotX, dotY),
      7,
      Paint()..color = AppTheme.accent.withOpacity(0.12),
    );
  }

  @override
  bool shouldRepaint(_OrbitalPainter old) => old.progress != progress;
}

// ── Scanner frame ─────────────────────────────────────────────────────────────
class _ScannerFrame extends StatelessWidget {
  final AnimationController pulse;
  const _ScannerFrame({required this.pulse});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      height: 230,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // glow ring
          AnimatedBuilder(
            animation: pulse,
            builder: (_, __) => Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accent.withOpacity(
                      0.05 + pulse.value * 0.08,
                    ),
                    blurRadius: 55,
                    spreadRadius: 12,
                  ),
                ],
              ),
            ),
          ),
          // outer ring
          AnimatedBuilder(
            animation: pulse,
            builder: (_, __) => Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.accent.withOpacity(0.07 + pulse.value * 0.08),
                  width: 1.2,
                ),
              ),
            ),
          ),
          // mid ring
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.border.withOpacity(0.4)),
            ),
          ),
          // QR box
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppTheme.surface,
              border: Border.all(
                color: AppTheme.accent.withOpacity(0.30),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accent.withOpacity(0.08),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: CustomPaint(painter: _QRPainter()),
            ),
          ),
          // scan line
          _ScanLine(),
          // corner brackets
          ..._corners(),
        ],
      ),
    );
  }

  List<Widget> _corners() {
    const c = AppTheme.accent;
    const s = 22.0, t = 2.2, off = 19.0;
    Widget b(
      double? top,
      double? bottom,
      double? left,
      double? right,
      Border border,
    ) => Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: s,
        height: s,
        decoration: BoxDecoration(
          border: border,
          borderRadius: BorderRadius.circular(3),
          boxShadow: [BoxShadow(color: c.withOpacity(0.5), blurRadius: 6)],
        ),
      ),
    );
    return [
      b(
        off,
        null,
        off,
        null,
        const Border(
          top: BorderSide(color: c, width: t),
          left: BorderSide(color: c, width: t),
        ),
      ),
      b(
        off,
        null,
        null,
        off,
        const Border(
          top: BorderSide(color: c, width: t),
          right: BorderSide(color: c, width: t),
        ),
      ),
      b(
        null,
        off,
        off,
        null,
        const Border(
          bottom: BorderSide(color: c, width: t),
          left: BorderSide(color: c, width: t),
        ),
      ),
      b(
        null,
        off,
        null,
        off,
        const Border(
          bottom: BorderSide(color: c, width: t),
          right: BorderSide(color: c, width: t),
        ),
      ),
    ];
  }
}

class _QRPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = AppTheme.accent.withOpacity(0.16)
      ..style = PaintingStyle.fill;
    final cell = size.width / 7;

    void finder(double x, double y) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, cell * 3, cell * 3),
          const Radius.circular(2.5),
        ),
        p,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + cell * 0.6, y + cell * 0.6, cell * 1.8, cell * 1.8),
          const Radius.circular(1),
        ),
        Paint()
          ..color = AppTheme.surface
          ..style = PaintingStyle.fill,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + cell, y + cell, cell, cell),
          const Radius.circular(1),
        ),
        Paint()
          ..color = AppTheme.accent.withOpacity(0.5)
          ..style = PaintingStyle.fill,
      );
    }

    finder(0, 0);
    finder(4 * cell, 0);
    finder(0, 4 * cell);
    final rng = math.Random(99);
    final b = Paint()
      ..color = AppTheme.accent.withOpacity(0.28)
      ..style = PaintingStyle.fill;
    for (int r = 0; r < 7; r++) {
      for (int c2 = 0; c2 < 7; c2++) {
        if ((r < 3 && c2 < 3) || (r < 3 && c2 > 3) || (r > 3 && c2 < 3))
          continue;
        if (rng.nextBool()) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(c2 * cell + 1, r * cell + 1, cell - 2, cell - 2),
              const Radius.circular(1),
            ),
            rng.nextDouble() > 0.5 ? b : p,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _ScanLine extends StatefulWidget {
  @override
  State<_ScanLine> createState() => _ScanLineState();
}

class _ScanLineState extends State<_ScanLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..repeat(reverse: true);
    _a = CurvedAnimation(parent: _c, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _a,
      builder: (_, __) => Positioned(
        top: 22 + (106 * _a.value),
        left: 22,
        right: 22,
        child: Container(
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppTheme.accent,
                Colors.white,
                AppTheme.accent,
                Colors.transparent,
              ],
              stops: const [0, 0.15, 0.5, 0.85, 1],
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accent.withOpacity(0.8),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Brand text ───────────────────────────────────────────────────────────────
class _Brand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: AppTheme.accent.withOpacity(0.22)),
            color: AppTheme.accent.withOpacity(0.05),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: AppTheme.accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                'EVENT PASS',
                style: GoogleFonts.spaceMono(
                  fontSize: 8.5,
                  color: AppTheme.accent,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [AppTheme.textPri, AppTheme.accent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(b),
          child: Text(
            'QR SCANNER',
            style: GoogleFonts.spaceMono(
              fontSize: 38,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 3,
              height: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 1,
              color: AppTheme.accent.withOpacity(0.3),
            ),
            const SizedBox(width: 10),
            Text(
              'P R O',
              style: GoogleFonts.dmSans(
                fontSize: 10,
                color: AppTheme.accent,
                letterSpacing: 5,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 28,
              height: 1,
              color: AppTheme.accent.withOpacity(0.3),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Feature pills ─────────────────────────────────────────────────────────────
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
          _pill(Icons.bolt_rounded, 'FAST'),
          const SizedBox(width: 10),
          _pill(Icons.shield_outlined, 'SECURE'),
          const SizedBox(width: 10),
          _pill(Icons.cloud_off_outlined, 'OFFLINE'),
        ],
      ),
    );
  }

  Widget _pill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppTheme.accent, size: 16),
          const SizedBox(height: 5),
          Text(
            label,
            style: GoogleFonts.spaceMono(
              fontSize: 7,
              color: AppTheme.accent,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Loading bar ───────────────────────────────────────────────────────────────
class _LoadingBar extends StatelessWidget {
  final AnimationController ctrl;
  const _LoadingBar({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        final p = ctrl.value;
        return Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 180,
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppTheme.surface2,
                    border: Border.all(color: AppTheme.border, width: 0.5),
                  ),
                ),
                Container(
                  width: 180 * p,
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      colors: [AppTheme.accent, AppTheme.accentAlt],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accent.withOpacity(0.6),
                        blurRadius: 8,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                ),
                if (p > 0.01)
                  Positioned(
                    left: 180 * p - 5,
                    top: -3.5,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accent.withOpacity(0.9),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  p < 0.4
                      ? 'INITIALIZING'
                      : p < 0.8
                      ? 'CALIBRATING'
                      : 'READY',
                  style: GoogleFonts.spaceMono(
                    fontSize: 8,
                    color: AppTheme.textSec,
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(p * 100).toInt()}%',
                  style: GoogleFonts.spaceMono(
                    fontSize: 9,
                    color: AppTheme.accent,
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
