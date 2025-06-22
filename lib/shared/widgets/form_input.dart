import 'package:flutter/material.dart';

Widget buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
      bool isObscure = false,
    }) {
  return TextField(
    controller: controller,
    obscureText: isObscure,
    decoration: InputDecoration(
      prefixIcon: Icon(icon),
      labelText: label,
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
  );
}
