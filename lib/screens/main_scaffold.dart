import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../contexts/auth_provider.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';
import 'orders_screen.dart';
import 'tables_screen.dart';
import 'billing_screen.dart';
import 'profile_screen.dart';

class MainScaffold extends StatefulWidget {
  final int initialTab;
  const MainScaffold({super.key, this.initialTab = 0});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final role = auth.role;
    final user = auth.user;
    final isBilling = role == StaffRole.billingStaff;

    final servingItems = [
      _NavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: 'Home',
        screen: const DashboardScreen(),
      ),
      _NavItem(
        icon: Icons.receipt_long_outlined,
        activeIcon: Icons.receipt_long,
        label: 'Orders',
        screen: const OrdersScreen(),
      ),
      _NavItem(
        icon: Icons.grid_view,
        activeIcon: Icons.grid_view_rounded,
        label: 'Tables',
        screen: const TablesScreen(),
      ),
      _NavItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Profile',
        screen: const ProfileScreen(),
      ),
    ];

    final billingItems = [
      _NavItem(
        icon: Icons.account_balance_wallet_outlined,
        activeIcon: Icons.account_balance_wallet,
        label: 'Billing',
        screen: const BillingScreen(),
      ),
      _NavItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Profile',
        screen: const ProfileScreen(),
      ),
    ];

    final navItems = isBilling ? billingItems : servingItems;
    final safeIndex = _currentIndex < navItems.length ? _currentIndex : 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide =
            constraints.maxWidth >=
            1024; // lg breakpoint in Tailwind is usually 1024px

        if (isWide) {
          return Scaffold(
            backgroundColor: AppColors.ivory,
            body: Row(
              children: [
                // Desktop Sidebar (lg screens)
                _Sidebar(
                  navItems: navItems,
                  currentIndex: safeIndex,
                  onTap: (idx) => setState(() => _currentIndex = idx),
                  roleName: isBilling ? 'Billing Staff' : 'Serving Staff',
                  initials: user?.name.substring(0, 1).toUpperCase() ?? 'S',
                ),
                // Main content
                Expanded(child: navItems[safeIndex].screen),
              ],
            ),
          );
        }

        // Mobile Bottom Navigation
        return Scaffold(
          backgroundColor: AppColors.ivory,
          body: navItems[safeIndex].screen,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              border: const Border(
                top: BorderSide(color: Color(0xFFF1F5F9)),
              ), // ivory-300 equivalent roughly
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              bottom: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: navItems.asMap().entries.map((e) {
                    final idx = e.key;
                    final item = e.value;
                    final isActive = safeIndex == idx;

                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => setState(() => _currentIndex = idx),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.primary.withValues(alpha: 0.1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                isActive ? item.activeIcon : item.icon,
                                color: isActive
                                    ? AppColors.primary
                                    : AppColors.slate400,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.label,
                              style: AppTheme.sans(
                                size: 10,
                                weight: isActive
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                color: isActive
                                    ? AppColors.primary
                                    : AppColors.slate400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Sidebar for wide screens ──────────────────────────────────────────────
class _Sidebar extends StatelessWidget {
  final List<_NavItem> navItems;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final String roleName;
  final String initials;

  const _Sidebar({
    required this.navItems,
    required this.currentIndex,
    required this.onTap,
    required this.roleName,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256, // w-64
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          right: BorderSide(color: Color(0xFFE2E8F0)),
        ), // ivory-300 approx
      ),
      child: Column(
        children: [
          // Brand header (p-6 border-b)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFF1F5F9)),
              ), // ivory-200 approx
            ),
            child: Text(
              'RestaurantOS',
              style: AppTheme.serif(
                size: 24,
                weight: FontWeight.w700,
                color: AppColors.primary,
              ).copyWith(letterSpacing: -0.5),
            ),
          ),

          // Nav items (flex-1 p-4 space-y-2)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: navItems.asMap().entries.map((e) {
                final idx = e.key;
                final item = e.value;
                final isActive = currentIndex == idx;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12), // rounded-xl
                      onTap: () => onTap(idx),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.2,
                                    ),
                                    blurRadius: 15,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isActive ? item.activeIcon : item.icon,
                              color: isActive
                                  ? AppColors.white
                                  : AppColors.slate600,
                              size: 24,
                            ),
                            const SizedBox(width: 16), // gap-4
                            Text(
                              item.label,
                              style: AppTheme.sans(
                                size: 16,
                                weight: isActive
                                    ? FontWeight.w900
                                    : FontWeight
                                          .w500, // font-black vs font-medium
                                color: isActive
                                    ? AppColors.white
                                    : AppColors.slate600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Bottom label (p-6 border-t)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: Row(
              children: [
                // Avatar (w-10 h-10 rounded-full bg-primary/10 text-primary font-bold)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: AppTheme.sans(
                        size: 16,
                        weight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roleName,
                      style: AppTheme.sans(
                        size: 14,
                        weight: FontWeight.w700,
                        color: AppColors.slate900,
                      ),
                    ),
                    Text(
                      'Online',
                      style: AppTheme.sans(size: 12, color: AppColors.slate500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Widget screen;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.screen,
  });
}
