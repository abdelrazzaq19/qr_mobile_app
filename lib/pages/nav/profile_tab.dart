import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_app/services/auth_services.dart';
import 'package:qr_app/utils/helper.dart';

class ProfileTab extends StatelessWidget {
  ProfileTab({super.key});

  final _authServices = Get.find<AuthServices>();

  @override
  Widget build(BuildContext context) {
    final user = _authServices.user.value!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F4F0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── TOP BAR ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.black.withOpacity(0.08),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              // ── PROFILE CARD ─────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.black.withOpacity(0.06)),
                  ),
                  child: Column(
                    children: [
                      // QR Code mini + avatar
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // QR background decoration
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFF97316),
                                width: 2.5,
                              ),
                            ),
                          ),
                          // Corner QR dots
                          Positioned(top: 4, left: 4, child: _qrCornerDot()),
                          Positioned(top: 4, right: 4, child: _qrCornerDot()),
                          Positioned(bottom: 4, left: 4, child: _qrCornerDot()),
                          // Avatar
                          CircleAvatar(
                            radius: 38,
                            backgroundColor: const Color(0xFFF0EFEB),
                            child: const Icon(
                              Icons.person_rounded,
                              size: 38,
                              color: Color(0xFF888780),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Name
                      Text(
                        user.name ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                          letterSpacing: -0.2,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Email
                      Text(
                        user.email ?? '',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF888780),
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Role + join date row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: user.role == 'admin'
                                  ? const Color(0xFFFEECE7)
                                  : const Color(0xFFEAF3DE),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              user.role?.toUpperCase() ?? '',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: user.role == 'admin'
                                    ? const Color(0xFF993C1D)
                                    : const Color(0xFF3B6D11),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.circle,
                            size: 4,
                            color: Color(0xFFB4B2A9),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                size: 12,
                                color: Color(0xFF888780),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                Helper.formatDate(user.createdAt!),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF888780),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // Edit Profile button
                      SizedBox(
                        width: 160,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.edit_rounded,
                            size: 15,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Edit Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF97316),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── MENU: GENERAL ────────────────────────────────
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

              // ── MENU: SECURITY ───────────────────────────────
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

              // ── MENU: PREFERENCES ────────────────────────────
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

              // ── LOGOUT ───────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _authServices.logout(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFCEBEB),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(
                          color: Color(0xFFF09595),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Log Out',
                      style: TextStyle(
                        color: Color(0xFFA32D2D),
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ── QR corner dot decoration ────────────────────────────────
  Widget _qrCornerDot() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: const Color(0xFFF97316),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  // ── Section label ────────────────────────────────────────────
  Widget _sectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF888780),
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  // ── Menu card wrapper ────────────────────────────────────────
  Widget _menuCard(List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black.withOpacity(0.06)),
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
              color: const Color(0xFFF5F4F0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF444441)),
          ),
          title: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A1A),
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFFB4B2A9),
            size: 20,
          ),
          onTap: () {},
        ),
        if (divider)
          Divider(
            height: 1,
            indent: 68,
            endIndent: 16,
            color: Colors.black.withOpacity(0.06),
          ),
      ],
    );
  }
}
