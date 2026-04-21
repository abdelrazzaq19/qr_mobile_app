import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_app/controllers/nav_controller.dart';
import 'package:qr_app/core/themes.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final _navController = Get.put(NavController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Obx(
        () => IndexedStack(
          index: _navController.currentIndex.value,
          children: _navController.navItems.map((e) => e.screen).toList(),
        ),
      ),
      bottomNavigationBar: Obx(
        () => _BottomNav(
          items: _navController.navItems
              .map((e) => _NavItem(icon: e.icon, label: e.label))
              .toList(),
          currentIndex: _navController.currentIndex.value,
          onTap: _navController.changeTab,
        ),
      ),
    );
  }
}

class _NavItem {
  final Widget icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class _BottomNav extends StatelessWidget {
  final List<_NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(items.length, (i) {
              final selected = i == currentIndex;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppTheme.accent.withOpacity(0.12)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: IconTheme(
                            data: IconThemeData(
                              color: selected
                                  ? AppTheme.accent
                                  : AppTheme.textSec,
                              size: 20,
                            ),
                            child: items[i].icon,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          items[i].label,
                          style: GoogleFonts.dmSans(
                            fontSize: 10,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: selected
                                ? AppTheme.accent
                                : AppTheme.textSec,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
