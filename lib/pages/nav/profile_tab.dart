import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_app/services/auth_services.dart';
import 'package:qr_app/utils/helper.dart';

class ProfileTab extends StatelessWidget {
  ProfileTab({super.key});

  final _authServices = Get.find<AuthServices>();

  // ── Colors ────────────────────────────────────────────────────
  static const _bg = Color(0xFF0D0D0D);
  static const _surface = Color(0xFF1A1A1A);
  static const _surfaceHigh = Color(0xFF222222);
  static const _border = Color(0xFF2A2A2A);
  static const _accent = Color(0xFFF97316);
  static const _accentDim = Color(0x33F97316);
  static const _textPrimary = Color(0xFFFFFFFF);
  static const _textSecondary = Color(0xFF888888);
  static const _danger = Color(0xFFE05555);
  static const _dangerDim = Color(0x22E05555);

  @override
  Widget build(BuildContext context) {
    final user = _authServices.user.value!;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── HERO / COVER ──────────────────────────────────
              _buildHeroSection(user),

              const SizedBox(height: 24),

              // ── USER INFO ─────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name ?? '',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: _textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          size: 13,
                          color: _textSecondary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          Helper.formatDate(user.createdAt!),
                          style: const TextStyle(
                            fontSize: 13,
                            color: _textSecondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        _roleBadge(user.role),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.email ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── SCAN STATS STRIP ──────────────────────────────
              _buildScanStrip(),

              const SizedBox(height: 28),

              // ── MENU: GENERAL ─────────────────────────────────
              _sectionLabel('General'),
              const SizedBox(height: 10),
              _menuCard([
                _menuItem(icon: Icons.language_rounded, label: 'Language'),
                _menuItem(
                  icon: Icons.currency_exchange_rounded,
                  label: 'Currencies',
                  divider: false,
                ),
              ]),

              const SizedBox(height: 20),

              // ── MENU: SECURITY ────────────────────────────────
              _sectionLabel('Security'),
              const SizedBox(height: 10),
              _menuCard([
                _menuItem(
                  icon: Icons.qr_code_scanner_rounded,
                  label: 'Application Security',
                ),
                _menuItem(icon: Icons.devices_rounded, label: 'Manage Devices'),
                _menuItem(
                  icon: Icons.lock_outline_rounded,
                  label: 'Change Password',
                  divider: false,
                ),
              ]),

              const SizedBox(height: 20),

              // ── MENU: PREFERENCES ─────────────────────────────
              _sectionLabel('Preferences'),
              const SizedBox(height: 10),
              _menuCard([
                _menuItem(icon: Icons.tune_rounded, label: 'Appearance'),
                _menuItem(
                  icon: Icons.description_outlined,
                  label: 'Terms & Conditions',
                  divider: false,
                ),
              ]),

              const SizedBox(height: 28),

              // ── LOGOUT ────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _authServices.logout(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _dangerDim,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(
                          color: Color(0xFF5A2020),
                          width: 0.8,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Log Out',
                      style: TextStyle(
                        color: _danger,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  // ── HERO SECTION ─────────────────────────────────────────────
  Widget _buildHeroSection(dynamic user) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Cover / banner — QR grid pattern background
        Container(
          height: 200,
          width: double.infinity,
          color: const Color(0xFF111111),
          child: Stack(
            children: [
              // QR dot grid pattern
              CustomPaint(
                size: const Size(double.infinity, 200),
                painter: _QrGridPainter(),
              ),
              // Orange gradient overlay bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xFF0D0D0D)],
                    ),
                  ),
                ),
              ),
              // Floating QR frame accent top-right
              Positioned(
                top: 16,
                right: 16,
                child: _QrFrameWidget(
                  size: 60,
                  color: _accent.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),

        // Back button
        Positioned(
          top: 12,
          left: 16,
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 15,
                color: Colors.white,
              ),
            ),
          ),
        ),

