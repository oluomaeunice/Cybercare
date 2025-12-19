import 'dart:io';
import 'package:cybercare/core/constants/app_colors.dart';
import 'package:cybercare/core/device_utility.dart';
import 'package:cybercare/features/modules/moduledata/models/module_model.dart';
import 'package:cybercare/features/modules/moduledata/repository/module_repository.dart';
import 'package:cybercare/features/modules/view/creation/add_content_screen.dart';
import 'package:cybercare/init_dependencies.dart'; // For service locator
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CreateModuleScreen extends StatefulWidget {
  const CreateModuleScreen({super.key});

  @override
  State<CreateModuleScreen> createState() => _CreateModuleScreenState();
}

class _CreateModuleScreenState extends State<CreateModuleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _durationCtrl = TextEditingController(); // e.g., "1.5 Hours"
  String _difficulty = 'Beginner';
  File? _coverImage;
  bool _isLoading = false;

  void _pickImage() async {
    final image = await pickImage(); // Your existing utils
    if (image != null) setState(() => _coverImage = image);
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && _coverImage != null) {
      setState(() => _isLoading = true);

      try {
        // 1. Create the Module via Repository
        final repo = ModuleRepository(serviceLocator());
        final moduleId = await repo.createModule(
          module: ModuleModel(
            title: _titleCtrl.text.trim(),
            description: _descCtrl.text.trim(),
            difficulty: _difficulty,
            duration: _durationCtrl.text.trim(),
          ),
          coverImage: _coverImage!,
        );

        // 2. Navigate to Content Creator
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AddContentScreen(moduleId: moduleId, moduleTitle: _titleCtrl.text),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Course Module")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Cover Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    image: _coverImage != null
                        ? DecorationImage(image: FileImage(_coverImage!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: _coverImage == null
                      ? const Icon(Iconsax.image, size: 50, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 20),

              // Fields
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: "Module Title"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _durationCtrl,
                decoration: const InputDecoration(labelText: "Est. Duration (e.g. 2 Hours)"),
              ),
              const SizedBox(height: 20),

              // Difficulty Dropdown
              DropdownButtonFormField<String>(
                value: _difficulty,
                decoration: const InputDecoration(labelText: "Difficulty"),
                items: ['Beginner', 'Intermediate', 'Advanced']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _difficulty = v!),
              ),
              const SizedBox(height: 30),

              // Next Button
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Create & Add Topics", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}