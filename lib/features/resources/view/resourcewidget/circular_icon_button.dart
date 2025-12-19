
import 'package:flutter/material.dart';

class CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  const CircularIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: size,
          color: Colors.black87,
        ),
      ),
    );
  }
}