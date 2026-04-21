import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qr_app/controllers/events_controller.dart';
import 'package:qr_app/controllers/tickets_controller.dart';
import 'package:qr_app/core/themes.dart';

class MainTab extends StatelessWidget {
  const MainTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EventsController());

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildScannerFrame(context),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  border: Border(top: BorderSide(color: AppTheme.border)),
                ),
                child: Column(
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
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: AppTheme.accent.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accent.withOpacity(0.1),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.qr_code_rounded,
              color: AppTheme.accent,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EVENTPASS',
                  style: GoogleFonts.spaceMono(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPri,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'Scan · Check-in · Attend',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: AppTheme.textSec,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppTheme.surface2,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: AppTheme.border),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: AppTheme.textSec,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerFrame(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('QR Scanner feature will be implemented'),
            backgroundColor: AppTheme.surface2,
          ),
        ),
        child: Container(
          height: 176,
          decoration: BoxDecoration(
            color: AppTheme.surface2,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.border),
          ),
          child: Stack(
            children: [
              // glow center
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.accent.withOpacity(0.10),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // corners
              ..._corners(),
              // scan line
              Positioned(
                left: 52,
                right: 52,
                top: 88,
                child: Container(
                  height: 1.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppTheme.accent,
                        AppTheme.accent,
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accent.withOpacity(0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
              // center content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.accent,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accent.withOpacity(0.35),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'TAP TO SCAN',
                      style: GoogleFonts.spaceMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPri,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Position QR code within frame',
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        color: AppTheme.textSec,
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

  List<Widget> _corners() {
    const color = AppTheme.accent;
    const s = 20.0, t = 2.2, off = 16.0;
    Widget b(
      double? top,
      double? bot,
      double? left,
      double? right,
      Border border,
    ) => Positioned(
      top: top,
      bottom: bot,
      left: left,
      right: right,
      child: Container(
        width: s,
        height: s,
        decoration: BoxDecoration(
          border: border,
          borderRadius: BorderRadius.circular(3),
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
          top: BorderSide(color: color, width: t),
          left: BorderSide(color: color, width: t),
        ),
      ),
      b(
        off,
        null,
        null,
        off,
        const Border(
          top: BorderSide(color: color, width: t),
          right: BorderSide(color: color, width: t),
        ),
      ),
      b(
        null,
        off,
        off,
        null,
        const Border(
          bottom: BorderSide(color: color, width: t),
          left: BorderSide(color: color, width: t),
        ),
      ),
      b(
        null,
        off,
        null,
        off,
        const Border(
          bottom: BorderSide(color: color, width: t),
          right: BorderSide(color: color, width: t),
        ),
      ),
    ];
  }

  Widget _buildEventsHeader(EventsController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.accent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'LIVE',
              style: GoogleFonts.spaceMono(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Events',
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPri,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.surface2,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: AppTheme.border),
              ),
              child: Text(
                '${controller.events.length} total',
                style: GoogleFonts.dmSans(
                  color: AppTheme.textSec,
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
            color: AppTheme.accent,
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
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppTheme.surface2,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.border),
                ),
                child: Icon(
                  Icons.event_busy_rounded,
                  color: AppTheme.textSec.withOpacity(0.5),
                  size: 32,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'No events available',
                style: GoogleFonts.dmSans(
                  color: AppTheme.textSec,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }
      return RefreshIndicator(
        color: AppTheme.accent,
        backgroundColor: AppTheme.surface,
        onRefresh: () => controller.fetchEvents(),
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          itemCount: controller.events.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (ctx, i) => _buildEventCard(controller.events[i]),
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
    final progress = event.progress.clamp(0.0, 1.0) as double;
    final status = event.status as String;

    final Color statusColor;
    final String statusLabel;
    switch (status) {
      case 'completed':
        statusColor = AppTheme.info;
        statusLabel = 'Completed';
        break;
      case 'full':
        statusColor = AppTheme.danger;
        statusLabel = 'Full';
        break;
      default:
        statusColor = AppTheme.success;
        statusLabel = 'Active';
    }
    final canJoin = status != 'completed' && status != 'full';

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // top
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6, right: 10),
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
                    style: GoogleFonts.dmSans(
                      color: AppTheme.textPri,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: statusColor.withOpacity(0.22)),
                  ),
                  child: Text(
                    statusLabel,
                    style: GoogleFonts.dmSans(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (event.desc != null && event.desc!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(34, 7, 16, 0),
              child: Text(
                event.desc!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.dmSans(
                  color: AppTheme.textSec,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ),
          const SizedBox(height: 14),
          Container(height: 1, color: AppTheme.border),
          // meta row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            child: Row(
              children: [
                _metaChip(Icons.calendar_month_rounded, dateStr),
                const SizedBox(width: 12),
                _metaChip(Icons.group_rounded, '$tickets / $maxR'),
                const Spacer(),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: GoogleFonts.dmSans(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          // progress
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: AppTheme.border,
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
            ),
          ),
          // CTA
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canJoin
                    ? () => Get.find<TicketsController>().reserveTicket(
                        event.id.toString(),
                      )
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canJoin
                      ? AppTheme.accent
                      : AppTheme.surface2,
                  disabledBackgroundColor: AppTheme.surface2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (canJoin) ...[
                      const Icon(
                        Icons.confirmation_num_rounded,
                        size: 15,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 7),
                    ],
                    Text(
                      canJoin
                          ? 'Reserve Ticket'
                          : status == 'full'
                          ? 'Sold Out'
                          : 'Event Ended',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: canJoin ? Colors.white : AppTheme.textSec,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppTheme.textSec),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.dmSans(
            color: AppTheme.textSec,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
