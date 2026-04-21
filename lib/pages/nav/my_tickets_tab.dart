import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_app/controllers/tickets_controller.dart';
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
      backgroundColor: const Color(0xFF080B14),
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
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        children: [
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
              Icons.confirmation_num_rounded,
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
                  'MY TICKETS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.5,
                  ),
                ),
                Text(
                  'Your event passes',
                  style: TextStyle(
                    color: Color(0xFF5A6080),
                    fontSize: 11,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _controller.fetchTickets(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF161C2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1F2840)),
              ),
              child: const Icon(
                Icons.refresh_rounded,
                color: Color(0xFF5A6080),
                size: 18,
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
        margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1320),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1F2840)),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF3ECFCF)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C63FF).withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFF5A6080),
          labelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
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
            color: Color(0xFF6C63FF),
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

      if (tickets.isEmpty) {
        return _buildEmptyState(type);
      }

      return RefreshIndicator(
        color: const Color(0xFF6C63FF),
        backgroundColor: const Color(0xFF0F1320),
        onRefresh: _controller.fetchTickets,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          itemCount: tickets.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (ctx, i) => _buildTicketCard(tickets[i]),
        ),
      );
    });
  }

  Widget _buildEmptyState(String type) {
    final Map<String, Map<String, dynamic>> config = {
      'active': {
        'icon': Icons.confirmation_num_outlined,
        'title': 'No active tickets',
        'subtitle': 'Reserve an event from the Home tab',
        'color': const Color(0xFF3ECFCF),
      },
      'used': {
        'icon': Icons.check_circle_outline_rounded,
        'title': 'No used tickets yet',
        'subtitle': 'Attended events will appear here',
        'color': const Color(0xFF60A5FA),
      },
      'canceled': {
        'icon': Icons.cancel_outlined,
        'title': 'No canceled tickets',
        'subtitle': 'Canceled tickets will appear here',
        'color': const Color(0xFFFF6B6B),
      },
    };

    final c = config[type]!;
    final color = c['color'] as Color;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.18)),
            ),
            child: Icon(
              c['icon'] as IconData,
              color: color.withOpacity(0.5),
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            c['title'] as String,
            style: const TextStyle(
              color: Color(0xFF8A9BC0),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            c['subtitle'] as String,
            style: const TextStyle(color: Color(0xFF3A4060), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(Ticket ticket) {
    final statusData = _statusConfig(ticket.status);

    return GestureDetector(
      onTap: () => _showTicketDetail(ticket),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F1320),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFF1F2840)),
        ),
        child: Column(
          children: [
            // ── Top: QR + event info ──────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // QR thumbnail with gradient border
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6C63FF), Color(0xFF3ECFCF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ticket.code != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: QrImageView(
                                data: ticket.code!,
                                version: QrVersions.auto,
                                size: 64,
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
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
                                size: 11,
                                color: Color(0xFF5A6080),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat(
                                  'EEE, dd MMM yyyy',
                                ).format(ticket.event!.date!),
                                style: const TextStyle(
                                  color: Color(0xFF5A6080),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 10),
                        // Status badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: (statusData['color'] as Color).withOpacity(
                              0.1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: (statusData['color'] as Color).withOpacity(
                                0.25,
                              ),
                            ),
                          ),
                          child: Text(
                            statusData['label'] as String,
                            style: TextStyle(
                              color: statusData['color'] as Color,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Dashed divider ────────────────────────────
            _buildDashedDivider(),

            // ── Bottom: code + actions ────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.tag_rounded,
                    size: 13,
                    color: Color(0xFF3A4060),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      ticket.shortCode,
                      style: const TextStyle(
                        color: Color(0xFF3A4060),
                        fontSize: 11,
                        fontFamily: 'monospace',
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
                        color: const Color(0xFF60A5FA),
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
                        const SizedBox(width: 8),
                        _actionButton(
                          icon: Icons.close_rounded,
                          color: const Color(0xFFFF6B6B),
                          onTap: () =>
                              _controller.showCancelDialog(context, ticket),
                        ),
                      ],
                      const SizedBox(width: 8),
                      _actionButton(
                        icon: Icons.open_in_full_rounded,
                        color: const Color(0xFF6C63FF),
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
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Icon(icon, size: 14, color: color),
      ),
    );
  }

  Map<String, dynamic> _statusConfig(String status) {
    return switch (status) {
      'active' => {'color': const Color(0xFF3ECFCF), 'label': 'ACTIVE'},
      'used' => {'color': const Color(0xFF60A5FA), 'label': 'USED'},
      _ => {'color': const Color(0xFFFF6B6B), 'label': 'CANCELED'},
    };
  }

  Widget _buildDashedDivider() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 6.0;
        const dashSpace = 4.0;
        final dashCount = (constraints.maxWidth / (dashWidth + dashSpace))
            .floor();
        return Row(
          children: List.generate(dashCount, (_) {
            return Container(
              width: dashWidth,
              height: 1,
              margin: const EdgeInsets.only(right: dashSpace),
              color: const Color(0xFF1F2840),
            );
          }),
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

// ── Ticket detail bottom sheet ────────────────────────────────────────────────
class _TicketDetailSheet extends StatelessWidget {
  final Ticket ticket;

  const _TicketDetailSheet({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final event = ticket.event;
    final statusData = _statusConfig(ticket.status);

    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 40),
      decoration: const BoxDecoration(
        color: Color(0xFF0F1320),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(
          top: BorderSide(color: Color(0xFF1F2840)),
          left: BorderSide(color: Color(0xFF1F2840)),
          right: BorderSide(color: Color(0xFF1F2840)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 14),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF1F2840),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Event name
                  Text(
                    event?.name ?? 'Event Ticket',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (event?.date != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      DateFormat('EEEE, dd MMMM yyyy').format(event!.date!),
                      style: const TextStyle(
                        color: Color(0xFF5A6080),
                        fontSize: 13,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // QR Code with gradient frame
                  if (ticket.code != null)
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        gradient: ticket.isActive
                            ? const LinearGradient(
                                colors: [Color(0xFF6C63FF), Color(0xFF3ECFCF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: ticket.isActive ? null : const Color(0xFF1F2840),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: ticket.isActive
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF6C63FF,
                                  ).withOpacity(0.3),
                                  blurRadius: 24,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            QrImageView(
                              data: ticket.code!,
                              version: QrVersions.auto,
                              size: 210,
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
                                        horizontal: 18,
                                        vertical: 9,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusData['color'] as Color,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                (statusData['color'] as Color)
                                                    .withOpacity(0.4),
                                            blurRadius: 12,
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        ticket.isUsed ? 'USED' : 'CANCELED',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15,
                                          letterSpacing: 3,
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

                  const SizedBox(height: 20),

                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: (statusData['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: (statusData['color'] as Color).withOpacity(0.25),
                      ),
                    ),
                    child: Text(
                      statusData['fullLabel'] as String,
                      style: TextStyle(
                        color: statusData['color'] as Color,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Info card
                  _buildInfoCard(ticket),

                  const SizedBox(height: 16),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: _actionBtn(
                          label: 'Copy Code',
                          icon: Icons.copy_rounded,
                          color: const Color(0xFF60A5FA),
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: _actionBtn(
                            label: 'Cancel',
                            icon: Icons.cancel_outlined,
                            color: const Color(0xFFFF6B6B),
                            onTap: () {
                              Get.back();
                              final c = Get.find<TicketsController>();
                              c.showCancelDialog(context, ticket);
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
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
    final statusData = _statusConfig(ticket.status);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161C2E),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1F2840)),
      ),
      child: Column(
        children: [
          if (event != null) ...[
            _infoRow('Event', event.name ?? '-'),
            _divider(),
            if (event.date != null)
              _infoRow(
                'Date',
                DateFormat('dd MMM yyyy, HH:mm').format(event.date!),
              ),
            _divider(),
            _infoRow('Capacity', '${event.maxReservation ?? '-'} seats'),
            _divider(),
          ],
          _infoRow(
            'Status',
            ticket.status.toUpperCase(),
            valueColor: statusData['color'] as Color,
          ),
          if (ticket.checkedAt != null) ...[
            _divider(),
            _infoRow(
              'Checked in',
              DateFormat('dd MMM yyyy, HH:mm').format(ticket.checkedAt!),
              valueColor: const Color(0xFF60A5FA),
            ),
          ],
          if (ticket.createdAt != null) ...[
            _divider(),
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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF5A6080), fontSize: 13),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(
    height: 1,
    color: Color(0xFF1F2840),
    indent: 18,
    endIndent: 18,
  );

  Map<String, dynamic> _statusConfig(String status) {
    return switch (status) {
      'active' => {
        'color': const Color(0xFF3ECFCF),
        'label': 'ACTIVE',
        'fullLabel': 'Active — Ready to scan',
      },
      'used' => {
        'color': const Color(0xFF60A5FA),
        'label': 'USED',
        'fullLabel': 'Used — Already checked in',
      },
      _ => {
        'color': const Color(0xFFFF6B6B),
        'label': 'CANCELED',
        'fullLabel': 'Canceled',
      },
    };
  }

  Widget _actionBtn({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 13,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
