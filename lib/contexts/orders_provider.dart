import 'package:flutter/material.dart';
import '../models/models.dart';

class OrdersProvider extends ChangeNotifier {
  final bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<Order> _orders = [
    Order(
      id: 'ord_001',
      orderNumber: 'ORD-0001',
      table: 'Table 1',
      customerName: 'Rahul Sharma',
      items: 3,
      total: 850,
      subtotal: 810,
      tax: 40,
      status: OrderStatus.placed,
      time: '7:30 PM',
      createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      itemsPreview: ['2x Butter Chicken', '1x Dal Makhani', '3x Naan'],
      itemsDetails: [
        OrderItem(name: 'Butter Chicken', quantity: 2, price: '280'),
        OrderItem(name: 'Dal Makhani', quantity: 1, price: '180'),
        OrderItem(name: 'Naan', quantity: 3, price: '30'),
      ],
    ),
    Order(
      id: 'ord_002',
      orderNumber: 'ORD-0002',
      table: 'Table 3',
      customerName: 'Priya Mehta',
      items: 4,
      total: 1240,
      subtotal: 1181,
      tax: 59,
      status: OrderStatus.preparing,
      time: '7:15 PM',
      createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
      itemsPreview: ['1x Paneer Tikka', '2x Biryani', '2x Lassi', '1x Gulab Jamun'],
      itemsDetails: [
        OrderItem(name: 'Paneer Tikka', quantity: 1, price: '320'),
        OrderItem(name: 'Biryani', quantity: 2, price: '350'),
        OrderItem(name: 'Lassi', quantity: 2, price: '80'),
        OrderItem(name: 'Gulab Jamun', quantity: 1, price: '60'),
      ],
    ),
    Order(
      id: 'ord_003',
      orderNumber: 'ORD-0003',
      table: 'Table 5',
      customerName: 'Arjun Patel',
      items: 2,
      total: 560,
      subtotal: 533,
      tax: 27,
      status: OrderStatus.ready,
      time: '7:00 PM',
      createdAt: DateTime.now().subtract(const Duration(minutes: 40)),
      itemsPreview: ['1x Fish Curry', '2x Rice'],
      itemsDetails: [
        OrderItem(name: 'Fish Curry', quantity: 1, price: '380'),
        OrderItem(name: 'Rice', quantity: 2, price: '60'),
      ],
    ),
    Order(
      id: 'ord_004',
      orderNumber: 'ORD-0004',
      table: 'Table 2',
      items: 5,
      total: 1890,
      subtotal: 1800,
      tax: 90,
      status: OrderStatus.served,
      time: '6:45 PM',
      createdAt: DateTime.now().subtract(const Duration(minutes: 60)),
      itemsPreview: ['2x Tandoori Chicken', '1x Rogan Josh', '3x Roti', '2x Raita', '1x Kheer'],
      itemsDetails: [
        OrderItem(name: 'Tandoori Chicken', quantity: 2, price: '420'),
        OrderItem(name: 'Rogan Josh', quantity: 1, price: '380'),
        OrderItem(name: 'Roti', quantity: 3, price: '25'),
        OrderItem(name: 'Raita', quantity: 2, price: '60'),
        OrderItem(name: 'Kheer', quantity: 1, price: '80'),
      ],
    ),
    Order(
      id: 'ord_005',
      orderNumber: 'ORD-0005',
      table: 'Table 7',
      customerName: 'Sneha Roy',
      items: 3,
      total: 720,
      subtotal: 686,
      tax: 34,
      status: OrderStatus.billed,
      time: '6:30 PM',
      createdAt: DateTime.now().subtract(const Duration(minutes: 75)),
      itemsPreview: ['1x Veg Thali', '2x Mango Lassi', '1x Rasgulla'],
      itemsDetails: [
        OrderItem(name: 'Veg Thali', quantity: 1, price: '480'),
        OrderItem(name: 'Mango Lassi', quantity: 2, price: '90'),
        OrderItem(name: 'Rasgulla', quantity: 1, price: '60'),
      ],
    ),
    Order(
      id: 'ord_006',
      orderNumber: 'ORD-0006',
      table: 'Table 4',
      customerName: 'Vikram Singh',
      items: 4,
      total: 1100,
      subtotal: 1048,
      tax: 52,
      status: OrderStatus.paid,
      time: '6:00 PM',
      createdAt: DateTime.now().subtract(const Duration(minutes: 120)),
      itemsPreview: ['1x Mutton Korma', '2x Naan', '1x Pulao', '2x Shahi Tukda'],
      itemsDetails: [
        OrderItem(name: 'Mutton Korma', quantity: 1, price: '520'),
        OrderItem(name: 'Naan', quantity: 2, price: '30'),
        OrderItem(name: 'Pulao', quantity: 1, price: '220'),
        OrderItem(name: 'Shahi Tukda', quantity: 2, price: '120'),
      ],
    ),
    Order(
      id: 'ord_007',
      orderNumber: 'ORD-0007',
      table: 'Table 6',
      items: 2,
      total: 480,
      subtotal: 457,
      tax: 23,
      status: OrderStatus.confirmed,
      time: '7:25 PM',
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      itemsPreview: ['2x Palak Paneer', '3x Chapati'],
      itemsDetails: [
        OrderItem(name: 'Palak Paneer', quantity: 2, price: '190'),
        OrderItem(name: 'Chapati', quantity: 3, price: '20'),
      ],
    ),
  ];

  List<Order> get orders => List.unmodifiable(_orders);

  List<Order> get newOrders => _orders.where((o) => o.status == OrderStatus.placed).toList();
  List<Order> get activeOrders => _orders.where((o) => o.status != OrderStatus.placed && o.status != OrderStatus.cancelled).toList();

  Order? findById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  void updateStatus(String id, OrderStatus status) {
    final idx = _orders.indexWhere((o) => o.id == id);
    if (idx != -1) {
      _orders[idx] = _orders[idx].copyWith(status: status);
      notifyListeners();
    }
  }

  void generateBill(String id) {
    updateStatus(id, OrderStatus.billed);
  }

  void payOrder(String id) {
    updateStatus(id, OrderStatus.paid);
  }
}
