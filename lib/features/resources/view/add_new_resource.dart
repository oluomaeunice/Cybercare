import 'dart:io';
import 'package:cybercare/app/view/app.dart';
import 'package:cybercare/core/common/image_text.dart';
import 'package:cybercare/core/common/loader.dart';
import 'package:cybercare/core/common/snackbar.dart';
import 'package:cybercare/core/constants/app_colors.dart';
import 'package:cybercare/core/device_utility.dart';
import 'package:cybercare/features/resources/view/resourcebloc/resource_bloc.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class AddNewResourceScreen extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const AddNewResourceScreen());

  const AddNewResourceScreen({super.key});

  @override
  State<AddNewResourceScreen> createState() => _AddNewResourceScreenState();
}

class _AddNewResourceScreenState extends State<AddNewResourceScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController(); // Added Description
  final contentController = TextEditingController();
  final uploadFormKey = GlobalKey<FormState>();

  File? image;
  File? pdfFile;
  String selectedType = 'article'; // Default type
  final List<String> resourceTypes = ['article', 'pdf'];

  void selectPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        pdfFile = File(result.files.single.path!);
      });
    }
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void nowUploadResource() {
    if (uploadFormKey.currentState!.validate() && image != null) {
      // Logic check
      if (selectedType == 'pdf' && pdfFile == null) {
        showSnackBar(context, 'Missing PDF', 'Please attach a PDF file.');
        return;
      }

      context.read<ResourceBloc>().add(
        ResourceUploadEvent(
          image: image!,
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          content: contentController.text.trim(),
          type: selectedType,
          pdfFile: pdfFile, // <--- Pass PDF
        ),
      );
    } else if (image == null) {
      showSnackBar(context, 'Missing Image', 'Please select a cover image.');
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Resource'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.tick_circle, size: 32),
            onPressed: () {
              nowUploadResource();
            },
          ),
        ],
      ),
      body: BlocConsumer<ResourceBloc, ResourceState>(
        listener: (context, state) {
          if (state is ResourceFailure) {
            showSnackBar(context, 'Oops', state.error);
          } else if (state is ResourceUploadSuccess) {
            // 1. Show Success Message
            showSnackBar(context, 'Success', 'Resource uploaded successfully!');

            // 2. Trigger the Refresh (Fetch data again)
            context.read<ResourceBloc>().add(FetchAllResources());

            // 3. Go Back to the previous screen
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is ResourceLoading) {
            return Loader(animation: MyImages.signAnimation);
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
              child: Form(
                key: uploadFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Image Picker
                    image != null
                        ? GestureDetector(
                      onTap: selectImage,
                      child: SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                image!,
                                fit: BoxFit.cover,
                              ))),
                    )
                        : GestureDetector(
                      onTap: selectImage,
                      child: DottedBorder(
                          options: RoundedRectDottedBorderOptions(
                            dashPattern: [16, 7],
                            strokeWidth: 2,
                            radius: Radius.circular(16),
                            padding: EdgeInsets.all(16),
                            color: AppColors.darkGrey,
                          ),
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Iconsax.folder_open, size: 40),
                                SizedBox(height: 15),
                                Text('Select Cover Image', style: TextStyle(fontSize: 16))
                              ],
                            ),
                          )),
                    ),
                    const SizedBox(height: 24),

                    // 2. Resource Type Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Resource Type',
                        border: OutlineInputBorder(),
                      ),
                      items: resourceTypes.map((String type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedType = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    if (selectedType == 'pdf')
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryDark),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Iconsax.document_text, color: AppColors.primaryDark),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                  pdfFile != null
                                      ? pdfFile!.path.split('/').last
                                      : 'No PDF selected',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis
                              ),
                            ),
                            TextButton(
                                onPressed: selectPdf,
                                child: const Text("Select PDF")
                            ),
                          ],
                        ),
                      ),

                    if (selectedType == 'pdf')
                      const SizedBox(height: 16),

                    // 3. Title Field
                    ResourceEditor(
                      controller: titleController,
                      hintHint: 'Resource Title',
                      maxLines: 1,
                    ),
                    const SizedBox(height: 16),

                    // 4. Description Field (New)
                    ResourceEditor(
                      controller: descriptionController,
                      hintHint: 'Short Description (appears on card)',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // 5. Main Content Field
                    if (selectedType == 'article')
                      ResourceEditor(
                        controller: contentController,
                        hintHint: 'Main Content (Markdown)',
                        minLines: 10,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ResourceEditor extends StatelessWidget {
  final TextEditingController controller;
  final String hintHint;
  final int? maxLines;
  final int? minLines;

  const ResourceEditor({
    super.key,
    required this.controller,
    required this.hintHint,
    this.maxLines,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
      decoration: InputDecoration(
        hintText: hintHint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.textGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryDark, width: 2),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintHint is missing!";
        }
        return null;
      },
    );
  }
}