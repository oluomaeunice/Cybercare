// lib/features/resources/view/resources_screen.dart

import 'package:animate_do/animate_do.dart';
import 'package:cybercare/core/common/image_text.dart';
import 'package:cybercare/core/common/loader.dart'; // Import your loader
import 'package:cybercare/core/constants/app_colors.dart';
import 'package:cybercare/core/constants/app_strings.dart';
import 'package:cybercare/features/resources/view/add_new_resource.dart';
import 'package:cybercare/features/resources/view/detail_screen.dart';
import 'package:cybercare/features/resources/view/pdf_resource_screen.dart';
import 'package:cybercare/features/resources/view/resourcebloc/resource_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {

  @override
  void initState() {
    super.initState();
    // Fetch resources when screen loads
    context.read<ResourceBloc>().add(FetchAllResources());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Screen Title & Add Button
              Row(
                children: [
                  Text(
                    AppStrings.resourcesTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  FadeInRight(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 300),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Iconsax.add, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const AddNewResourceScreen()),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 2. Dynamic List using BlocBuilder
              Expanded(
                child: BlocBuilder<ResourceBloc, ResourceState>(
                  builder: (context, state) {
                    if (state is ResourceLoading) {
                      return Center(child: Loader(animation: MyImages.signAnimation,)); // Use your Loader widget
                    }
                    if (state is ResourceFailure) {
                      return Center(child: Text(state.error, style: const TextStyle(color: Colors.white)));
                    }
                    if (state is ResourceDisplaySuccess) {
                      if (state.resources.isEmpty) {
                        return const Center(child: Text("No resources yet.", style: TextStyle(color: Colors.white)));
                      }

                      return ListView.builder(
                        itemCount: state.resources.length,
                        itemBuilder: (context, index) {
                          final resource = state.resources[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: _ResourceCard(
                              // Choose icon based on type
                              icon: resource.type == 'pdf'
                                  ? Iconsax.document_text
                                  : Iconsax.book_1,
                              title: resource.title,
                              description: resource.description, // Ensure your model has description
                              onTap: () {
                                if (resource.type == 'pdf') {
                                  Navigator.push(
                                    context,
                                    PdfResourceScreen.route(resource),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    ArticleScreen.route(resource),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      );
                    }
                    // Initial state or unexpected state
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Keep your existing Card Widget exactly as it is
class _ResourceCard extends StatelessWidget {
  const _ResourceCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryDark.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primaryDark, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textDark.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textGrey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}