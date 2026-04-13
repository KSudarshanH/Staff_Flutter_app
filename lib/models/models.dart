enum StaffRole { servingStaff, billingStaff }

enum OrderStatus {
  placed,
  confirmed,
  preparing,
  ready,
  served,
  billed,
  paid,
  cancelled,
}

enum TableStatus { available, occupied, reserved, needsBill }

extension OrderStatusX on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.placed:
        return 'PLACED';
      case OrderStatus.confirmed:
        return 'CONFIRMED';
      case OrderStatus.preparing:
        return 'PREPARING';
      case OrderStatus.ready:
        return 'READY TO SERVE';
      case OrderStatus.served:
        return 'SERVED';
      case OrderStatus.billed:
        return 'BILLED';
      case OrderStatus.paid:
        return 'PAID';
      case OrderStatus.cancelled:
        return 'CANCELLED';
    }
  }

  String get apiString => name.toUpperCase();
}

class OrderItem {
  final String name;
  final int quantity;
  final String price;

  OrderItem({required this.name, required this.quantity, required this.price});

  double get total => (double.tryParse(price) ?? 0.0) * quantity;
}

class Order {
  final String id;
  final String orderNumber;
  final String table;
  final String? customerName;
  final int items;
  final double total;
  final double subtotal;
  final double tax;
  final OrderStatus status;
  final String time;
  final DateTime createdAt;
  final List<String> itemsPreview;
  final List<OrderItem> itemsDetails;

  Order({
    required this.id,
    required this.orderNumber,
    required this.table,
    this.customerName,
    required this.items,
    required this.total,
    required this.subtotal,
    required this.tax,
    required this.status,
    required this.time,
    required this.createdAt,
    required this.itemsPreview,
    required this.itemsDetails,
  });

  Order copyWith({OrderStatus? status}) {
    return Order(
      id: id,
      orderNumber: orderNumber,
      table: table,
      customerName: customerName,
      items: items,
      total: total,
      subtotal: subtotal,
      tax: tax,
      status: status ?? this.status,
      time: time,
      createdAt: createdAt,
      itemsPreview: itemsPreview,
      itemsDetails: itemsDetails,
    );
  }
}

class TableModel {
  final String id;
  final String name;
  final TableStatus status;
  final int seats;
  final String? server;

  TableModel({
    required this.id,
    required this.name,
    required this.status,
    required this.seats,
    this.server,
  });
}

class StaffUser {
  final String id;
  final String name;
  final String email;
  final StaffRole role;

  StaffUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
}
