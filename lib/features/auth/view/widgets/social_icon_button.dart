import 'package:flutter/material.dart';

class SocialIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const SocialIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF333333)),
        ),
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}
