import 'package:flutter/material.dart';
import '../models/models.dart';

class AuthProvider extends ChangeNotifier {
  StaffUser? _user;
  StaffRole? _role;
  bool _isLoading = false;

  StaffUser? get user => _user;
  StaffRole? get role => _role;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;

  Future<void> login(String email, String password, StaffRole role) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock login - no API integration
    _user = StaffUser(
      id: 'staff_001',
      name: role == StaffRole.billingStaff ? 'Billing Staff' : 'Serving Staff',
      email: email,
      role: role,
    );
    _role = role;
    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _role = null;
    notifyListeners();
  }
}