        // Edit Photo button
        Positioned(
          top: 12,
          right: 16 + 60 + 12, // offset from QR frame
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: const Text(
              'Edit Photo',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        // Avatar — sits at bottom of cover overlapping body
        Positioned(
          bottom: -44,
          left: 20,
          child: Stack(
            children: [
              // QR ring
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _accent, width: 2.5),
                ),
              ),
              // Corner QR dots on ring
              Positioned(top: 4, left: 4, child: _qrCornerDot()),
              Positioned(top: 4, right: 4, child: _qrCornerDot()),
              Positioned(bottom: 4, left: 4, child: _qrCornerDot()),
              Positioned(bottom: 4, right: 4, child: _qrCornerDot()),
              // Avatar
              Padding(
                padding: const EdgeInsets.all(4),
                child: CircleAvatar(
                  radius: 42,
                  backgroundColor: _surfaceHigh,
                  child: const Icon(
                    Icons.person_rounded,
                    size: 42,
                    color: _textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Edit Profile button — top right of avatar row
        Positioned(
          bottom: -38,
          right: 20,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.edit_rounded, size: 14, color: Colors.white),
            label: const Text(
              'Edit Profile',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _accent,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            onPressed: () {},
          ),
        ),

        // Spacer so column has correct height
        const SizedBox(height: 200 + 44),
      ],
    );
  }

  // ── SCAN STATS STRIP ─────────────────────────────────────────
  Widget _buildScanStrip() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _border),
        ),
        child: Row(
          children: [
            _statItem(Icons.qr_code_2_rounded, 'QR Codes', '12'),
            _vertDivider(),
            _statItem(Icons.qr_code_scanner_rounded, 'Scans', '248'),
            _vertDivider(),
            _statItem(Icons.verified_rounded, 'Verified', '248'),
          ],
        ),
      ),
    );
  }

  Widget _statItem(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 22, color: _accent),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: _textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _vertDivider() {
    return Container(width: 1, height: 40, color: _border);
  }

  // ── Role badge ───────────────────────────────────────────────
  Widget _roleBadge(String? role) {
    final isAdmin = role == 'admin';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: isAdmin ? _accentDim : const Color(0x2244BB66),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isAdmin ? _accent.withOpacity(0.4) : const Color(0x5544BB66),
        ),
      ),
      child: Text(
        role?.toUpperCase() ?? '',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isAdmin ? _accent : const Color(0xFF55CC77),
        ),
      ),
    );
  }

  // ── QR corner dot ────────────────────────────────────────────
  Widget _qrCornerDot() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: _accent,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  // ── Section label ────────────────────────────────────────────
  Widget _sectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: _textSecondary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // ── Menu card ────────────────────────────────────────────────
  Widget _menuCard(List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _border),
        ),
        child: Column(children: items),
      ),
    );
  }

  // ── Menu item ────────────────────────────────────────────────
  Widget _menuItem({
    required IconData icon,
    required String label,
    bool divider = true,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 2,
          ),
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _surfaceHigh,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _border),
            ),
            child: Icon(icon, size: 18, color: _textSecondary),
          ),
          title: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: _textPrimary,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
            color: _textSecondary,
            size: 20,
          ),
          onTap: () {},
        ),
        if (divider)
          Divider(height: 1, indent: 68, endIndent: 16, color: _border),
      ],
    );
  }
}

// ── QR Grid Background Painter ───────────────────────────────────
class _QrGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF97316).withOpacity(0.07)
      ..style = PaintingStyle.fill;

    const spacing = 18.0;
    const dotSize = 3.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        // randomize opacity for QR-like density
        final hash = ((x * 31 + y * 17).toInt()) % 3;
        if (hash == 0) continue;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(x, y),
              width: dotSize,
              height: dotSize,
            ),
            const Radius.circular(1),
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── QR Frame Widget ──────────────────────────────────────────────
class _QrFrameWidget extends StatelessWidget {
  final double size;
  final Color color;
  const _QrFrameWidget({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _QrFramePainter(color: color)),
    );
  }
}

class _QrFramePainter extends CustomPainter {
  final Color color;
  const _QrFramePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    const cornerLen = 14.0;
    const r = 4.0;

    // Top-left
    canvas.drawLine(Offset(r, 0), Offset(cornerLen, 0), paint);
    canvas.drawLine(Offset(0, r), Offset(0, cornerLen), paint);
    canvas.drawArc(
      const Rect.fromLTWH(0, 0, r * 2, r * 2),
      3.14159,
      -3.14159 / 2,
      false,
      paint,
    );

    // Top-right
    canvas.drawLine(
      Offset(size.width - cornerLen, 0),
      Offset(size.width - r, 0),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, r),
      Offset(size.width, cornerLen),
      paint,
    );
    canvas.drawArc(
      Rect.fromLTWH(size.width - r * 2, 0, r * 2, r * 2),
      -3.14159 / 2,
      -3.14159 / 2,
      false,
      paint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(0, size.height - cornerLen),
      Offset(0, size.height - r),
      paint,
    );
    canvas.drawLine(
      Offset(r, size.height),
      Offset(cornerLen, size.height),
      paint,
    );
    canvas.drawArc(
      Rect.fromLTWH(0, size.height - r * 2, r * 2, r * 2),
      3.14159 / 2,
      3.14159 / 2,
      false,
      paint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(size.width - cornerLen, size.height),
      Offset(size.width - r, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height - cornerLen),
      Offset(size.width, size.height - r),
      paint,
    );
    canvas.drawArc(
      Rect.fromLTWH(size.width - r * 2, size.height - r * 2, r * 2, r * 2),
      0,
      3.14159 / 2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
