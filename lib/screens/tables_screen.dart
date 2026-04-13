import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../contexts/auth_provider.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class TablesScreen extends StatefulWidget {
  const TablesScreen({super.key});

  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  String _activeFilter = 'all';

  Map<String, dynamic> _getStatusConfig(TableModel table) {
    if (table.status == TableStatus.needsBill) {
      return {
        'bg': const Color(0xFFFFFBEB), // warning-light roughly
        'text': const Color(0xFFD97706),
        'label': 'Needs Bill',
        'icon': Icons.receipt_long,
        'gradient': const [Color(0xFFF59E0B), Color(0xFFD97706)],
      };
    } else if (table.status == TableStatus.occupied) {
      return {
        'bg': const Color(0xFFEFF6FF), // info-light
        'text': const Color(0xFF2563EB),
        'label': 'Occupied',
        'icon': Icons.people,
        'gradient': const [Color(0xFF3B82F6), Color(0xFF2563EB)],
      };
    } else {
      return {
        'bg': const Color(0xFFF0FDF4), // success-light
        'text': const Color(0xFF16A34A),
        'label': 'Available',
        'icon': Icons.check_circle_outline,
        'gradient': const [
          Color(0xFFC8A951),
          Color(0xFFB8993D),
        ], // Next.js uses gold for available
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    // Generate dummy tables matching Next.js logic
    final List<TableModel> allTables = List.generate(12, (index) {
      final name = 'Table ${index + 1}';
      if (index % 5 == 0) {
        return TableModel(
          id: 't$index',
          name: name,
          status: TableStatus.needsBill,
          seats: 4,
        );
      } else if (index % 3 == 0) {
        return TableModel(
          id: 't$index',
          name: name,
          status: TableStatus.occupied,
          seats: 4,
        );
      } else {
        return TableModel(
          id: 't$index',
          name: name,
          status: TableStatus.available,
          seats: 4,
        );
      }
    });

    final filters = [
      {'id': 'all', 'label': 'All', 'count': allTables.length},
      {
        'id': 'available',
        'label': 'Available',
        'count': allTables
            .where((t) => t.status == TableStatus.available)
            .length,
      },
      {
        'id': 'occupied',
        'label': 'Occupied',
        'count': allTables
            .where((t) => t.status == TableStatus.occupied)
            .length,
      },
      {
        'id': 'needs-bill',
        'label': 'Needs Bill',
        'count': allTables
            .where((t) => t.status == TableStatus.needsBill)
            .length,
      },
    ];

    List<TableModel> filteredTables;
    if (_activeFilter == 'all') {
      filteredTables = allTables;
    } else if (_activeFilter == 'available') {
      filteredTables = allTables
          .where((t) => t.status == TableStatus.available)
          .toList();
    } else if (_activeFilter == 'occupied') {
      filteredTables = allTables
          .where((t) => t.status == TableStatus.occupied)
          .toList();
    } else {
      filteredTables = allTables
          .where((t) => t.status == TableStatus.needsBill)
          .toList();
    }

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: Column(
        children: [
          const PageHeader(
            title: 'Floor Plan',
            subtitle: 'Real-time Table Status',
          ),

          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 768;

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

                Widget content = filteredTables.isEmpty
                    ? const EmptyState(
                        icon: Icons.grid_view,
                        title: 'No tables found',
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isWide
                              ? (constraints.maxWidth >= 1024 ? 3 : 2)
                              : 1,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          childAspectRatio:
                              2.5, // Matches the horizontal layout
                        ),
                        itemCount: filteredTables.length,
                        itemBuilder: (context, index) {
                          final table = filteredTables[index];
                          final config = _getStatusConfig(table);
                          return _TableCard(table: table, config: config);
                        },
                      );

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1280),
                      child: isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Sidebar Filter
                                Container(
                                  width: 256,
                                  margin: const EdgeInsets.only(right: 32),
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: const Color(0xFFF1F5F9),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'VIEW OPTIONS',
                                        style: AppTheme.sans(
                                          size: 12,
                                          weight: FontWeight.w700,
                                          color: AppColors.slate400,
                                        ).copyWith(letterSpacing: 1.0),
                                      ),
                                      const SizedBox(height: 16),
                                      filterList,
                                    ],
                                  ),
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
    );
  }
}

class _TableCard extends StatelessWidget {
  final TableModel table;
  final Map<String, dynamic> config;

  const _TableCard({required this.table, required this.config});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isServing = auth.role == StaffRole.servingStaff;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/order-details'),
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
        child: Row(
          children: [
            // Left Gradient Strip (w-1.5)
            Container(
              width: 6,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: config['gradient'] as List<Color>,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              config['icon'] as IconData,
                              size: 24,
                              color: config['text'] as Color,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  table.name,
                                  style: AppTheme.sans(
                                    size: 18,
                                    weight: FontWeight.w700,
                                    color: AppColors.slate900,
                                  ),
                                ),
                                // (If you had seats/server, it would go here)
                              ],
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: config['bg'] as Color,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                config['label'] as String,
                                style: AppTheme.sans(
                                  size: 12,
                                  weight: FontWeight.w700,
                                  color: config['text'] as Color,
                                ),
                              ),
                            ),
                            if (table.status == TableStatus.needsBill) ...[
                              const SizedBox(height: 8),
                              Text(
                                '₹2450',
                                style: AppTheme.sans(
                                  size: 16,
                                  weight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),

                    // Actions bottom row
                    if ((table.status == TableStatus.occupied ||
                            table.status == TableStatus.needsBill) &&
                        !isServing)
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.only(top: 16),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xFFF1F5F9)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: PrimaryButton(
                                label: 'Bill',
                                color: const Color(0xFFDCFCE7), // success/10
                                textColor: const Color(0xFFC8A951),
                                onTap: () =>
                                    Navigator.pushNamed(context, '/billing'),
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
      ),
    );
  }
}
