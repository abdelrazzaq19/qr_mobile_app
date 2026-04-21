import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_app/controllers/events_controller.dart';
import 'package:qr_app/models/events_model.dart';
import 'package:qr_app/utils/show_snack.dart';

class EventsTab extends StatelessWidget {
  const EventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EventsController());

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFFF97316),
          onRefresh: () => controller.fetchEvents(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, controller),
                const SizedBox(height: 24),
                _buildStatsRow(controller),
                const SizedBox(height: 28),
                _buildSectionTitle('Recent Events'),
                const SizedBox(height: 12),
                _buildEventList(context, controller),
                const SizedBox(height: 28),
                _buildSectionTitle('Quick Actions'),
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
        backgroundColor: const Color(0xFFF97316),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'New Event',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ── HEADER ────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, EventsController controller) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFF97316).withOpacity(0.4)),
          ),
          child: const Icon(
            Icons.campaign_rounded,
            color: Color(0xFFF97316),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Events Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'Manage & monitor your events',
                style: TextStyle(color: Color(0xFF888888), fontSize: 12),
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
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Icon(icon, color: const Color(0xFF888888), size: 18),
      ),
      
    );
  }

  // ── STATS ─────────────────────────────────────────────────────
  Widget _buildStatsRow(EventsController controller) {
    return Obx(() {
      final loading = controller.isLoadingEvents.value;
      return Row(
        children: [
          Expanded(
            child: _statCard(
              icon: Icons.event_rounded,
              label: 'Total Events',
              value: loading ? '...' : controller.totalEvents.toString(),
              color: const Color(0xFFF97316),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _statCard(
              icon: Icons.confirmation_num_rounded,
              label: 'Reservations',
              value: loading ? '...' : _fmt(controller.totalTicketsSold),
              color: const Color(0xFF4ADE80),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _statCard(
              icon: Icons.people_rounded,
              label: 'Capacity',
              value: loading ? '...' : _fmt(controller.totalCapacity),
              color: const Color(0xFF60A5FA),
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
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF888888), fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: Color(0xFF888888),
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }

  // ── EVENT LIST ────────────────────────────────────────────────
  Widget _buildEventList(BuildContext context, EventsController controller) {
    return Obx(() {
      if (controller.isLoadingEvents.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: CircularProgressIndicator(color: Color(0xFFF97316)),
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
                color: const Color(0xFF888888).withOpacity(0.4),
                size: 52,
              ),
              const SizedBox(height: 12),
              const Text(
                'No events yet',
                style: TextStyle(color: Color(0xFF888888), fontSize: 15),
              ),
              const SizedBox(height: 6),
              const Text(
                'Tap + to create one',
                style: TextStyle(color: Color(0xFF555555), fontSize: 12),
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

  // ── EVENT CARD ────────────────────────────────────────────────
  Widget _buildEventCard(
    BuildContext context,
    EventsController controller,
    Event event,
  ) {
    final status = event.status;
    final statusColor = switch (status) {
      'completed' => const Color(0xFF60A5FA),
      'full' => const Color(0xFFE05555),
      _ => const Color(0xFF4ADE80),
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
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Badge
          Row(
            children: [
              Expanded(
                child: Text(
                  event.name ?? '-',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(0.35)),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          // Description
          if (event.desc != null && event.desc!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              event.desc!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
            ),
          ],

          const SizedBox(height: 10),

          // Date & reservations
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 13,
                color: Color(0xFF888888),
              ),
              const SizedBox(width: 5),
              Text(
                dateStr,
                style: const TextStyle(color: Color(0xFF888888), fontSize: 12),
              ),
              const SizedBox(width: 14),
              const Icon(
                Icons.people_outline_rounded,
                size: 13,
                color: Color(0xFF888888),
              ),
              const SizedBox(width: 5),
              Text(
                '$tickets / $maxR',
                style: const TextStyle(color: Color(0xFF888888), fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Capacity filled',
                style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 11),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  color: statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: const Color(0xFF2A2A2A),
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            ),
          ),

          const SizedBox(height: 14),

          // Actions
          Row(
            children: [
              Expanded(
                child: _actionBtn(
                  icon: Icons.qr_code_scanner_rounded,
                  label: 'Scan',
                  color: const Color(0xFFF97316),
                  onTap: () => _showScanDialog(context, controller),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _actionBtn(
                  icon: Icons.people_alt_rounded,
                  label: 'Tickets',
                  color: const Color(0xFF60A5FA),
                  onTap: () => _showTicketsDialog(context, event),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _actionBtn(
                  icon: Icons.edit_rounded,
                  label: 'Edit',
                  color: const Color(0xFF888888),
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
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
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
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFE05555).withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE05555).withOpacity(0.2)),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          size: 16,
          color: Color(0xFFE05555),
        ),
      ),
    );
  }

  // ── SCAN / CHECK-IN DIALOG ────────────────────────────────────
  void _showScanDialog(BuildContext context, EventsController controller) {
    final codeCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Check-In Ticket',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter ticket code to check in the attendee.',
              style: TextStyle(color: Color(0xFF888888), fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: codeCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'ikutan-xxxx-...',
                hintStyle: const TextStyle(color: Color(0xFF555555)),
                prefixIcon: const Icon(
                  Icons.qr_code_rounded,
                  color: Color(0xFF888888),
                  size: 20,
                ),
                filled: true,
                fillColor: const Color(0xFF222222),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFF97316),
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
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF888888)),
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
            child: const Text(
              'Check In',
              style: TextStyle(
                color: Color(0xFFF97316),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── TICKETS INFO DIALOG ───────────────────────────────────────
  void _showTicketsDialog(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          event.name ?? 'Event',
          style: const TextStyle(
            color: Colors.white,
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
            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xFFF97316)),
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
            style: const TextStyle(color: Color(0xFF888888), fontSize: 13),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ── QUICK ACTIONS ─────────────────────────────────────────────
  Widget _buildQuickActions(BuildContext context, EventsController controller) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.4,
      children: [
        _quickCard(
          icon: Icons.add_circle_outline_rounded,
          label: 'Create Event',
          color: const Color(0xFFF97316),
          onTap: () => controller.showCreateSheet(context),
        ),
        _quickCard(
          icon: Icons.qr_code_scanner_rounded,
          label: 'Check-In Scan',
          color: const Color(0xFF4ADE80),
          onTap: () => _showScanDialog(context, controller),
        ),
        _quickCard(
          icon: Icons.refresh_rounded,
          label: 'Refresh Data',
          color: const Color(0xFF60A5FA),
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
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── SUMMARY DIALOG ────────────────────────────────────────────
  void _showSummary(BuildContext context, EventsController controller) {
    final evts = controller.events;
    final active = evts.where((e) => e.status == 'active').length;
    final completed = evts.where((e) => e.status == 'completed').length;
    final full = evts.where((e) => e.status == 'full').length;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Summary',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _infoRow('Total Events', controller.totalEvents.toString()),
            _infoRow('Active', active.toString()),
            _infoRow('Completed', completed.toString()),
            _infoRow('Full', full.toString()),
            const Divider(color: Color(0xFF2A2A2A), height: 20),
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
            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xFFF97316)),
            ),
          ),
        ],
      ),
    );
  }
}
