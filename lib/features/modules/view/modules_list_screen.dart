import 'package:animate_do/animate_do.dart';
import 'package:cybercare/features/modules/moduledata/models/module_model.dart';
import 'package:cybercare/features/modules/view/creation/add_content_screen.dart';
import 'package:cybercare/features/modules/view/creation/create_module.dart';
import 'package:cybercare/features/modules/view/module_details/module_detail_screen.dart';
import 'package:cybercare/features/modules/view/modulebloc/module_bloc.dart';
import 'package:cybercare/features/modules/view/modulebloc/module_state.dart';
import 'package:flutter/material.dart';
import 'package:cybercare/core/constants/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'modulebloc/module_event.dart';


class ModulesListScreen extends StatelessWidget {
  const ModulesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1. Header & Search
            _buildHeader(context),

            // 2. Filter Chips
            _buildFilters(context),

            // 3. Module List
            Expanded(
              child: BlocBuilder<ModuleBloc, ModuleState>(
                builder: (context, state) {
                  if (state is ModuleLoading) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  } else if (state is ModuleError) {
                    return Center(child: Text(state.message, style: const TextStyle(color: Colors.white)));
                  } else if (state is ModuleLoaded) {
                    if (state.modules.isEmpty) {
                      return const Center(child: Text("No modules found.", style: TextStyle(color: Colors.white70)));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.modules.length,
                      itemBuilder: (context, index) {
                        return _ModuleProgressCard(module: state.modules[index]);
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Course Modules",style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                            builder: (context) => CreateModuleScreen()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Search Field
          TextField(
            onChanged: (val) => context.read<ModuleBloc>().add(SearchModulesEvent(val)),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search topic...",
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              prefixIcon: const Icon(Iconsax.search_normal, color: Colors.white70),
              filled: true,
              fillColor: AppColors.cardLight.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    final filters = ['All', 'In Progress', 'Completed', 'Not Started'];

    return SizedBox(
      height: 60,
      child: BlocBuilder<ModuleBloc, ModuleState>(
        builder: (context, state) {
          String active = 'All';
          if (state is ModuleLoaded) active = state.activeFilter;

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final filter = filters[index];
              final isSelected = filter == active;
              return ChoiceChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (_) => context.read<ModuleBloc>().add(FilterModulesEvent(filter)),
                backgroundColor: Colors.transparent,
                selectedColor: AppColors.accentYellow,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                shape: const StadiumBorder(side: BorderSide(color: Colors.white24)),
              );
            },
          );
        },
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final bool ifTimerIs;
  const _Tag({required this.text, required this.color, required this.textColor, required this.ifTimerIs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          if (ifTimerIs) Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: Icon(Iconsax.clock, size: 15, color: textColor,),
          ),
          Text(text, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}



class _ModuleProgressCard extends StatelessWidget {
  final ModuleModel module;
  const _ModuleProgressCard({required this.module});

  @override
  Widget build(BuildContext context) {
    // Determine the color for the progress bar
    final Color progressColor = module.percentComplete == 1.0
        ? Colors.green
        : AppColors.accentYellow;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell( // Use InkWell for better visual feedback (like your target design)
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModuleDetailScreen(module: module),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6,),
          decoration: BoxDecoration( // Use a light background color
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 1, color: AppColors.white)
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(color: AppColors.cardBlue, shape: BoxShape.circle),
                child: ClipOval(
                  child: module.imageUrl != null
                      ? Image.network(module.imageUrl!, fit: BoxFit.cover, errorBuilder: (_,__,___) => Icon(Iconsax.document, color: AppColors.primaryDark))
                      : Icon(Iconsax.document, color: AppColors.primaryDark, size: 28),
                ),
              ),
              const SizedBox(width: 16),

              // 2. Module Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      module.title,
                      // Using a different style for contrast
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Difficulty & Duration (Tags)
                Row(
                    children: [
                      _Tag(text: module.difficulty, color: Colors.blue.shade100, textColor: Colors.blue.shade900,ifTimerIs:false),
                      const SizedBox(width: 8),
                      _Tag(text: module.duration, color: Colors.orange.shade100, textColor: Colors.orange.shade900,ifTimerIs:true),
                    ],
                  ),
                    const SizedBox(height: 8),

                    // Progress Bar
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: module.percentComplete,
                            backgroundColor: Colors.grey.shade300,
                            color: progressColor,
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "${(module.percentComplete * 100).toInt()}%",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: progressColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (module.percentComplete == 1.0)
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.check_circle, color: Colors.green, size: 24),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textGrey, size: 18),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
