import 'package:flutter/material.dart';

class EventTile extends StatelessWidget {
  const EventTile({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final qrGreen = const Color(0xFF4ADE80);
    final cardBg = isDark ? const Color(0xFF161616) : const Color(0xFFF5F9F5);
    final borderColor = isDark
        ? Colors.white.withAlpha(25)
        : Colors.black.withAlpha(20);

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: cardBg,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // --- Image with QR overlay decoration ---
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.network(
                      'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?q=80&w=1742&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondary.withAlpha(50),
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(Icons.error, size: 24),
                        );
                      },
                    ),
                  ),
                ),
                // QR corner brackets overlay
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        // Subtle dark scrim at bottom for text contrast
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 48,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withAlpha(160),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Top-left QR bracket
                        Positioned(
                          top: 10,
                          left: 10,
                          child: _QrCorner(color: qrGreen, rotate: 0),
                        ),
                        // Top-right QR bracket
                        Positioned(
                          top: 10,
                          right: 10,
                          child: _QrCorner(color: qrGreen, rotate: 1),
                        ),
                        // Bottom-left QR bracket
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: _QrCorner(color: qrGreen, rotate: 3),
                        ),
                        // Bottom-right QR bracket
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: _QrCorner(color: qrGreen, rotate: 2),
                        ),
                        // "QR Event" badge
                        Positioned(
                          top: 10,
                          left: 36,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: qrGreen.withAlpha(35),
                              border: Border.all(
                                color: qrGreen.withAlpha(100),
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'QR Event',
                              style: TextStyle(
                                fontSize: 10,
                                color: qrGreen,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // --- Title + Date row ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Some Random Events amkakakadoaidaoiasndnaonasondsanndasndnasoidnando',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withAlpha(18)
                        : Colors.black.withAlpha(10),
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '2040-78-56',
                    style: TextStyle(
                      fontSize: 11,
                      color: qrGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// QR-style corner bracket widget.
/// [rotate]: 0 = top-left, 1 = top-right, 2 = bottom-right, 3 = bottom-left
class _QrCorner extends StatelessWidget {
  final Color color;
  final int rotate; // 0..3 quarter turns

  const _QrCorner({required this.color, required this.rotate});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotate * 3.14159265 / 2,
      child: SizedBox(
        width: 18,
        height: 18,
        child: CustomPaint(painter: _CornerPainter(color: color)),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  const _CornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CornerPainter old) => old.color != color;
}
