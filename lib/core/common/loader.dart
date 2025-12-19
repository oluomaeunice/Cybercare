import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loader extends StatelessWidget {

  final String animation;
  const Loader({required this.animation,super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(animation, width: MediaQuery.of(context).size.width * 0.8),
            Text('You are been logged in ...',)
          ],
        ),
      ),
    );
  }
}
