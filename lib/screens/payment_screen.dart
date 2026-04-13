import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../contexts/orders_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class PaymentScreen extends StatefulWidget {
  final String orderId;

  const PaymentScreen({super.key, required this.orderId});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedMethod;
  int _tipPercent = 0;

  final _methods = [
    {'id': 'cash', 'label': 'Cash', 'icon': Icons.payments_outlined},
    {'id': 'upi', 'label': 'UPI', 'icon': Icons.phone_android_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrdersProvider>();
    final order = provider.findById(widget.orderId);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Payment')),
        body: const Center(child: Text('Order not found')),
      );
    }

    final tipAmount = (order.subtotal * _tipPercent / 100).round();
    final finalTotal = order.total.round() + tipAmount;

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: Column(
        children: [
          Container(
            color: AppColors.primary,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Process Payment',
                          style: AppTheme.serif(
                            size: 22,
                            weight: FontWeight.w900,
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          order.table,
                          style: AppTheme.sans(size: 13, color: AppColors.gold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Amount card
                  AppCard(
                    child: Column(
                      children: [
                        Text(
                          'Total Amount',
                          style: AppTheme.sans(
                            size: 13,
                            color: AppColors.slate500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹$finalTotal',
                          style: AppTheme.serif(
                            size: 48,
                            weight: FontWeight.w900,
                            color: AppColors.slate900,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(height: 1, color: AppColors.slate200),
                        const SizedBox(height: 16),
                        _AmountRow('Subtotal', '₹${order.subtotal.round()}'),
                        const SizedBox(height: 6),
                        _AmountRow('Tax', '₹${order.tax.round()}'),
                        const SizedBox(height: 6),
                        _AmountRow('Tip', '₹$tipAmount'),
                        const SizedBox(height: 10),
                        _AmountRow('Total', '₹$finalTotal', bold: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tip selection
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Tip',
                          style: AppTheme.serif(
                            size: 18,
                            weight: FontWeight.w700,
                            color: AppColors.slate900,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [0, 5, 10, 15, 20].map((pct) {
                            final isSelected = _tipPercent == pct;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _tipPercent = pct),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.slate50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.slate200,
                                    ),
                                  ),
                                  child: Text(
                                    pct == 0 ? 'No tip' : '$pct%',
                                    textAlign: TextAlign.center,
                                    style: AppTheme.sans(
                                      size: 12,
                                      weight: FontWeight.w700,
                                      color: isSelected
                                          ? AppColors.white
                                          : AppColors.slate600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Payment method
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Method',
                          style: AppTheme.serif(
                            size: 18,
                            weight: FontWeight.w700,
                            color: AppColors.slate900,
                          ),
                        ),
                        const SizedBox(height: 14),
                        ..._methods.map((m) {
                          final isSelected = _selectedMethod == m['id'];
                          return GestureDetector(
                            onTap: () => setState(
                              () => _selectedMethod = m['id'] as String,
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withValues(alpha: 0.06)
                                    : AppColors.slate50,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.slate200,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    m['icon'] as IconData,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.slate400,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 14),
                                  Text(
                                    m['label'] as String,
                                    style: AppTheme.sans(
                                      size: 15,
                                      weight: FontWeight.w700,
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.slate700,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  PrimaryButton(
                    label: 'Confirm Payment · ₹$finalTotal',
                    color: AppColors.primary,
                    onTap: _selectedMethod == null
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select payment method'),
                              ),
                            );
                          }
                        : () {
                            provider.payOrder(widget.orderId);
                            Navigator.pushReplacementNamed(
                              context,
                              '/bill',
                              arguments: {
                                'orderId': widget.orderId,
                                'tipAmount': tipAmount,
                                'finalTotal': finalTotal,
                                'paymentMethod': _selectedMethod,
                              },
                            );
                          },
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.slate200),
                      ),
                      child: Text(
                        'Cancel',
                        textAlign: TextAlign.center,
                        style: AppTheme.sans(
                          size: 15,
                          weight: FontWeight.w700,
                          color: AppColors.slate700,
                        ),
                      ),
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
}

class _AmountRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _AmountRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.sans(
            size: bold ? 15 : 13,
            weight: bold ? FontWeight.w800 : FontWeight.normal,
            color: bold ? AppColors.slate900 : AppColors.slate500,
          ),
        ),
        Text(
          value,
          style: AppTheme.sans(
            size: bold ? 16 : 14,
            weight: FontWeight.w700,
            color: bold ? AppColors.primary : AppColors.slate900,
          ),
        ),
      ],
    );
  }
}
