import 'package:flutter/material.dart';
import '../models/models.dart';

class TablesProvider extends ChangeNotifier {
  final List<TableModel> _tables = [
    TableModel(id: 't1', name: 'Table 1', status: TableStatus.occupied, seats: 4, server: 'Amit'),
    TableModel(id: 't2', name: 'Table 2', status: TableStatus.available, seats: 2),
    TableModel(id: 't3', name: 'Table 3', status: TableStatus.occupied, seats: 6, server: 'Priya'),
    TableModel(id: 't4', name: 'Table 4', status: TableStatus.needsBill, seats: 4, server: 'Rahul'),
    TableModel(id: 't5', name: 'Table 5', status: TableStatus.available, seats: 4),
    TableModel(id: 't6', name: 'Table 6', status: TableStatus.occupied, seats: 8, server: 'Sneha'),
    TableModel(id: 't7', name: 'Table 7', status: TableStatus.reserved, seats: 6),
    TableModel(id: 't8', name: 'Table 8', status: TableStatus.available, seats: 2),
    TableModel(id: 't9', name: 'Table 9', status: TableStatus.needsBill, seats: 4, server: 'Vikram'),
    TableModel(id: 't10', name: 'Table 10', status: TableStatus.available, seats: 6),
    TableModel(id: 't11', name: 'Table 11', status: TableStatus.occupied, seats: 4, server: 'Amit'),
    TableModel(id: 't12', name: 'Table 12', status: TableStatus.available, seats: 8),
  ];

  List<TableModel> get tables => List.unmodifiable(_tables);
}
