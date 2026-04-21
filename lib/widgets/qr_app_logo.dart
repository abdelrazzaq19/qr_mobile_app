import 'package:flutter/material.dart';

/// Gunakan QrAppLogo di mana saja:
///
///   QrAppLogo(size: 80)                  // icon saja
///   QrAppLogo(size: 64, withWordmark: true)  // icon + wordmark
///
class QrAppLogo extends StatelessWidget {
  final double size;
  final bool withWordmark;
  final Color accentColor;

  const QrAppLogo({
    super.key,
    this.size = 80,
    this.withWordmark = false,
    this.accentColor = const Color(0xFFF97316),
  });

  @override
  Widget build(BuildContext context) {
    if (!withWordmark) {
      return SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _QrIconPainter(accent: accentColor)),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: _QrIconPainter(accent: accentColor)),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'QRify',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: size * 0.34,
                fontWeight: FontWeight.w800,
                color: accentColor,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'SCANNER',
              style: TextStyle(
                fontSize: size * 0.145,
                fontWeight: FontWeight.w500,
                color: Colors.white38,
                letterSpacing: 2.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Painter ───────────────────────────────────────────────────────

class _QrIconPainter extends CustomPainter {
  final Color accent;
  const _QrIconPainter({required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;

    // ── Background rounded square ─────────────────────────────
    final bgPaint = Paint()..color = const Color(0xFF1A1A1A);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, s, s),
        Radius.circular(s * 0.22),
      ),
      bgPaint,
    );

    // ── Helpers ───────────────────────────────────────────────
    final strokePaint = Paint()
      ..color = accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.03
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = accent
      ..style = PaintingStyle.fill;

    final pad = s * 0.14;
    final cSize = s * 0.26; // corner square outer
    final iSize = s * 0.11; // corner square inner fill
    final cRadius = s * 0.06;
    final iRadius = s * 0.025;
    final iOffset = (cSize - iSize) / 2;

    // ── Three corner brackets ─────────────────────────────────
    final corners = [
      Offset(pad, pad), // top-left
      Offset(s - pad - cSize, pad), // top-right
      Offset(pad, s - pad - cSize), // bottom-left
    ];

    for (final c in corners) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(c.dx, c.dy, cSize, cSize),
          Radius.circular(cRadius),
        ),
        strokePaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(c.dx + iOffset, c.dy + iOffset, iSize, iSize),
          Radius.circular(iRadius),
        ),
        fillPaint,
      );
    }

    // ── Data modules grid ─────────────────────────────────────
    final modules = <_Module>[
      // right of top-left area
      _Module(0.62, 0.145, 0.9),
      _Module(0.73, 0.145, 0.5),
      _Module(0.62, 0.255, 0.4),
      _Module(0.73, 0.255, 0.8),
      _Module(0.62, 0.365, 0.6),
      _Module(0.73, 0.365, 0.3),
      // below top-left area
      _Module(0.145, 0.62, 0.7),
      _Module(0.255, 0.62, 0.9),
      _Module(0.365, 0.62, 0.4),
      _Module(0.145, 0.73, 0.9),
      _Module(0.255, 0.73, 0.3),
      _Module(0.365, 0.73, 0.8),
      // bottom-right quadrant
      _Module(0.62, 0.62, 0.9),
      _Module(0.73, 0.62, 0.4),
      _Module(0.84, 0.62, 0.7),
      _Module(0.62, 0.73, 0.3),
      _Module(0.73, 0.73, 0.9),
      _Module(0.84, 0.73, 0.5),
      _Module(0.62, 0.84, 0.8),
      _Module(0.73, 0.84, 0.4),
      _Module(0.84, 0.84, 0.9),
    ];

    final dotSize = s * 0.075;
    final dotRadius = s * 0.015;

    for (final m in modules) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(s * m.x, s * m.y, dotSize, dotSize),
          Radius.circular(dotRadius),
        ),
        Paint()
          ..color = accent.withOpacity(m.opacity)
          ..style = PaintingStyle.fill,
      );
    }

    // ── Subtle scan line ──────────────────────────────────────
    canvas.drawLine(
      Offset(s * 0.08, s * 0.5),
      Offset(s * 0.92, s * 0.5),
      Paint()
        ..color = accent.withOpacity(0.15)
        ..strokeWidth = s * 0.012,
    );
  }

  @override
  bool shouldRepaint(covariant _QrIconPainter old) => old.accent != accent;
}

class _Module {
  final double x, y, opacity;
  const _Module(this.x, this.y, this.opacity);
}
