import 'package:cybercare/core/constants/app_colors.dart';
import 'package:cybercare/core/constants/app_strings.dart';
import 'package:cybercare/features/auth/view/pages/login_page.dart';
import 'package:cybercare/features/auth/view/pages/signup_page.dart';
import 'package:cybercare/features/auth/view/widgets/auth_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              // Placeholder for your image
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Image.asset("assets/applogo.png", width: 200),
                ),
              ),
              const SizedBox(height: 48),
              Text(AppStrings.welcomeScreenTitle,
                style: textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(AppStrings.welcomeScreenDes,
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
              AuthButton(
                text: 'Log In',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: AppColors.accentYellow),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupPage()),
                    );
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
