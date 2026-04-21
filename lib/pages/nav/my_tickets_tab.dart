import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_app/controllers/tickets_controller.dart';
import 'package:qr_app/core/themes.dart';
import 'package:qr_app/models/ticket_model.dart';

class MyTicketsTab extends StatefulWidget {
  const MyTicketsTab({super.key});

  @override
  State<MyTicketsTab> createState() => _MyTicketsTabState();
}

class _MyTicketsTabState extends State<MyTicketsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TicketsController _controller = Get.put(TicketsController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTicketList('active'),
                  _buildTicketList('used'),
                  _buildTicketList('canceled'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
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
              Icons.confirmation_num_rounded,
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
                  'MY TICKETS',
                  style: GoogleFonts.spaceMono(
                    color: AppTheme.textPri,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'Your event passes',
                  style: GoogleFonts.dmSans(
                    color: AppTheme.textSec,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _controller.fetchTickets(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppTheme.surface2,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: AppTheme.border),
              ),
              child: const Icon(
                Icons.refresh_rounded,
                color: AppTheme.textSec,
                size: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Obx(() {
      final active = _controller.activeTickets.length;
      final used = _controller.usedTickets.length;
      final canceled = _controller.canceledTickets.length;
      return Container(
        margin: const EdgeInsets.fromLTRB(20, 14, 20, 0),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: AppTheme.accent,
            borderRadius: BorderRadius.circular(10),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: AppTheme.textSec,
          labelStyle: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
          padding: const EdgeInsets.all(4),
          tabs: [
            Tab(text: 'Active  $active'),
            Tab(text: 'Used  $used'),
            Tab(text: 'Canceled  $canceled'),
          ],
        ),
      );
    });
  }

  Widget _buildTicketList(String type) {
    return Obx(() {
      if (_controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            color: AppTheme.accent,
            strokeWidth: 2,
          ),
        );
      }
      final List<Ticket> tickets = switch (type) {
        'active' => _controller.activeTickets,
        'used' => _controller.usedTickets,
        'canceled' => _controller.canceledTickets,
        _ => [],
      };
      if (tickets.isEmpty) return _buildEmptyState(type);
      return RefreshIndicator(
        color: AppTheme.accent,
        backgroundColor: AppTheme.surface,
        onRefresh: _controller.fetchTickets,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          itemCount: tickets.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (ctx, i) => _buildTicketCard(tickets[i]),
        ),
      );
    });
  }

  Widget _buildEmptyState(String type) {
    final Map<String, Map<String, dynamic>> cfg = {
      'active': {
        'icon': Icons.confirmation_num_outlined,
        'title': 'No active tickets',
        'subtitle': 'Reserve an event from the Home tab',
        'color': AppTheme.success,
      },
      'used': {
        'icon': Icons.check_circle_outline_rounded,
        'title': 'No used tickets yet',
        'subtitle': 'Attended events will appear here',
        'color': AppTheme.info,
      },
      'canceled': {
        'icon': Icons.cancel_outlined,
        'title': 'No canceled tickets',
        'subtitle': 'Canceled tickets will appear here',
        'color': AppTheme.danger,
      },
    };
    final c = cfg[type]!;
    final color = c['color'] as Color;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: color.withOpacity(0.07),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.15)),
            ),
            child: Icon(
              c['icon'] as IconData,
              color: color.withOpacity(0.45),
              size: 32,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            c['title'] as String,
            style: GoogleFonts.dmSans(
              color: AppTheme.textSec,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            c['subtitle'] as String,
            style: GoogleFonts.dmSans(
              color: AppTheme.textSec.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(Ticket ticket) {
    final sd = _statusData(ticket.status);
    return GestureDetector(
      onTap: () => _showTicketDetail(ticket),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          children: [
            // top
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // QR thumbnail
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      gradient: LinearGradient(
                        colors: [AppTheme.accent, AppTheme.accentAlt],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: ticket.code != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(11),
                              child: QrImageView(
                                data: ticket.code!,
                                version: QrVersions.auto,
                                size: 62,
                                backgroundColor: Colors.white,
                                eyeStyle: const QrEyeStyle(
                                  eyeShape: QrEyeShape.square,
                                  color: Colors.black,
                                ),
                                dataModuleStyle: const QrDataModuleStyle(
                                  dataModuleShape: QrDataModuleShape.square,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          : const Icon(Icons.qr_code, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticket.event?.name ?? 'Unknown Event',
                          style: GoogleFonts.dmSans(
                            color: AppTheme.textPri,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (ticket.event?.date != null) ...[
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_month_rounded,
                                size: 10,
                                color: AppTheme.textSec,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat(
                                  'EEE, dd MMM yyyy',
                                ).format(ticket.event!.date!),
                                style: GoogleFonts.dmSans(
                                  color: AppTheme.textSec,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 9),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: (sd['color'] as Color).withOpacity(0.10),
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              color: (sd['color'] as Color).withOpacity(0.22),
                            ),
                          ),
                          child: Text(
                            sd['label'] as String,
                            style: GoogleFonts.dmSans(
                              color: sd['color'] as Color,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // dashed divider
            _dashedDivider(),
            // bottom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              child: Row(
                children: [
                  const Icon(
                    Icons.tag_rounded,
                    size: 12,
                    color: AppTheme.textSec,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      ticket.shortCode,
                      style: GoogleFonts.spaceMono(
                        color: AppTheme.textSec,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _actionButton(
                        icon: Icons.copy_rounded,
                        color: AppTheme.info,
                        onTap: () {
                          if (ticket.code != null) {
                            Clipboard.setData(
                              ClipboardData(text: ticket.code!),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Code copied!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),
                      if (ticket.isActive) ...[
                        const SizedBox(width: 7),
                        _actionButton(
                          icon: Icons.close_rounded,
                          color: AppTheme.danger,
                          onTap: () =>
                              _controller.showCancelDialog(context, ticket),
                        ),
                      ],
                      const SizedBox(width: 7),
                      _actionButton(
                        icon: Icons.open_in_full_rounded,
                        color: AppTheme.accent,
                        onTap: () => _showTicketDetail(ticket),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.18)),
        ),
        child: Icon(icon, size: 13, color: color),
      ),
    );
  }

  Map<String, dynamic> _statusData(String status) => switch (status) {
    'active' => {
      'color': AppTheme.success,
      'label': 'ACTIVE',
      'fullLabel': 'Active — Ready to scan',
    },
    'used' => {
      'color': AppTheme.info,
      'label': 'USED',
      'fullLabel': 'Used — Already checked in',
    },
    _ => {
      'color': AppTheme.danger,
      'label': 'CANCELED',
      'fullLabel': 'Canceled',
    },
  };

  Widget _dashedDivider() {
    return LayoutBuilder(
      builder: (ctx, c) {
        final dashCount = (c.maxWidth / 10).floor();
        return Row(
          children: List.generate(
            dashCount,
            (_) => Container(
              width: 6,
              height: 1,
              margin: const EdgeInsets.only(right: 4),
              color: AppTheme.border,
            ),
          ),
        );
      },
    );
  }

  void _showTicketDetail(Ticket ticket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _TicketDetailSheet(ticket: ticket),
    );
  }
}

// ── Ticket detail sheet ───────────────────────────────────────────────────────
class _TicketDetailSheet extends StatelessWidget {
  final Ticket ticket;
  const _TicketDetailSheet({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final event = ticket.event;
    final sd = _statusData(ticket.status);

    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 40),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: AppTheme.border),
          left: BorderSide(color: AppTheme.border),
          right: BorderSide(color: AppTheme.border),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.border,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    event?.name ?? 'Event Ticket',
                    style: GoogleFonts.dmSans(
                      color: AppTheme.textPri,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (event?.date != null) ...[
                    const SizedBox(height: 5),
                    Text(
                      DateFormat('EEEE, dd MMMM yyyy').format(event!.date!),
                      style: GoogleFonts.dmSans(
                        color: AppTheme.textSec,
                        fontSize: 13,
                      ),
                    ),
                  ],
                  const SizedBox(height: 22),

                  // QR
                  if (ticket.code != null)
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        gradient: ticket.isActive
                            ? const LinearGradient(
                                colors: [AppTheme.accent, AppTheme.accentAlt],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: ticket.isActive ? null : AppTheme.border,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: ticket.isActive
                            ? [
                                BoxShadow(
                                  color: AppTheme.accent.withOpacity(0.25),
                                  blurRadius: 24,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(19),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            QrImageView(
                              data: ticket.code!,
                              version: QrVersions.auto,
                              size: 200,
                              backgroundColor: Colors.white,
                              eyeStyle: const QrEyeStyle(
                                eyeShape: QrEyeShape.square,
                                color: Colors.black,
                              ),
                              dataModuleStyle: const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.square,
                                color: Colors.black,
                              ),
                            ),
                            if (!ticket.isActive)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.55),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: sd['color'] as Color,
                                        borderRadius: BorderRadius.circular(9),
                                      ),
                                      child: Text(
                                        ticket.isUsed ? 'USED' : 'CANCELED',
                                        style: GoogleFonts.spaceMono(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: (sd['color'] as Color).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: (sd['color'] as Color).withOpacity(0.22),
                      ),
                    ),
                    child: Text(
                      sd['fullLabel'] as String,
                      style: GoogleFonts.dmSans(
                        color: sd['color'] as Color,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
                  _buildInfoCard(ticket),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: _sheetBtn(
                          label: 'Copy Code',
                          icon: Icons.copy_rounded,
                          color: AppTheme.info,
                          onTap: () {
                            if (ticket.code != null) {
                              Clipboard.setData(
                                ClipboardData(text: ticket.code!),
                              );
                              Get.back();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Ticket code copied!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      if (ticket.isActive) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: _sheetBtn(
                            label: 'Cancel',
                            icon: Icons.cancel_outlined,
                            color: AppTheme.danger,
                            onTap: () {
                              Get.back();
                              Get.find<TicketsController>().showCancelDialog(
                                context,
                                ticket,
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Ticket ticket) {
    final event = ticket.event;
    final sd = _statusData(ticket.status);
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          if (event != null) ...[
            _infoRow('Event', event.name ?? '-'),
            _div(),
            if (event.date != null)
              _infoRow(
                'Date',
                DateFormat('dd MMM yyyy, HH:mm').format(event.date!),
              ),
            _div(),
            _infoRow('Capacity', '${event.maxReservation ?? '-'} seats'),
            _div(),
          ],
          _infoRow(
            'Status',
            ticket.status.toUpperCase(),
            valueColor: sd['color'] as Color,
          ),
          if (ticket.checkedAt != null) ...[
            _div(),
            _infoRow(
              'Checked in',
              DateFormat('dd MMM yyyy, HH:mm').format(ticket.checkedAt!),
              valueColor: AppTheme.info,
            ),
          ],
          if (ticket.createdAt != null) ...[
            _div(),
            _infoRow(
              'Issued',
              DateFormat('dd MMM yyyy').format(ticket.createdAt!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              color: valueColor ?? AppTheme.textPri,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _div() => const Divider(
    height: 1,
    color: AppTheme.border,
    indent: 16,
    endIndent: 16,
  );

  Map<String, dynamic> _statusData(String status) => switch (status) {
    'active' => {
      'color': AppTheme.success,
      'label': 'ACTIVE',
      'fullLabel': 'Active — Ready to scan',
    },
    'used' => {
      'color': AppTheme.info,
      'label': 'USED',
      'fullLabel': 'Used — Already checked in',
    },
    _ => {
      'color': AppTheme.danger,
      'label': 'CANCELED',
      'fullLabel': 'Canceled',
    },
  };

  Widget _sheetBtn({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: color.withOpacity(0.22)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 7),
            Text(
              label,
              style: GoogleFonts.dmSans(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
