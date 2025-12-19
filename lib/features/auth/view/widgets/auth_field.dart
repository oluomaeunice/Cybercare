
import 'package:cybercare/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

class MyField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword, isEmail;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final IconData myIcon;


  const MyField({
    required this.hintText,
    required this.controller,
    required this.myIcon,
    this.isPassword = true,
    this.keyboardType,
    this.inputFormatters,
    super.key, this.isEmail = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? true : false,
      decoration: InputDecoration(
        prefixIcon: Icon(myIcon),
        labelText: hintText,
        floatingLabelStyle: Theme.of(context).textTheme.bodyMedium,
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(Iconsax.eye ,
            color: AppColors.primaryDark,
          ),
          onPressed: () {
          },
        )
            : null,
      ),
      validator: (value){
        if(isPassword){
          return value!.length < 6 ? 'Password must be 6+ characters' : null;
        }else if(isEmail){
          return value!.isEmpty || !value.contains('@')
              ? 'Enter a valid email'
              : null;
        }else {
          return value!.isEmpty
              ? '$hintText is required'
              : null;
        }
      },
    );
  }
}