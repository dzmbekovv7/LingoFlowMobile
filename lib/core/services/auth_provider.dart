// core/services/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _token;
  String? _userId;

  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;
  String? get userId => _userId;

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('token');
    final storedUserId = prefs.getString('userId');

    if (storedToken != null && !JwtDecoder.isExpired(storedToken)) {
      _token = storedToken;
      _userId = storedUserId;
      _isLoggedIn = true;
    } else {
      _token = null;
      _userId = null;
      _isLoggedIn = false;
    }

    notifyListeners();
  }

  Future<void> login(String token, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('userId', userId);
    _token = token;
    _userId = userId;
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    _token = null;
    _userId = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
