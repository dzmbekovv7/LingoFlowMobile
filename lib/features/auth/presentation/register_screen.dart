import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

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

  bool success = false;

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
      print('Server response: ${response.statusCode} - ${response.data}');

      if (context.mounted) {
        context.go('/confirm'); // или context.push('/confirm')

      }
    } catch (e) {
      print("Registration failed: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: success
          ? const Center(child: Text('Check your email to confirm.'))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            TextField(
              controller: _passwordConfirmController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: register, child: const Text('Register')),
          ],
        ),
      ),
    );
  }
}
