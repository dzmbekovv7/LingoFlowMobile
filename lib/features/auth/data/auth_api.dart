// lib/features/auth/data/auth_api.dart
import 'package:dio/dio.dart';

class AuthApi {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));

  Future<void> register({
    required String email,
    required String password,
    required String username,
  }) async {
    await _dio.post('/register', data: {
      'email': email,
      'password': password,
      'username': username,
    });
  }
}
