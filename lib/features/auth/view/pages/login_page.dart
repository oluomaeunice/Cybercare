import 'package:animate_do/animate_do.dart';
import 'package:cybercare/app/view/app.dart';
import 'package:cybercare/core/constants/app_colors.dart';
import 'package:cybercare/core/constants/sizes.dart';
import 'package:cybercare/features/auth/view/bloc/auth_bloc.dart';
import 'package:cybercare/features/auth/view/pages/signup_page.dart';
import 'package:cybercare/features/auth/view/widgets/auth_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cybercare/core/common/image_text.dart';
import 'package:cybercare/core/common/loader.dart';
import 'package:cybercare/core/common/snackbar.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => LoginPage());

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes(context).wp(8)),
            child: SingleChildScrollView(
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthFailure) {
                    showSnackBar(context, 'Oops', state.message);
                  } else if (state is AuthSuccess) {
                    // Successfully logged in -> Go to Main
                    Navigator.pushAndRemoveUntil(
                        context,
                        MainNavigatorScreen.route(),
                            (route) => false
                    );
                  }
                },
                builder: (context, state) {
                  if(state is AuthLoading){
                    return Loader( animation: MyImages.signAnimation, );
                  }
                  return FadeInDown(
                    duration: Duration(milliseconds: 500),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: AppSizes(context).hp(18),
                        ),
                        Text(
                          'Login in to your \nAccount',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(fontSize: 30),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: AppSizes(context).hp(1),
                        ),
                        Text(
                          'Register by using your email and a password to get the latest news',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: AppSizes(context).hp(2),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSizes(context).wp(5),
                              vertical: AppSizes(context).hp(4)),
                          decoration: BoxDecoration(
                              color: AppColors.primaryDark,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: AppColors.black.withOpacity(0.1),
                                    blurRadius: 10.0,
                                    spreadRadius: 2.0,
                                    offset: Offset(0, 4))
                              ]),
                          child: Form(
                            key:_formKey,
                            child: FadeInUp(
                              duration: Duration(milliseconds: 500),
                              delay: Duration(milliseconds: 300),
                              child: Column(
                                children: [
                                  MyField(
                                    hintText: 'email',
                                    myIcon: Iconsax.direct_right,
                                    isPassword: false,
                                    controller: emailController,
                                  ),
                                  SizedBox(
                                    height: AppSizes(context).hp(2),
                                  ),
                                  MyField(
                                    hintText: 'password',
                                    myIcon: Iconsax.password_check,
                                    controller: passwordController,
                                  ),

                                  /// Remember Me and Forgot Password
                                  ///
                                  SizedBox(
                                    height: AppSizes(context).hp(1.2),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ///Remember Me
                                      Row(
                                        children: [
                                          Checkbox(
                                              activeColor: AppColors.primaryDark,
                                              value: true,
                                              onChanged: (value) {}),
                                          Text(
                                            'Remember Me',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                        ],
                                      ),

                                      /// Forgot Password
                                      TextButton(
                                          onPressed: () {},
                                          child: const Text(
                                            'Forgot Password',
                                            style: TextStyle(
                                                color: AppColors.primaryDark),
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: AppSizes(context).hp(1.2),
                                  ),
                                  FadeInUp(
                                    duration: Duration(milliseconds: 500),
                                    delay: Duration(milliseconds: 400),
                                    child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                context.read<AuthBloc>().add(
                                                    AuthLogin(
                                                        email: emailController
                                                            .text
                                                            .trim(),
                                                        password:
                                                            passwordController
                                                                .text));
                                              }
                                            },
                                            child: const Text(
                                              'Log In',
                                            ))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: AppSizes(context).hp(4),
                        ),
                        FadeInUp(
                          duration: Duration(milliseconds: 500),
                          delay: Duration(milliseconds: 500),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account?',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              SizedBox(
                                width: AppSizes(context).wp(2),
                              ),
                              TextButton(
                                  style: TextButton.styleFrom(
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      minimumSize: Size.zero,
                                      padding: EdgeInsets.zero,
                                      foregroundColor: AppColors.primaryDark),
                                  onPressed: () {
                                    Navigator.push(context, SignupPage.route());
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(color: AppColors.primaryDark),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
