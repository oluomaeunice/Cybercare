import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final bool obscureText;

  const AuthTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Colors.grey)
            : null,
      ),
      // Add validator logic here later
    );
  }
}
