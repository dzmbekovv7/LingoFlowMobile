// lib/features/auth/presentation/confirm_screen.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lingoo/shared/widgets/auth_form_wrapper.dart';
import 'package:lingoo/shared/widgets/form_input.dart';

class ConfirmScreen extends StatefulWidget {
  const ConfirmScreen({super.key});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  String error = '';

  void confirm() async {
    try {
      final res = await Dio().post('http://192.168.56.1:3333/users/confirm', data: {
        'email': emailController.text,
        'code': codeController.text,
      });

      final token = res.data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      if (!mounted) return;
      context.go('/home');
    } catch (e) {
      setState(() => error = 'Invalid code or email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthFormWrapper(
      title: 'Confirm Account',
      child: Column(
        children: [
          buildTextField(emailController, 'Email', Icons.email),
          const SizedBox(height: 10),
          buildTextField(codeController, 'Code', Icons.verified),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: confirm,
            child: const Text(
              'Confirm',
              style: TextStyle(fontSize: 18),
            ),
          ),
          if (error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(error, style: const TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }
}
