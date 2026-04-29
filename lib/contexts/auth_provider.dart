import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class AuthProvider extends ChangeNotifier {
  StaffUser? _user;
  StaffRole? _role;
  bool _isLoading = false;

  String? _token;

  // ✅ GETTERS
  StaffUser? get user => _user;
  StaffRole? get role => _role;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  String? get token => _token;

  // 🔥 LOGIN WITH API
  Future<void> login(String email, String password, StaffRole role) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("https://pos-backend-s380.onrender.com/api/staff/login"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "email": email,
          "password": password,
        }),
      );

      print("LOGIN STATUS: ${response.statusCode}");
      print("LOGIN BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // 🔥 SAVE TOKEN
        _token = data['token'];

        // 🔥 SAVE USER
        final userData = data['data'];

_user = StaffUser(
  id: userData['id'],
  name: userData['name'],
  email: email, // backend not sending email
  role: role,
);
        _role = role;
      } else {
        throw Exception("Login failed: ${response.body}");
      }
    } catch (e) {
      print("Login error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // 🔥 LOGOUT
  void logout() {
    _user = null;
    _role = null;
    _token = null;
    notifyListeners();
  }
}