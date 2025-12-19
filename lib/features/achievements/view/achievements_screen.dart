import 'package:cybercare/core/constants/app_colors.dart';
import 'package:cybercare/core/constants/app_strings.dart';
import 'package:cybercare/features/achievements/bloc/badgebloc_bloc.dart';
import 'package:cybercare/features/achievements/view/add_badge.dart';
import 'package:cybercare/features/modules/moduledata/models/module_model.dart'; // Created in Step 4
import 'package:cybercare/features/modules/moduledata/repository/module_repository.dart';
import 'package:cybercare/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BadgeBloc(ModuleRepository(serviceLocator()))..add(FetchBadgeData()),
      child: Scaffold(
        backgroundColor: AppColors.primaryDark,
        floatingActionButtonLocation: CenterRightFabLocation(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to Add Badge Screen
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AddBadgeScreen()));
          },
          backgroundColor: AppColors.accentYellow,
          child: const Icon(Iconsax.add, color: Colors.black),
        ),
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<BadgeBloc, BadgeState>(
                builder: (context, state) {
                  if (state is BadgeLoading) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  }
                  if (state is BadgeError) {
                    return Center(child: Text(state.message, style: const TextStyle(color: Colors.white)));
                  }

                  // Default empty lists if state is not Loaded yet
                  List<BadgeModel> earned = [];
                  List<BadgeModel> locked = [];

                  if (state is BadgeDataLoaded) {
                    earned = state.earnedBadges;
                    locked = state.lockedBadges;
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Text(
                        AppStrings.achievementsTitle,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Unlocked List
                      if (earned.isEmpty)
                        const Text("No badges earned yet. Keep learning!", style: TextStyle(color: Colors.white70))
                      else
                        SizedBox(
                          height: 220,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: earned.length,
                            itemBuilder: (context, index) {
                              final badge = earned[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: SizedBox(
                                  width: 160,
                                  child: _AchievementCard(
                                    title: badge.name,
                                    description: badge.description ?? 'Awarded',
                                    imageUrl: badge.imageUrl,
                                    isUnlocked: true,
                                    badgeColor: AppColors.accentYellow,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                      const SizedBox(height: 12),
                      Text(
                        AppStrings.achievementsUnlockMore,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Locked Grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: locked.length,
                        itemBuilder: (context, index) {
                          final badge = locked[index];
                          return _AchievementCard(
                            title: badge.name,
                            description: 'Complete linked module',
                            imageUrl: badge.imageUrl,
                            isUnlocked: false,
                          );
                        },
                      ),
                      const SizedBox(height: 60), // Space for FAB
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.isUnlocked,
    this.badgeColor,
  });

  final String title;
  final String description;
  final String imageUrl;
  final bool isUnlocked;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    final Color cardBackgroundColor = isUnlocked ? AppColors.cardLight : AppColors.primaryLight;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              color: isUnlocked ? null : Colors.black.withOpacity(0.2), // Dim locked badges
              errorBuilder: (_,__,___) => const Icon(Iconsax.award, size: 50),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          if (isUnlocked)
            Text(description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.grey))
          else
            const Text("Locked", style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}
class CenterRightFabLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = scaffoldGeometry.scaffoldSize.width -
        scaffoldGeometry.floatingActionButtonSize.width -
        16.0; // Right padding
    final double fabY = (scaffoldGeometry.scaffoldSize.height -
        scaffoldGeometry.floatingActionButtonSize.height) /
        2.0; // Vertical center
    return Offset(fabX, fabY);
  }
}