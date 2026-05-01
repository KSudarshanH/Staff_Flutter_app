import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../contexts/orders_provider.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersProvider = context.watch<OrdersProvider>();
    final recentOrders = ordersProvider.activeOrders.take(4).toList();
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: Column(
        children: [
          const PageHeader(
            title: 'Staff Dashboard',
            subtitle: 'Oversee Your Fine Dining Operations',
            isCentered: true,
          ),
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 24,
                vertical: isMobile ? 24 : 32,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1200,
                  ), // max-w-7xl
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Feature Grid (grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 mb-16)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          int crossAxisCount = 1;
                          if (width >= 1024) {
                            crossAxisCount = 4;
                          } else if (width >= 768) {
                            crossAxisCount = 2;
                          }

                          return GridView.count(
                            crossAxisCount: crossAxisCount,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 32,
                            mainAxisSpacing: 32,
                            childAspectRatio: 0.78, // Further increased height
                            children: [
                              _FeatureCard(
                                icon: Icons.add_shopping_cart,
                                iconColor: const Color(0xFF7B1F1F),
                                iconBg: const Color(0xFFFEF2F2),
                                title: 'Create Order',
                                onTap: () =>
                                    Navigator.pushNamed(context, '/create-order'),
                              ),
                              _FeatureCard(
                                icon: Icons.notifications_active_outlined,
                                iconColor: const Color(0xFFD97706),
                                iconBg: const Color(0xFFFFFBEB),
                                title: 'Requests',
                                onTap: () =>
                                    Navigator.pushNamed(context, '/new-orders'),
                              ),
                              _FeatureCard(
                                icon: Icons.receipt_long_outlined,
                                iconColor: const Color(0xFF0D9488),
                                iconBg: const Color(0xFFF0FDFA),
                                title: 'Active Orders',
                                onTap: () =>
                                    Navigator.pushNamed(context, '/orders'),
                              ),
                              _FeatureCard(
                                icon: Icons.grid_view_rounded,
                                iconColor: const Color(0xFF475569),
                                iconBg: const Color(0xFFF8FAFC),
                                title: 'Tables',
                                onTap: () =>
                                    Navigator.pushNamed(context, '/tables'),
                              ),
                            ].animate(interval: 100.ms).fade(duration: 400.ms).slideY(begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOutQuad),
                          );
                        },
                      ),
                      const SizedBox(height: 64), // mb-16
                      // Active Orders Section
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(
                            40,
                          ), // md:rounded-[40px]
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(isMobile ? 24 : 48), // md:p-12
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final isWide = constraints.maxWidth >= 600;
                                final headerContent = [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Active Orders',
                                        style: AppTheme.serif(
                                          size: 30, // text-3xl
                                          weight: FontWeight.w700,
                                          color: AppColors.slate900,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Real-time supervision of current dining service.',
                                        style: AppTheme.sans(
                                          size: 16,
                                          color: AppColors.slate500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (!isWide) const SizedBox(height: 16),
                                  PrimaryButton(
                                    label: 'View All Orders',
                                    onTap: () =>
                                        Navigator.pushNamed(context, '/orders'),
                                  ),
                                ];

                                if (isWide) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: headerContent,
                                  );
                                }
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: headerContent,
                                );
                              },
                            ),
                            const SizedBox(height: 32), // mb-8

                            if (recentOrders.isEmpty)
                              const EmptyState(
                                icon: Icons.receipt_long_outlined,
                                title: 'No active orders',
                              )
                            else
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  int cols = 1;
                                  if (constraints.maxWidth >= 1024) {
                                    cols = 3;
                                  } else if (constraints.maxWidth >= 768) {
                                    cols = 2;
                                  }

                                  return GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: cols,
                                          mainAxisSpacing: 24,
                                          crossAxisSpacing: 24,
                                          childAspectRatio: 1.35,
                                        ),
                                    itemCount: recentOrders.length,
                                    itemBuilder: (ctx, i) =>
                                        _MiniOrderCard(order: recentOrders[i]),
                                  );
                                },
                              ),
                          ],
                        ),
                      ).animate().fade(duration: 500.ms).slideY(begin: 0.1, duration: 500.ms, curve: Curves.easeOutQuad),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Feature Card (Dashboard) ──────────────────────────────────────────────
class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(32), // rounded-[32px] p-8
          border: Border.all(color: AppColors.slate100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // w-24 h-24 mb-6
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 40),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: AppTheme.serif(
                size: 24, // text-2xl
                weight: FontWeight.w700,
                color: AppColors.slate900,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 200.ms, curve: Curves.easeOut);
  }
}

// ─── Mini Order Card (Dashboard) ───────────────────────────────────────────
class _MiniOrderCard extends StatelessWidget {
  final Order order;
  const _MiniOrderCard({required this.order});

  Map<String, dynamic> _getStatusConfig(OrderStatus status) {
    switch (status) {
      case OrderStatus.confirmed:
        return {
          'label': 'PENDING',
          'bg': const Color(0xFFFEF3C7),
          'color': const Color(0xFFD97706),
        };
      case OrderStatus.preparing:
        return {
          'label': 'PREPARING',
          'bg': const Color(0xFFDBEAFE),
          'color': const Color(0xFF2563EB),
        };
      case OrderStatus.ready:
        return {
          'label': 'READY',
          'bg': const Color(0xFFD1FAE5),
          'color': const Color(0xFF059669),
        };
      default:
        return {
          'label': 'SERVED',
          'bg': const Color(0xFFF1F5F9),
          'color': const Color(0xFF64748B),
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(order.status);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
  context,
  '/order-details',
  arguments: order.id, // ✅ VERY IMPORTANT
),
      child: Container(
        padding: const EdgeInsets.all(20), // p-5
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16), // rounded-2xl
          border: Border.all(color: AppColors.slate100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      // w-12 h-12 rounded-xl bg-slate-50
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.slate50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.restaurant,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.table,
                              style: AppTheme.sans(
                                size: 18, // text-lg
                                weight: FontWeight.w700,
                                color: AppColors.slate900,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'OrderId: #${order.id.substring(0, 4)}',
                              style: AppTheme.sans(
                                size: 12,
                                color: AppColors.slate400,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: config['bg'] as Color,
                    borderRadius: BorderRadius.circular(20),
                    border: config['bg'] == const Color(0xFFF1F5F9)
                        ? Border.all(color: AppColors.slate200)
                        : Border.all(color: Colors.transparent),
                  ),
                  child: Text(
                    config['label'] as String,
                    style: AppTheme.sans(
                      size: 12,
                      weight: FontWeight.w700,
                      color: config['color'] as Color,
                    ).copyWith(letterSpacing: 0.5),
                  ),
                ),
              ],
            ),

            // Bottom row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${order.items} Items',
                      style: AppTheme.sans(
                        size: 14,
                        weight: FontWeight.w500,
                        color: AppColors.slate500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 12,
                          color: AppColors.slate400,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          order.time,
                          style: AppTheme.sans(
                            size: 12,
                            color: AppColors.slate400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '₹${order.total.round()}',
                  style: AppTheme.sans(
                    size: 20, // text-xl font-black
                    weight: FontWeight.w900,
                    color: AppColors.slate900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
