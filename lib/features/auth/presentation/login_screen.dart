import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:lingoo/shared/widgets/auth_form_wrapper.dart';
import 'package:lingoo/shared/widgets/form_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen>{
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


  void login() async{
    try{
      final response = await Dio().post(
        'http://192.168.56.1:3333/users/login',
        data: {
          'email': _emailController.text,
          'password': _passwordController.text
        },
      );
      final token = response.data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      if(context.mounted){
        context.go("/home");
      }
    }catch (e){
      print("Failed ${e}");
    }
  }

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return AuthFormWrapper(
      title: 'LanguaFlow',
      child: Column(
        children: [
          buildTextField(_emailController, 'Email', Icons.email),
          const SizedBox(height: 10),
          buildTextField(_passwordController, 'Password', Icons.lock, isObscure: true),
          const SizedBox(height: 10),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: login,
        child: const Text(
          'Login',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  context.go('/register');
                },
                child: const Text(
                  'Do not you have an account?',
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