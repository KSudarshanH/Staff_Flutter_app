import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../contexts/auth_provider.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final role = auth.role;

    final roleLabel = role == StaffRole.billingStaff
        ? 'Billing Staff'
        : 'Serving Staff';

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: Column(
        children: [
          // Profile header
          Container(
            color: AppColors.primary,
            child: Stack(
              children: [
                Positioned(
                  top: -40,
                  right: -40,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
                    child: Row(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 3,
                            ),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.name ?? 'Staff Member',
                                style: AppTheme.serif(
                                  size: 24,
                                  weight: FontWeight.w900,
                                  color: AppColors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    roleLabel.toUpperCase(),
                                    style: AppTheme.sans(
                                      size: 11,
                                      weight: FontWeight.w600,
                                      color: AppColors.gold,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.15,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'ACTIVE NOW',
                                      style: AppTheme.sans(
                                        size: 10,
                                        weight: FontWeight.w700,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Details',
                          style: AppTheme.serif(
                            size: 18,
                            weight: FontWeight.w700,
                            color: AppColors.slate900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Divider(),
                        const SizedBox(height: 12),
                        _ProfileRow(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: user?.email ?? 'N/A',
                        ),
                        const SizedBox(height: 16),
                        _ProfileRow(
                          icon: Icons.work_outline,
                          label: 'Role',
                          value: roleLabel,
                        ),
                        const SizedBox(height: 16),
                        _ProfileRow(
                          icon: Icons.restaurant_outlined,
                          label: 'Restaurant',
                          value: user?.restaurantName ?? 'RestaurantOS',
                        ),
                        const SizedBox(height: 16),
                        if (user?.phone != null) ...[
                          _ProfileRow(
                            icon: Icons.phone_outlined,
                            label: 'Phone',
                            value: user!.phone!,
                          ),
                          const SizedBox(height: 16),
                        ],
                        _ProfileRow(
                          icon: Icons.calendar_today_outlined,
                          label: 'Joined On',
                          value: _formatDate(user?.createdAt),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Quick links
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Access',
                          style: AppTheme.serif(
                            size: 18,
                            weight: FontWeight.w700,
                            color: AppColors.slate900,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (role == StaffRole.servingStaff) ...[
                          _QuickLink(
                            icon: Icons.receipt_long_outlined,
                            label: 'View Active Orders',
                            onTap: () =>
                                Navigator.pushNamed(context, '/orders'),
                          ),
                          const Divider(height: 20),
                          _QuickLink(
                            icon: Icons.table_restaurant_outlined,
                            label: 'Floor Plan',
                            onTap: () =>
                                Navigator.pushNamed(context, '/tables'),
                          ),
                        ] else ...[
                          _QuickLink(
                            icon: Icons.account_balance_wallet_outlined,
                            label: 'Billing & Payments',
                            onTap: () =>
                                Navigator.pushNamed(context, '/billing'),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // App info + logout
                  AppCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'RestaurantOS',
                              style: AppTheme.sans(
                                size: 14,
                                weight: FontWeight.w700,
                                color: AppColors.slate900,
                              ),
                            ),
                            Text(
                              'Staff App v1.0.0',
                              style: AppTheme.sans(
                                size: 12,
                                color: AppColors.slate400,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            auth.logout();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (route) => false,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.dangerLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.danger.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.logout,
                                  color: AppColors.danger,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Sign Out',
                                  style: AppTheme.sans(
                                    size: 14,
                                    weight: FontWeight.w700,
                                    color: AppColors.danger,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate([DateTime? date]) {
    final now = date ?? DateTime.now();
    return '${now.day} ${_month(now.month)} ${now.year}';
  }

  String _month(int m) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[m - 1];
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.slate400, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: AppTheme.sans(
                size: 10,
                weight: FontWeight.w700,
                color: AppColors.slate400,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: AppTheme.sans(
                size: 15,
                weight: FontWeight.w600,
                color: AppColors.slate900,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickLink({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.slate50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: AppTheme.sans(
                size: 14,
                weight: FontWeight.w600,
                color: AppColors.slate900,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.slate400),
        ],
      ),
    );
  }
}
