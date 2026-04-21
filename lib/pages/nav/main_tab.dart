import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_app/controllers/events_controller.dart';
import 'package:qr_app/controllers/tickets_controller.dart';

class MainTab extends StatelessWidget {
  const MainTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EventsController());

    return Scaffold(
      backgroundColor: const Color(0xFF080B14),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 4),
            _buildScannerFrame(context),
            const SizedBox(height: 28),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF0F1320),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEventsHeader(controller),
                    Expanded(child: _buildEventsList(controller)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Row(
        children: [
          // Logo mark
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF3ECFCF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withOpacity(0.4),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.qr_code_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EVENTPASS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.5,
                  ),
                ),
                Text(
                  'Scan · Check-in · Attend',
                  style: TextStyle(
                    color: Color(0xFF5A6080),
                    fontSize: 11,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),
          // Notification bell
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF161C2E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1F2840)),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF5A6080),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerFrame(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('QR Scanner feature will be implemented'),
              backgroundColor: Color(0xFF6C63FF),
            ),
          );
        },
        child: Container(
          height: 188,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF111827), Color(0xFF0F1320)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFF1F2840), width: 1.5),
          ),
          child: Stack(
            children: [
              // Subtle radial glow behind icon
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF6C63FF).withOpacity(0.18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              ..._buildCornerBrackets(),
              // Scan line
              Positioned(
                left: 48,
                right: 48,
                top: 94,
                child: Container(
                  height: 1.5,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.transparent,
                        Color(0xFF3ECFCF),
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3ECFCF).withOpacity(0.6),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF3ECFCF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C63FF).withOpacity(0.35),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'TAP TO SCAN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Position QR code within frame',
                      style: TextStyle(
                        color: Color(0xFF3A4060),
                        fontSize: 11,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCornerBrackets() {
    const color = Color(0xFF6C63FF);
    const size = 22.0;
    const thickness = 2.5;

    Widget corner({
      required bool top,
      required bool left,
    }) {
      return Positioned(
        top: top ? 18 : null,
        bottom: top ? null : 18,
        left: left ? 18 : null,
        right: left ? null : 18,
        child: SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _CornerBracketPainter(
              color: color,
              thickness: thickness,
              isTopLeft: top && left,
              isTopRight: top && !left,
              isBottomLeft: !top && left,
              isBottomRight: !top && !left,
            ),
          ),
        ),
      );
    }

    return [
      corner(top: true, left: true),
      corner(top: true, left: false),
      corner(top: false, left: true),
      corner(top: false, left: false),
    ];
  }

  Widget _buildEventsHeader(EventsController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        children: [
          // Section label pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF3ECFCF)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'LIVE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Events',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF161C2E),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF1F2840)),
              ),
              child: Text(
                '${controller.events.length} total',
                style: const TextStyle(
                  color: Color(0xFF5A6080),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(EventsController controller) {
    return Obx(() {
      if (controller.isLoadingEvents.value) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF6C63FF),
            strokeWidth: 2,
          ),
        );
      }

      if (controller.events.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF161C2E),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF1F2840)),
                ),
                child: Icon(
                  Icons.event_busy_rounded,
                  color: const Color(0xFF3A4060).withOpacity(0.8),
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'No events available',
                style: TextStyle(
                  color: Color(0xFF5A6080),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        color: const Color(0xFF6C63FF),
        backgroundColor: const Color(0xFF0F1320),
        onRefresh: () => controller.fetchEvents(),
        child: ListView.separated(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
          itemCount: controller.events.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (ctx, i) {
            final event = controller.events[i];
            return _buildEventCard(event);
          },
        ),
      );
    });
  }

  Widget _buildEventCard(dynamic event) {
    final dateStr = event.date != null
        ? DateFormat('EEE, dd MMM yyyy').format(event.date!)
        : '-';
    final tickets = event.ticketsCount ?? 0;
    final maxR = event.maxReservation ?? 0;
    final progress = event.progress.clamp(0.0, 1.0);

    final status = event.status;

    // Color scheme per status
    final Color statusColor;
    final Color progressColor;
    final String statusLabel;

    switch (status) {
      case 'completed':
        statusColor = const Color(0xFF60A5FA);
        progressColor = const Color(0xFF60A5FA);
        statusLabel = 'Completed';
        break;
      case 'full':
        statusColor = const Color(0xFFFF6B6B);
        progressColor = const Color(0xFFFF6B6B);
        statusLabel = 'Full';
        break;
      default:
        statusColor = const Color(0xFF3ECFCF);
        progressColor = const Color(0xFF6C63FF);
        statusLabel = 'Active';
    }

    final bool canJoin = status != 'completed' && status != 'full';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161C2E),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF1F2840), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top section ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Color dot accent
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(top: 5, right: 10),
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withOpacity(0.5),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    event.name ?? 'Unnamed Event',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                // Status pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: statusColor.withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (event.desc != null && event.desc!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(38, 8, 18, 0),
              child: Text(
                event.desc!,
                style: const TextStyle(
                  color: Color(0xFF3A4060),
                  fontSize: 13,
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          const SizedBox(height: 16),

          // ── Divider ─────────────────────────────────────
          Container(
            height: 1,
            color: const Color(0xFF1F2840),
          ),

          // ── Meta row ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Row(
              children: [
                _metaChip(
                  icon: Icons.calendar_month_rounded,
                  label: dateStr,
                  color: const Color(0xFF5A6080),
                ),
                const SizedBox(width: 12),
                _metaChip(
                  icon: Icons.group_rounded,
                  label: '$tickets / $maxR',
                  color: const Color(0xFF5A6080),
                ),
                const Spacer(),
                // Compact progress label
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    color: progressColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // ── Progress bar ────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5,
                backgroundColor: const Color(0xFF1F2840),
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
          ),

          // ── CTA Button ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canJoin
                    ? () => Get.find<TicketsController>().reserveTicket(
                          event.id.toString(),
                        )
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  disabledBackgroundColor: const Color(0xFF1A2035),
                  foregroundColor: Colors.white,
                  disabledForegroundColor: const Color(0xFF3A4060),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: EdgeInsets.zero,
                  elevation: 0,
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: canJoin
                        ? const LinearGradient(
                            colors: [Color(0xFF6C63FF), Color(0xFF3ECFCF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        : null,
                    color: canJoin ? null : const Color(0xFF1A2035),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Container(
                    height: 48,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (canJoin) ...[
                          const Icon(
                            Icons.confirmation_num_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          canJoin
                              ? 'Reserve Ticket'
                              : status == 'full'
                                  ? 'Sold Out'
                                  : 'Event Ended',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            letterSpacing: 0.5,
                            color: canJoin
                                ? Colors.white
                                : const Color(0xFF3A4060),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _CornerBracketPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final bool isTopLeft;
  final bool isTopRight;
  final bool isBottomLeft;
  final bool isBottomRight;

  _CornerBracketPainter({
    required this.color,
    required this.thickness,
    required this.isTopLeft,
    required this.isTopRight,
    required this.isBottomLeft,
    required this.isBottomRight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    if (isTopLeft) {
      path.moveTo(size.width, 0);
      path.lineTo(0, 0);
      path.lineTo(0, size.height);
    } else if (isTopRight) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (isBottomLeft) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else if (isBottomRight) {
      path.moveTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}