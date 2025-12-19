import 'package:cybercare/core/common/snackbar.dart';
import 'package:cybercare/features/auth/view/bloc/auth_bloc.dart';
import 'package:cybercare/features/auth/view/widgets/auth_button.dart';
import 'package:cybercare/features/auth/view/widgets/auth_field.dart';
import 'package:cybercare/features/auth/view/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          showSnackBar(context, 'Error', state.message);
        } else if (state is AuthForgotPasswordSuccess) {
          showSnackBar(context, 'Success', 'Password reset link sent to email!');
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key:_formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Text('cybercarec',
                    textAlign: TextAlign.center, style: textTheme.headlineLarge),
                const SizedBox(height: 60),
                // Placeholder for your image
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(Icons.lock_reset, color: Colors.grey, size: 50),
                  ),
                ),
                const SizedBox(height: 48),
                MyField(
                  hintText: 'email',
                  myIcon: Iconsax.direct_right,
                  isPassword: false,
                  controller: emailController,
                ),
                const SizedBox(height: 16),
                Text(
                  'By continuing, you agree to the Terms and Conditions',
                  style: textTheme.bodyMedium?.copyWith(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                AuthButton(
                  text: 'Forgot Password', // Design says this, maybe "Send Reset Link"?
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthForgotPassword(email: emailController.text.trim()));                },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  },
);
  }
}
