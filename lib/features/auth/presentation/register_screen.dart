import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:lingoo/shared/widgets/auth_form_wrapper.dart';
import 'package:lingoo/shared/widgets/form_input.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _nameController = TextEditingController();

  void register() async {
    try {
      final response = await Dio().post(
        'http://192.168.56.1:3333/users/register',
        data: {
          'email': _emailController.text,
          'password': _passwordController.text,
          'confirmPassword': _passwordConfirmController.text,
          'name': _nameController.text,
        },
      );
      if (context.mounted) {
        context.go('/confirm');
      }
    } catch (e) {
      print("Registration failed: $e");
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthFormWrapper(
      title: 'LanguaFlow',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildTextField(_nameController, 'Name', Icons.person),
          const SizedBox(height: 12),
          buildTextField(_emailController, 'Email', Icons.email),
          const SizedBox(height: 12),
          buildTextField(_passwordController, 'Password', Icons.lock, isObscure: true),
          const SizedBox(height: 12),
          buildTextField(_passwordConfirmController, 'Confirm Password', Icons.lock_outline, isObscure: true),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: register,
            child: const Text(
              'Register',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          const SizedBox(height: 30),

          // ✅ Навигационные кнопки снизу
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  context.go('/login');
                },
                child: const Text(
                  'Already have an account?',
                  style: TextStyle(color: Colors.deepPurple, fontSize: 14),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  context.go('/forgot-password');
                },
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(color: Colors.redAccent, fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
