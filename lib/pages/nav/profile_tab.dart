import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_app/core/themes.dart';
import 'package:qr_app/services/auth_services.dart';
import 'package:qr_app/utils/helper.dart';

class ProfileTab extends StatelessWidget {
  ProfileTab({super.key});

  final _authServices = Get.find<AuthServices>();

  @override
  Widget build(BuildContext context) {
    final user = _authServices.user.value!;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 22),

              // ── Avatar + name ──────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.accent.withOpacity(0.10),
                            border: Border.all(
                              color: AppTheme.accent.withOpacity(0.35),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            size: 28,
                            color: AppTheme.accent,
                          ),
                        ),
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppTheme.success,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.surface,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name ?? '',
                            style: GoogleFonts.dmSans(
                              color: AppTheme.textPri,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            user.email ?? '',
                            style: GoogleFonts.dmSans(
                              color: AppTheme.textSec,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Row(
                            children: [
                              _roleBadge(user.role),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.calendar_today_rounded,
                                size: 11,
                                color: AppTheme.textSec,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                Helper.formatDate(user.createdAt!),
                                style: GoogleFonts.dmSans(
                                  color: AppTheme.textSec,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppTheme.surface2,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 15,
                        color: AppTheme.textSec,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Stats ──────────────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  children: [
                    _stat('12', 'QR Codes'),
                    _vDiv(),
                    _stat('248', 'Scans'),
                    _vDiv(),
                    _stat('248', 'Verified'),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // ── General ───────────────────────────────────────────
              _sectionLabel('GENERAL'),
              const SizedBox(height: 10),
              _menuCard([
                _menuItem(
                  Icons.language_rounded,
                  'Language',
                  accent: const Color(0xFF60A5FA),
                ),
                _menuItem(
                  Icons.currency_exchange_rounded,
                  'Currencies',
                  accent: AppTheme.success,
                  last: true,
                ),
              ]),

              const SizedBox(height: 18),

              // ── Security ─────────────────────────────────────────
              _sectionLabel('SECURITY'),
              const SizedBox(height: 10),
              _menuCard([
                _menuItem(
                  Icons.qr_code_scanner_rounded,
                  'Application Security',
                  accent: AppTheme.accent,
                ),
                _menuItem(
                  Icons.devices_rounded,
                  'Manage Devices',
                  accent: const Color(0xFFA78BFA),
                ),
                _menuItem(
                  Icons.lock_outline_rounded,
                  'Change Password',
                  accent: AppTheme.accentAlt,
                  last: true,
                ),
              ]),

              const SizedBox(height: 18),

              // ── Preferences ──────────────────────────────────────
              _sectionLabel('PREFERENCES'),
              const SizedBox(height: 10),
              _menuCard([
                _menuItem(
                  Icons.tune_rounded,
                  'Appearance',
                  accent: AppTheme.info,
                ),
                _menuItem(
                  Icons.description_outlined,
                  'Terms & Conditions',
                  accent: AppTheme.textSec,
                  last: true,
                ),
              ]),

              const SizedBox(height: 24),

              // ── Logout ────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _authServices.logout(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.danger.withOpacity(0.08),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: AppTheme.danger.withOpacity(0.25),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.logout_rounded,
                        color: AppTheme.danger,
                        size: 17,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Log Out',
                        style: GoogleFonts.dmSans(
                          color: AppTheme.danger,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
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

  Widget _roleBadge(String? role) {
    final isAdmin = role == 'admin';
    final color = isAdmin ? AppTheme.accent : AppTheme.success;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Text(
        role?.toUpperCase() ?? '',
        style: GoogleFonts.dmSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.dmSans(
                color: AppTheme.accent,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.dmSans(color: AppTheme.textSec, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vDiv() => Container(width: 1, height: 36, color: AppTheme.border);

  Widget _sectionLabel(String title) => Text(
    title,
    style: GoogleFonts.dmSans(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      color: AppTheme.textSec,
      letterSpacing: 1.5,
    ),
  );

  Widget _menuCard(List<Widget> items) => Container(
    decoration: BoxDecoration(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppTheme.border),
    ),
    child: Column(children: items),
  );

  Widget _menuItem(
    IconData icon,
    String label, {
    bool last = false,
    Color accent = AppTheme.textSec,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 2,
          ),
          dense: true,
          leading: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.10),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 16, color: accent),
          ),
          title: Text(
            label,
            style: GoogleFonts.dmSans(
              color: AppTheme.textPri,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
            color: AppTheme.textSec,
            size: 18,
          ),
          onTap: () {},
        ),
        if (!last)
          const Divider(
            height: 1,
            indent: 64,
            endIndent: 16,
            color: AppTheme.border,
          ),
      ],
    );
  }
}
