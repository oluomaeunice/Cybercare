import 'dart:io';

import 'package:cybercare/core/constants/app_colors.dart';
import 'package:cybercare/core/device_utility.dart';
import 'package:cybercare/features/achievements/bloc/badgebloc_bloc.dart';
import 'package:cybercare/features/modules/moduledata/models/module_model.dart';
import 'package:cybercare/features/modules/moduledata/repository/module_repository.dart';
import 'package:cybercare/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class AddBadgeScreen extends StatefulWidget {
  const AddBadgeScreen({super.key});

  @override
  State<AddBadgeScreen> createState() => _AddBadgeScreenState();
}

class _AddBadgeScreenState extends State<AddBadgeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  File? _image;
  String? _selectedModuleId;

  void _pickImage() async {
    final file = await pickImage();
    if (file != null) setState(() => _image = file);
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate() && _image != null && _selectedModuleId != null) {
      context.read<BadgeBloc>().add(CreateBadgeEvent(
        name: _nameCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        moduleId: _selectedModuleId!,
        image: _image!,
      ));
    } else if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select an image")));
    } else if (_selectedModuleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a module")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BadgeBloc(ModuleRepository(serviceLocator()))..add(LoadBadgeCreationData()),
      child: Scaffold(
        appBar: AppBar(title: const Text("Create Badge")),
        body: BlocConsumer<BadgeBloc, BadgeState>(
          listener: (context, state) {
            if (state is BadgeCreatedSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Badge Created!")));
              Navigator.pop(context); // Go back to list
            } else if (state is BadgeError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is BadgeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            List<ModuleModel> modules = [];
            if (state is BadgeCreationReady) {
              modules = state.availableModules;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Image Picker
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primaryDark),
                          image: _image != null
                              ? DecorationImage(image: FileImage(_image!), fit: BoxFit.cover)
                              : null,
                        ),
                        child: _image == null
                            ? const Icon(Iconsax.camera, size: 40, color: Colors.grey)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text("Tap to upload badge icon"),
                    const SizedBox(height: 24),

                    // Inputs
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: "Badge Name", border: OutlineInputBorder()),
                      validator: (v) => v!.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descCtrl,
                      decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),

                    // Module Selector
                    DropdownButtonFormField<String>(
                      value: _selectedModuleId,
                      decoration: const InputDecoration(
                        labelText: "Link to Module",
                        border: OutlineInputBorder(),
                        helperText: "Only modules without badges are shown",
                      ),
                      items: modules.map((m) {
                        return DropdownMenuItem(
                          value: m.id,
                          child: Text(m.title, overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedModuleId = val),
                    ),
                    const SizedBox(height: 32),

                    ElevatedButton(
                      onPressed: () => _submit(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text("Create Badge", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}