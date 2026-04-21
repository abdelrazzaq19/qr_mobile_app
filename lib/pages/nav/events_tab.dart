import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qr_app/controllers/events_controller.dart';
import 'package:qr_app/core/themes.dart';
import 'package:qr_app/models/events_model.dart';
import 'package:qr_app/utils/show_snack.dart';

class EventsTab extends StatelessWidget {
  const EventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EventsController());

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.accent,
          backgroundColor: AppTheme.surface,
          onRefresh: () => controller.fetchEvents(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, controller),
                const SizedBox(height: 22),
                _buildStatsRow(controller),
                const SizedBox(height: 26),
                _sectionLabel('EVENTS'),
                const SizedBox(height: 12),
                _buildEventList(context, controller),
                const SizedBox(height: 26),
                _sectionLabel('QUICK ACTIONS'),
                const SizedBox(height: 12),
                _buildQuickActions(context, controller),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => controller.showCreateSheet(context),
        backgroundColor: AppTheme.accent,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'New Event',
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 4,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, EventsController controller) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.accent.withOpacity(0.3)),
          ),
          child: const Icon(
            Icons.campaign_rounded,
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
                'Events Dashboard',
                style: GoogleFonts.dmSans(
                  color: AppTheme.textPri,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'Manage & monitor your events',
                style: GoogleFonts.dmSans(
                  color: AppTheme.textSec,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        _iconBtn(Icons.refresh_rounded, onTap: () => controller.fetchEvents()),
        const SizedBox(width: 8),
        _iconBtn(Icons.tune_rounded),
      ],
    );
  }

  Widget _iconBtn(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.border),
        ),
        child: Icon(icon, color: AppTheme.textSec, size: 16),
      ),
    );
  }

  Widget _buildStatsRow(EventsController controller) {
    return Obx(() {
      final loading = controller.isLoadingEvents.value;
      return Row(
        children: [
          Expanded(
            child: _statCard(
              icon: Icons.event_rounded,
              label: 'Events',
              value: loading ? '-' : controller.totalEvents.toString(),
              color: AppTheme.accent,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _statCard(
              icon: Icons.confirmation_num_rounded,
              label: 'Reserved',
              value: loading ? '-' : _fmt(controller.totalTicketsSold),
              color: AppTheme.success,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _statCard(
              icon: Icons.people_rounded,
              label: 'Capacity',
              value: loading ? '-' : _fmt(controller.totalCapacity),
              color: AppTheme.info,
            ),
          ),
        ],
      );
    });
  }

  String _fmt(int n) =>
      n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : n.toString();

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: color, size: 15),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.dmSans(
              color: AppTheme.textPri,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.dmSans(color: AppTheme.textSec, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
    text,
    style: GoogleFonts.dmSans(
      color: AppTheme.textSec,
      fontSize: 10,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.5,
    ),
  );

  Widget _buildEventList(BuildContext context, EventsController controller) {
    return Obx(() {
      if (controller.isLoadingEvents.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: CircularProgressIndicator(
              color: AppTheme.accent,
              strokeWidth: 2,
            ),
          ),
        );
      }
      if (controller.events.isEmpty) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          alignment: Alignment.center,
          child: Column(
            children: [
              Icon(
                Icons.event_busy_rounded,
                color: AppTheme.textSec.withOpacity(0.3),
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                'No events yet',
                style: GoogleFonts.dmSans(
                  color: AppTheme.textSec,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Tap + to create one',
                style: GoogleFonts.dmSans(
                  color: AppTheme.textSec.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.events.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (ctx, i) =>
            _buildEventCard(ctx, controller, controller.events[i]),
      );
    });
  }

  Widget _buildEventCard(
    BuildContext context,
    EventsController controller,
    Event event,
  ) {
    final status = event.status;
    final Color statusColor = switch (status) {
      'completed' => AppTheme.info,
      'full' => AppTheme.danger,
      _ => AppTheme.success,
    };
    final statusLabel = switch (status) {
      'completed' => 'Completed',
      'full' => 'Full',
      _ => 'Active',
    };
    final dateStr = event.date != null
        ? DateFormat('dd MMM yyyy').format(event.date!)
        : '-';
    final tickets = event.ticketsCount ?? 0;
    final maxR = event.maxReservation ?? 0;
    final progress = event.progress.clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title + badge
          Row(
            children: [
              Expanded(
                child: Text(
                  event.name ?? '-',
                  style: GoogleFonts.dmSans(
                    color: AppTheme.textPri,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: statusColor.withOpacity(0.25)),
                ),
                child: Text(
                  statusLabel,
                  style: GoogleFonts.dmSans(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (event.desc != null && event.desc!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              event.desc!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.dmSans(color: AppTheme.textSec, fontSize: 12),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 12,
                color: AppTheme.textSec,
              ),
              const SizedBox(width: 5),
              Text(
                dateStr,
                style: GoogleFonts.dmSans(
                  color: AppTheme.textSec,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.people_outline_rounded,
                size: 12,
                color: AppTheme.textSec,
              ),
              const SizedBox(width: 5),
              Text(
                '$tickets / $maxR',
                style: GoogleFonts.dmSans(
                  color: AppTheme.textSec,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Capacity',
                style: GoogleFonts.dmSans(
                  color: AppTheme.textSec,
                  fontSize: 11,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: GoogleFonts.dmSans(
                  color: statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: AppTheme.border,
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            ),
          ),
          const SizedBox(height: 14),
          // actions
          Row(
            children: [
              Expanded(
                child: _actionBtn(
                  icon: Icons.qr_code_scanner_rounded,
                  label: 'Scan',
                  color: AppTheme.accent,
                  onTap: () => _showScanDialog(context, controller),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _actionBtn(
                  icon: Icons.people_alt_rounded,
                  label: 'Tickets',
                  color: AppTheme.info,
                  onTap: () => _showTicketsDialog(context, event),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _actionBtn(
                  icon: Icons.edit_rounded,
                  label: 'Edit',
                  color: AppTheme.textSec,
                  onTap: () => controller.showEditSheet(context, event),
                ),
              ),
              const SizedBox(width: 8),
              _deleteBtn(
                onTap: () => controller.showDeleteDialog(context, event),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.18)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.dmSans(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _deleteBtn({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppTheme.danger.withOpacity(0.07),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.danger.withOpacity(0.18)),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          size: 15,
          color: AppTheme.danger,
        ),
      ),
    );
  }

  void _showScanDialog(BuildContext context, EventsController controller) {
    final codeCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppTheme.border),
        ),
        title: Text(
          'Check-In Ticket',
          style: GoogleFonts.dmSans(
            color: AppTheme.textPri,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter ticket code to check in the attendee.',
              style: GoogleFonts.dmSans(color: AppTheme.textSec, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: codeCtrl,
              style: const TextStyle(color: AppTheme.textPri),
              decoration: InputDecoration(
                hintText: 'ikutan-xxxx-...',
                hintStyle: const TextStyle(color: AppTheme.textSec),
                prefixIcon: const Icon(
                  Icons.qr_code_rounded,
                  color: AppTheme.textSec,
                  size: 18,
                ),
                filled: true,
                fillColor: AppTheme.surface2,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(color: AppTheme.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(color: AppTheme.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(
                    color: AppTheme.accent,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.dmSans(color: AppTheme.textSec),
            ),
          ),
          TextButton(
            onPressed: () async {
              final code = codeCtrl.text.trim();
              if (code.isEmpty) return;
              Get.back();
              try {
                final res = await controller.eventProvider.checkIn(code: code);
                if (res.isOk) {
                  ShowSnack.success(res.body['message'] ?? 'Checked in!');
                  controller.fetchEvents();
                } else {
                  ShowSnack.error(res.body['message'] ?? 'Check-in failed');
                }
              } catch (e) {
                ShowSnack.error(e.toString());
              }
            },
            child: Text(
              'Check In',
              style: GoogleFonts.dmSans(
                color: AppTheme.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTicketsDialog(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppTheme.border),
        ),
        title: Text(
          event.name ?? 'Event',
          style: GoogleFonts.dmSans(
            color: AppTheme.textPri,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _infoRow('Reservations', (event.ticketsCount ?? 0).toString()),
            _infoRow('Max Capacity', (event.maxReservation ?? 0).toString()),
            _infoRow(
              'Available',
              ((event.maxReservation ?? 0) - (event.ticketsCount ?? 0))
                  .clamp(0, event.maxReservation ?? 0)
                  .toString(),
            ),
            _infoRow('Status', event.status.toUpperCase()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Close',
              style: GoogleFonts.dmSans(color: AppTheme.accent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(color: AppTheme.textSec, fontSize: 13),
          ),
          Text(
            value,
            style: GoogleFonts.dmSans(
              color: AppTheme.textPri,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, EventsController controller) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.5,
      children: [
        _quickCard(
          icon: Icons.add_circle_outline_rounded,
          label: 'Create Event',
          color: AppTheme.accent,
          onTap: () => controller.showCreateSheet(context),
        ),
        _quickCard(
          icon: Icons.qr_code_scanner_rounded,
          label: 'Check-In Scan',
          color: AppTheme.success,
          onTap: () => _showScanDialog(context, controller),
        ),
        _quickCard(
          icon: Icons.refresh_rounded,
          label: 'Refresh Data',
          color: AppTheme.info,
          onTap: () => controller.fetchEvents(),
        ),
        _quickCard(
          icon: Icons.bar_chart_rounded,
          label: 'Summary',
          color: const Color(0xFFA78BFA),
          onTap: () => _showSummary(context, controller),
        ),
      ],
    );
  }

  Widget _quickCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 14),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.dmSans(
                  color: AppTheme.textPri,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSummary(BuildContext context, EventsController controller) {
    final evts = controller.events;
    final active = evts.where((e) => e.status == 'active').length;
    final completed = evts.where((e) => e.status == 'completed').length;
    final full = evts.where((e) => e.status == 'full').length;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppTheme.border),
        ),
        title: Text(
          'Summary',
          style: GoogleFonts.dmSans(
            color: AppTheme.textPri,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _infoRow('Total Events', controller.totalEvents.toString()),
            _infoRow('Active', active.toString()),
            _infoRow('Completed', completed.toString()),
            _infoRow('Full', full.toString()),
            const Divider(color: AppTheme.border, height: 20),
            _infoRow(
              'Total Reservations',
              controller.totalTicketsSold.toString(),
            ),
            _infoRow('Total Capacity', controller.totalCapacity.toString()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Close',
              style: GoogleFonts.dmSans(color: AppTheme.accent),
            ),
          ),
        ],
      ),
    );
  }
}
