import 'dart:math';
import 'package:cybercare/features/modules/moduledata/models/module_model.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BadgeRevealDialog extends StatefulWidget {
  final BadgeModel badge;
  const BadgeRevealDialog({super.key, required this.badge});

  @override
  State<BadgeRevealDialog> createState() => _BadgeRevealDialogState();
}

class _BadgeRevealDialogState extends State<BadgeRevealDialog> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 3));
    _controller.play(); // Start confetti immediately
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 1. The Dialog Content
        Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "CONGRATULATIONS!",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                      letterSpacing: 1.2
                  ),
                ),
                const SizedBox(height: 20),

                // Badge Image
                if (widget.badge.imageUrl.isNotEmpty)
                  Image.network(widget.badge.imageUrl, height: 120)
                else
                  const Icon(Icons.verified, size: 100, color: Colors.blue),

                const SizedBox(height: 20),
                Text(
                  widget.badge.name,
                  style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  widget.badge.description ?? "You've mastered this module!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text("Claim Badge", style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          ),
        ),

        // 2. Confetti Overlay
        ConfettiWidget(
          confettiController: _controller,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
        ),
      ],
    );
  }
}