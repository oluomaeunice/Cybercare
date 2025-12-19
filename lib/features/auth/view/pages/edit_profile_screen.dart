import 'dart:io';
import 'package:cybercare/core/common/cubits/app_user.dart';
import 'package:cybercare/core/common/snackbar.dart';
import 'package:cybercare/features/auth/view/bloc/auth_bloc.dart';
import 'package:cybercare/features/auth/view/widgets/auth_button.dart';
import 'package:cybercare/features/auth/view/widgets/auth_field.dart';
import 'package:cybercare/features/auth/view/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart'; // Require this package

class EditProfileScreen extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const EditProfileScreen());
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  File? _imageFile;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Pre-fill data
    final userState = context.read<AppUserCubit>().state;
    if (userState is AppUserLoggedIn) {
      _nameController.text = userState.user.name;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            showSnackBar(context, 'Update Failed', state.message);
          } else if (state is AuthSuccess) {
            showSnackBar(context, 'Success', 'Profile Updated Successfully');
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          bool isLoading = state is AuthLoading;

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : null, // Fallback handled by child
                    child: _imageFile == null
                        ? const Icon(Icons.camera_alt, size: 40)
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Tap to change picture"),
                const SizedBox(height: 30),

                MyField(
                  hintText: 'email',
                  myIcon: Iconsax.direct_right,
                  isPassword: false,
                  controller: _nameController,
                ),
                const SizedBox(height: 30),
                isLoading
                    ? const CircularProgressIndicator()
                    : AuthButton(
                  text: 'Save Changes',
                  onPressed: () {
                    final userState = context.read<AppUserCubit>().state;
                    if (userState is AppUserLoggedIn) {
                      context.read<AuthBloc>().add(AuthUpdateProfile(
                        userId: userState.user.id,
                        name: _nameController.text.trim(),
                        image: _imageFile,
                      ));
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}