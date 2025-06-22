// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AuthProvider extends ChangeNotifier {
//   String? _token;
//   bool _isLoading = true;
//
//   bool get isAuthenticated => _token != null;
//   bool get isLoading => _isLoading;
//
//   AuthProvider() {
//     _loadToken(); // загружаем токен при старте
//   }
//
//   Future<void> _loadToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     _token = prefs.getString('token');
//     _isLoading = false;
//     notifyListeners();
//   }
//
//
//   Future<void> login(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('token', token);
//     _token = token;
//     notifyListeners();
//   }
//
//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('token');
//     _token = null;
//     notifyListeners();
//   }
// }
