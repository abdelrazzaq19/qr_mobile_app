import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_app/services/auth_services.dart';
import 'package:qr_app/utils/helper.dart';

class ProfileTab extends StatelessWidget {
  ProfileTab({super.key});

  final _authServices = Get.find<AuthServices>();

  // ── Palette ───────────────────────────────────────────────────
  static const _bg         = Color(0xFF111111);
  static const _card        = Color(0xFF1C1C1C);
  static const _border      = Color(0xFF2B2B2B);
  static const _accent      = Color(0xFFF97316);
  static const _textPri     = Color(0xFFFFFFFF);
  static const _textSec     = Color(0xFF888888);
  static const _danger      = Color(0xFFE05555);

  @override
  Widget build(BuildContext context) {
    final user = _authServices.user.value!;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // ── Avatar + name ────────────────────────────────
              Row(
                children: [
                  // Avatar circle with accent ring
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: _accent, width: 2),
                    ),
                    child: const CircleAvatar(
                      backgroundColor: Color(0xFF242424),
                      child: Icon(Icons.person_rounded,
                          size: 32, color: _textSec),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name ?? '',
                          style: const TextStyle(
                            color: _textPri,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          user.email ?? '',
                          style: const TextStyle(
                              color: _textSec, fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _roleBadge(user.role),
                            const SizedBox(width: 8),
                            const Icon(Icons.calendar_today_rounded,
                                size: 12, color: _textSec),
                            const SizedBox(width: 4),
                            Text(
                              Helper.formatDate(user.createdAt!),
                              style: const TextStyle(
                                  color: _textSec, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Edit icon
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _border),
                      ),
                      child: const Icon(Icons.edit_outlined,
                          size: 16, color: _textSec),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Stats strip ───────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _border),
                ),
                child: Row(
                  children: [
                    _stat('12', 'QR Codes'),
                    _divider(),
                    _stat('248', 'Scans'),
                    _divider(),
                    _stat('248', 'Verified'),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── General ───────────────────────────────────────
              _sectionLabel('General'),
              const SizedBox(height: 8),
              _menuCard([
                _item(Icons.language_rounded, 'Language'),
                _item(Icons.currency_exchange_rounded, 'Currencies',
                    last: true),
              ]),

              const SizedBox(height: 20),

              // ── Security ──────────────────────────────────────
              _sectionLabel('Security'),
              const SizedBox(height: 8),
              _menuCard([
                _item(Icons.qr_code_scanner_rounded, 'Application Security'),
                _item(Icons.devices_rounded, 'Manage Devices'),
                _item(Icons.lock_outline_rounded, 'Change Password',
                    last: true),
              ]),

              const SizedBox(height: 20),

              // ── Preferences ───────────────────────────────────
              _sectionLabel('Preferences'),
              const SizedBox(height: 8),
              _menuCard([
                _item(Icons.tune_rounded, 'Appearance'),
                _item(Icons.description_outlined, 'Terms & Conditions',
                    last: true),
              ]),

              const SizedBox(height: 28),

              // ── Logout ────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _authServices.logout(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _danger.withOpacity(0.1),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                          color: _danger.withOpacity(0.3), width: 0.8),
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

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────

  Widget _roleBadge(String? role) {
    final isAdmin = role == 'admin';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isAdmin
            ? _accent.withOpacity(0.12)
            : const Color(0x1A44BB66),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: isAdmin
              ? _accent.withOpacity(0.35)
              : const Color(0x4044BB66),
          width: 0.5,
        ),
      ),
      child: Text(
        role?.toUpperCase() ?? '',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: isAdmin ? _accent : const Color(0xFF55CC77),
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: _accent,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(color: _textSec, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _divider() =>
      Container(width: 0.5, height: 32, color: _border);

  Widget _sectionLabel(String title) => Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _textSec,
          letterSpacing: 1.0,
        ),
      );

  Widget _menuCard(List<Widget> items) => Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        child: Column(children: items),
      );

  Widget _item(IconData icon, String label, {bool last = false}) {
    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          dense: true,
          leading: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFF242424),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: _border, width: 0.5),
            ),
            child: Icon(icon, size: 17, color: _textSec),
          ),
          title: Text(label,
              style: const TextStyle(
                  color: _textPri,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
          trailing: const Icon(Icons.chevron_right_rounded,
              color: _textSec, size: 18),
          onTap: () {},
        ),
        if (!last)
          Divider(
              height: 1,
              indent: 66,
              endIndent: 16,
              color: _border),
      ],
    );
  }
}