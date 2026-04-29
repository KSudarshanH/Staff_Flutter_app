import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../contexts/orders_provider.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../contexts/auth_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _activeFilter = 'all';

  Map<String, dynamic> _getStatusConfig(OrderStatus status) {
    switch (status) {
      case OrderStatus.confirmed:
        return {
          'label': 'CONFIRMED',
          'bg': const Color(0xFFFEF3C7),
          'color': const Color(0xFFD97706),
          'icon': Icons.access_time,
        };
      case OrderStatus.preparing:
        return {
          'label': 'PREPARING',
          'bg': const Color(0xFFDBEAFE),
          'color': const Color(0xFF2563EB),
          'icon': Icons.local_fire_department,
        };
      case OrderStatus.ready:
        return {
          'label': 'READY TO SERVE',
          'bg': const Color(0xFFD1FAE5),
          'color': const Color(0xFF059669),
          'icon': Icons.check_circle_outline,
        };
      default:
        return {
          'label': 'SERVED',
          'bg': const Color(0xFFF1F5F9),
          'color': const Color(0xFF64748B),
          'icon': Icons.done_all,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = context.watch<OrdersProvider>();
    final allOrders = ordersProvider.orders
        .where(
          (o) =>
  o.status == OrderStatus.placed ||
  o.status == OrderStatus.confirmed ||
  o.status == OrderStatus.preparing ||
  o.status == OrderStatus.ready ||
  o.status == OrderStatus.served
        )
        .toList();

    final filters = [
      {'id': 'all', 'label': 'All', 'count': allOrders.length},
      {
        'id': 'CONFIRMED',
        'label': 'Confirmed',
        'count': allOrders
            .where((o) => o.status == OrderStatus.confirmed)
            .length,
      },
      {
        'id': 'PREPARING',
        'label': 'Preparing',
        'count': allOrders
            .where((o) => o.status == OrderStatus.preparing)
            .length,
      },
      {
        'id': 'READY',
        'label': 'Ready',
        'count': allOrders.where((o) => o.status == OrderStatus.ready).length,
      },
      {
        'id': 'SERVED',
        'label': 'Served',
        'count': ordersProvider.orders
            .where((o) => o.status == OrderStatus.served)
            .length,
      },
    ];

    List<Order> filteredOrders;
    if (_activeFilter == 'all') {
      filteredOrders = allOrders;
    } else {
      final statusMap = {
        'CONFIRMED': OrderStatus.confirmed,
        'PREPARING': OrderStatus.preparing,
        'READY': OrderStatus.ready,
        'SERVED': OrderStatus.served,
      };
      final targetStatus = statusMap[_activeFilter];
      filteredOrders = ordersProvider.orders
          .where((o) => o.status == targetStatus)
          .toList();
    }

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: Column(
        children: [
          PageHeader(
            title: 'Active Orders',
            subtitle: 'Manage Real-time Dining Service',
            actions: [
              PrimaryButton(
                label: 'New Order',
                onTap: () => Navigator.pushNamed(context, '/new-orders'),
                color: AppColors.gold,
                textColor: AppColors.white,
              ),
            ],
          ),

          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 768; // md breakpoint

                Widget filterList = isWide
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: filters
                            .map((f) => _buildFilterButton(f, isWide))
                            .toList(),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: filters
                              .map(
                                (f) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: _buildFilterButton(f, isWide),
                                ),
                              )
                              .toList(),
                        ),
                      );

                Widget content = filteredOrders.isEmpty
                    ? const EmptyState(
                        icon: Icons.receipt_long,
                        title: 'No orders found',
                        subtitle: 'Try a different filter',
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isWide
                              ? (constraints.maxWidth >= 1024 ? 3 : 2)
                              : 1, // lg: 3, md: 2, default: 1
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          childAspectRatio: 1.5, // Approx height for order card
                        ),
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) {
                          final order = filteredOrders[index];
                          final config = _getStatusConfig(order.status);
                          return _OrderCard(order: order, config: config)
                              .animate()
                              .fade(duration: 400.ms, delay: (index * 50).ms)
                              .slideY(begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOutQuad);
                        },
                      );

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 1280,
                      ), // max-w-7xl
                      child: isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Sidebar Filter
                                Container(
                                  width: 256, // w-64
                                  margin: const EdgeInsets.only(
                                    right: 32,
                                  ), // gap-8
                                  padding: const EdgeInsets.all(24), // p-6
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(
                                      24,
                                    ), // rounded-3xl
                                    border: Border.all(
                                      color: const Color(0xFFF1F5F9),
                                    ), // ivory-200
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'FILTER STATUS',
                                        style: AppTheme.sans(
                                          size: 12,
                                          weight: FontWeight.w700,
                                          color: AppColors.slate400,
                                        ).copyWith(letterSpacing: 1.0),
                                      ),
                                      const SizedBox(height: 16),
                                      filterList,
                                    ],
                                  ).animate().fade().slideX(begin: -0.1, duration: 400.ms, curve: Curves.easeOutQuad),
                                ),
                                // Grid
                                Expanded(child: content),
                              ],
                            )
                          : Column(
                              children: [
                                filterList,
                                const SizedBox(height: 24),
                                content,
                              ],
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(Map<String, dynamic> f, bool isWide) {
    final isActive = _activeFilter == f['id'];
    return Padding(
      padding: isWide ? const EdgeInsets.only(bottom: 8) : EdgeInsets.zero,
      child: InkWell(
        onTap: () => setState(() => _activeFilter = f['id'] as String),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                f['label'] as String,
                style: AppTheme.sans(
                  size: 14,
                  weight: FontWeight.w700,
                  color: isActive ? AppColors.white : AppColors.slate900,
                ),
              ),
              if (isWide) const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.white.withValues(alpha: 0.2)
                      : AppColors.ivory,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${f['count']}',
                  style: AppTheme.sans(
                    size: 12,
                    weight: FontWeight.w700,
                    color: isActive ? AppColors.white : AppColors.slate500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fade(duration: 300.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), curve: Curves.easeOutBack);
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  final Map<String, dynamic> config;

  const _OrderCard({required this.order, required this.config});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/order-details', arguments: order.id),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.slate100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Status Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: config['bg'] as Color,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          config['icon'] as IconData,
                          size: 28,
                          color: config['color'] as Color,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                config['label'] as String,
                                style: AppTheme.sans(
                                  size: 18,
                                  weight: FontWeight.w900,
                                  color: config['color'] as Color,
                                ).copyWith(letterSpacing: 0.5),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                order.time,
                                style: AppTheme.sans(
                                  size: 14,
                                  color: (config['color'] as Color).withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 24,
                    color: config['color'] as Color,
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.restaurant,
                            size: 32,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.table,
                                  style: AppTheme.sans(
                                    size: 20,
                                    weight: FontWeight.w700,
                                    color: AppColors.slate900,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${order.items} items',
                                  style: AppTheme.sans(
                                    size: 14,
                                    color: AppColors.slate500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₹${order.total.round()}',
                      style: AppTheme.sans(
                        size: 24,
                        weight: FontWeight.w900,
                        color: AppColors.slate900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
