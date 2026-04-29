import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../contexts/orders_provider.dart';
import '../contexts/auth_provider.dart';
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
  bool _isProcessing = false;

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

    final finalTotal = order.total.round();

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: Column(
        children: [
          // HEADER
          Container(
            color: AppColors.primary,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Process Payment',
                          style: AppTheme.serif(
                            size: 22,
                            weight: FontWeight.w900,
                            color: Colors.white,
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

          // BODY
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 🔥 TOTAL CARD (CENTERED - FIXED)
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Total Amount',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '₹$finalTotal',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),

                        _AmountRow('Subtotal', '₹${order.subtotal.round()}'),
                        _AmountRow('Tax', '₹${order.tax.round()}'),

                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),

                        _AmountRow(
                          'Total',
                          '₹$finalTotal',
                          bold: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔥 PAYMENT METHOD TITLE ADDED
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Payment Method",
                      style: AppTheme.sans(
                        size: 16,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 🔥 PAYMENT METHODS (GOOD UI PRESERVED)
                  AppCard(
                    child: Column(
                      children: _methods.map((m) {
                        final isSelected = _selectedMethod == m['id'];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedMethod = m['id'] as String;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.red.shade50
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.red
                                    : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  m['icon'] as IconData,
                                  color: isSelected
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    m['label'] as String,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check_circle,
                                      color: Colors.red),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔥 BUTTON (NO ERROR)
                  PrimaryButton(
                    label: _isProcessing
                        ? "Processing..."
                        : 'Confirm Payment · ₹$finalTotal',
                    onTap: (_selectedMethod == null || _isProcessing)
                        ? null
                        : () async {
                            await _handlePayment(
                                context, provider, finalTotal);
                          },
                  ),

                  const SizedBox(height: 10),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 CLEAN HANDLER
  Future<void> _handlePayment(
      BuildContext context,
      OrdersProvider provider,
      int finalTotal) async {
    setState(() => _isProcessing = true);

    final token = context.read<AuthProvider>().token;

    if (token == null) {
      setState(() => _isProcessing = false);
      return;
    }

    try {
      await provider.payOrder(widget.orderId, token);

      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        '/bill',
        arguments: {
          'orderId': widget.orderId,
          'tipAmount': 0,
          'finalTotal': finalTotal,
          'paymentMethod': _selectedMethod,
        },
      );
    } catch (e) {
      print("Payment error: $e");
    }

    if (mounted) {
      setState(() => _isProcessing = false);
    }
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
        Text(label),
        Text(
          value,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}