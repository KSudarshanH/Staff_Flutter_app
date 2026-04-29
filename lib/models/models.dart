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

// ---------------- STATUS EXTENSION ----------------
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

// ---------------- ORDER ITEM ----------------
class OrderItem {
  final String name;
  final int quantity;
  final String price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  double get total => (double.tryParse(price) ?? 0.0) * quantity;
}

// ---------------- ORDER MODEL ----------------
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

  // ✅ FINAL FIXED JSON PARSING
  factory Order.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List? ?? [];

    final tableNumber = json['table_number'] ?? json['table_id'] ?? 'N/A';

    // ✅ FIX STATUS + PAYMENT STATUS
    final statusString = json['status'] ?? '';
    final paymentStatus = json['payment_status'] ?? '';

    OrderStatus parsedStatus;

    if (paymentStatus == "PAID") {
      parsedStatus = OrderStatus.paid;
    } else {
      parsedStatus = OrderStatus.values.firstWhere(
        (e) => e.name.toUpperCase() == statusString,
        orElse: () => OrderStatus.placed,
      );
    }

    return Order(
      id: json['id'] ?? '',

      orderNumber: (json['id'] ?? '')
          .toString()
          .substring(0, 6)
          .toUpperCase(),

      table: "Table $tableNumber",

      customerName: json['customer_name'],

      items: itemsList.length,

      total: double.tryParse(json['total_amount']?.toString() ?? "0") ?? 0,
      subtotal:
          double.tryParse(json['subtotal']?.toString() ?? "0") ?? 0,
      tax: double.tryParse(json['tax_amount']?.toString() ?? "0") ?? 0,

      status: parsedStatus, // ✅ IMPORTANT FIX

      time: _formatTime(json['created_at']),

      createdAt: DateTime.parse(json['created_at']),

      itemsPreview: itemsList
          .map((i) => (i['item_name'] ?? i['name']).toString())
          .toList(),

      itemsDetails: itemsList
          .map((i) => OrderItem(
                name: i['item_name'] ?? i['name'] ?? '',
                quantity: i['quantity'] ?? 0,
                price: i['price'].toString(),
              ))
          .toList(),
    );
  }

  // ---------------- TIME FORMAT ----------------
  static String _formatTime(String isoTime) {
    try {
      final dt = DateTime.parse(isoTime).toLocal();

      final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';

      return '$hour:$minute $period';
    } catch (e) {
      return '';
    }
  }

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

// ---------------- TABLE MODEL ----------------
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

// ---------------- STAFF USER ----------------
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