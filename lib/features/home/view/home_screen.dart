import 'package:animate_do/animate_do.dart';
import 'package:cybercare/core/common/cubits/app_user.dart';
import 'package:cybercare/core/common/snackbar.dart';
import 'package:cybercare/features/achievements/bloc/badgebloc_bloc.dart';
import 'package:cybercare/features/modules/moduledata/models/module_model.dart';
import 'package:cybercare/features/modules/view/module_details/module_detail_screen.dart';
import 'package:cybercare/features/modules/view/modulebloc/module_bloc.dart';
import 'package:cybercare/features/modules/view/modulebloc/module_event.dart';
import 'package:cybercare/features/modules/view/modulebloc/module_state.dart';
import 'package:cybercare/features/profile/view/profile_screen.dart';
import 'package:cybercare/features/achievements/view/achievements_screen.dart';
import 'package:cybercare/features/resources/view/resourcebloc/resource_bloc.dart';
import 'package:cybercare/features/resources/view/resources_list.dart';
import 'package:flutter/material.dart';
import 'package:cybercare/core/constants/app_colors.dart';
import 'package:cybercare/core/constants/app_strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // 1. Fetch Data when Home Screen loads
    context.read<ModuleBloc>().add(FetchModulesEvent());
    context.read<BadgeBloc>().add(FetchBadgeData());
    context.read<ResourceBloc>().add(FetchAllResources());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Custom App Bar
                FadeInDown(
                  duration: const Duration(milliseconds: 300),
                  child: const _CustomAppBar(),
                ),
                const SizedBox(height: 24),

                // 2. Current Module Progress Card (Dynamic)
                FadeInLeft(
                  duration: const Duration(milliseconds: 300),
                  delay: const Duration(milliseconds: 100),
                  child: BlocBuilder<ModuleBloc, ModuleState>(
                    builder: (context, state) {
                      if (state is ModuleLoaded && state.modules.isNotEmpty) {
                        // Logic: Find first 'In Progress' module, else first 'Not Started', else last 'Completed'
                        final currentModule = state.modules.firstWhere(
                              (m) => m.percentComplete > 0 && m.percentComplete < 1.0,
                          orElse: () => state.modules.firstWhere(
                                (m) => m.percentComplete == 0,
                            orElse: () => state.modules.first,
                          ),
                        );
                        return _CurrentModuleCard(module: currentModule);
                      }
                      return const SizedBox.shrink(); // Hide if no modules
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Quick Modules Section Header
                const _QuickModulesSection(),
                const SizedBox(height: 24),

                // 4. Bottom Info Cards (Badges & Resources)
                const _BottomInfoRow(),
                const SizedBox(height: 32),

                // 5. Module Status List Section
                FadeInUp(
                  duration: const Duration(milliseconds: 200),
                  delay: const Duration(milliseconds: 100),
                  child: const _ModuleStatusSection(),
                ),
                const SizedBox(height: 92),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -- REUSABLE WIDGETS --

// WIDGET 1: Custom App Bar (UPDATED to show dynamic Image/Name)
class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar();

  @override
  Widget build(BuildContext context) {
    // Listen to User State to update name and image automatically
    return BlocBuilder<AppUserCubit, AppUserState>(
      builder: (context, state) {
        String userName = "Guardian";
        String? avatarUrl;

        if (state is AppUserLoggedIn) {
          // Use name if available, otherwise default
          if (state.user.name.isNotEmpty) {
            userName = state.user.name;
          }
          avatarUrl = state.user.avatarUrl;
        }

        return Row(
          children: [
            // Profile Picture
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primaryLight,
                // Check if avatarUrl exists, else use asset fallback
                backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                    ? NetworkImage(avatarUrl) as ImageProvider
                    : const AssetImage('assets/profile.jpg'),
              ),
            ),
            const SizedBox(width: 12),

            // Name & Level
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, $userName', // Displays dynamic name
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Cyber Security Level: Guardian',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textGrey),
                ),
              ],
            ),
            const Spacer(),

            // Profile/Settings Button
            FadeInRight(
              duration: const Duration(milliseconds: 500),
              delay: const Duration(milliseconds: 300),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Iconsax.setting_2, color: Colors.white),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// WIDGET 2: Current Module Progress Card
class _CurrentModuleCard extends StatelessWidget {
  final ModuleModel module;
  const _CurrentModuleCard({required this.module});

  @override
  Widget build(BuildContext context) {
    final currentLesson = module.completedTopics + 1;
    final totalLessons = module.totalTopics;
    final displayLesson = currentLesson > totalLessons ? totalLessons : currentLesson;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          // Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Iconsax.play, color: AppColors.primaryDark, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      AppStrings.homeCurrentModule,
                      style: TextStyle(color: AppColors.primaryDark),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Iconsax.video, color: AppColors.white, size: 28),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ModuleDetailScreen(module: module)));
                },
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Middle Row: Module Info
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: module.percentComplete,
                        minHeight: 10,
                        backgroundColor: Colors.grey.shade300,
                        color: AppColors.statusGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lesson $displayLesson of $totalLessons · ${module.duration}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Percentage
              Column(
                children: [
                  Text(
                    '${(module.percentComplete * 100).toInt()}%',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.white.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CircularIconButton(
                icon: Iconsax.calendar,
                label: AppStrings.homeDailyChallenge,
                onTap: () {
                  showSnackBar(context, 'Coming Soon', 'Daily challenges unlock at level 5!');
                },
              ),
              _CircularIconButton(
                icon: Iconsax.medal_star,
                label: AppStrings.homeMyBadges,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AchievementsScreen()));
                },
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ModuleDetailScreen(module: module)));
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.accentYellow,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.all(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Center(
                          child: Text(
                            AppStrings.homeContinueLearning,
                            style: TextStyle(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryDark,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Iconsax.play, color: Colors.white70, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Helper for circular buttons
class _CircularIconButton extends StatelessWidget {
  const _CircularIconButton({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(25),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(color: AppColors.primaryDark, shape: BoxShape.circle),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white70, size: 20),
                  const SizedBox(height: 4),
                  Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textGrey, fontSize: 9)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// WIDGET 3: Header text
class _QuickModulesSection extends StatelessWidget {
  const _QuickModulesSection();
  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 500),
      delay: const Duration(milliseconds: 300),
      child: Text(
        AppStrings.homeQuickModules,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// WIDGET 4: Bottom Info Cards (Live Data)
class _BottomInfoRow extends StatelessWidget {
  const _BottomInfoRow();

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 200),
      delay: const Duration(milliseconds: 50),
      child: Row(
        children: [
          // Badges Card
          Expanded(
            child: BlocBuilder<BadgeBloc, BadgeState>(
              builder: (context, state) {
                String count = '0';
                if (state is BadgeDataLoaded) {
                  count = state.earnedBadges.length.toString();
                }
                return _BottomInfoCard(
                  title: AppStrings.homeMyBadges,
                  icon: Iconsax.medal_star,
                  chipText: '$count Unlocked',
                  backgroundColor: AppColors.accentYellow,
                  chipColor: AppColors.primaryDark,
                  chipTextColor: AppColors.white,
                  iconColor: AppColors.primaryDark,
                  textColor: AppColors.primaryDark,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AchievementsScreen()));
                  },
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          // Resources Card
          Expanded(
            child: BlocBuilder<ResourceBloc, ResourceState>(
              builder: (context, state) {
                String count = '0';
                if (state is ResourceDisplaySuccess) {
                  count = state.resources.length.toString();
                }
                return _BottomInfoCard(
                  title: AppStrings.homeResourceHub,
                  icon: Iconsax.archive_book,
                  chipText: '$count Resources',
                  backgroundColor: AppColors.cardBlue,
                  chipColor: AppColors.primaryLight,
                  chipTextColor: Colors.white,
                  iconColor: AppColors.primaryDark,
                  textColor: AppColors.primaryDark,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ResourcesScreen()));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomInfoCard extends StatelessWidget {
  const _BottomInfoCard({
    required this.title, required this.icon, required this.chipText,
    required this.backgroundColor, required this.chipColor, required this.chipTextColor,
    required this.iconColor, required this.textColor, required this.onTap,
  });

  final String title;
  final IconData icon;
  final String chipText;
  final Color backgroundColor;
  final Color chipColor;
  final Color chipTextColor;
  final Color iconColor;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 36, color: iconColor),
            Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: textColor, fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: chipColor, borderRadius: BorderRadius.circular(20)),
              child: Text(chipText, style: TextStyle(color: chipTextColor, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

// WIDGET 5: Module Status Section (Live Filtered Lists)
class _ModuleStatusSection extends StatefulWidget {
  const _ModuleStatusSection();
  @override
  State<_ModuleStatusSection> createState() => _ModuleStatusSectionState();
}

class _ModuleStatusSectionState extends State<_ModuleStatusSection> {
  int _selectedTabIndex = 0; // 0 = In Progress, 1 = Completed

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.homeModules,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _TabButton(
                label: AppStrings.homeInProgress,
                isSelected: _selectedTabIndex == 0,
                onTap: () => setState(() => _selectedTabIndex = 0),
              ),
              const SizedBox(width: 12),
              _TabButton(
                label: AppStrings.homeCompleted,
                isSelected: _selectedTabIndex == 1,
                onTap: () => setState(() => _selectedTabIndex = 1),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // BlocBuilder to filter lists
          BlocBuilder<ModuleBloc, ModuleState>(
            builder: (context, state) {
              if (state is ModuleLoading) return const Center(child: CircularProgressIndicator());
              if (state is ModuleLoaded) {

                // Filter Logic
                final inProgress = state.modules.where((m) => m.percentComplete > 0 && m.percentComplete < 1.0).toList();
                final completed = state.modules.where((m) => m.percentComplete == 1.0).toList();

                // Also show "Not Started" in the In Progress tab for better UX
                final notStarted = state.modules.where((m) => m.percentComplete == 0).toList();
                final displayInProgress = [...inProgress, ...notStarted];

                final listToShow = _selectedTabIndex == 0 ? displayInProgress : completed;

                if (listToShow.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(child: Text("No modules found here.", style: TextStyle(color: Colors.white.withOpacity(0.5)))),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listToShow.length,
                  separatorBuilder: (_,__) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final mod = listToShow[index];
                    return _ModuleStatusCard(
                      module: mod,
                      isCompletedTab: _selectedTabIndex == 1,
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({required this.label, required this.isSelected, required this.onTap});
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentYellow : AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: TextStyle(color: isSelected ? AppColors.primaryDark : Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _ModuleStatusCard extends StatelessWidget {
  final ModuleModel module;
  final bool isCompletedTab;

  const _ModuleStatusCard({required this.module, required this.isCompletedTab});

  @override
  Widget build(BuildContext context) {
    final statusText = isCompletedTab ? "Completed" : (module.percentComplete == 0 ? "Not Started" : "In Progress");
    final statusColor = isCompletedTab ? AppColors.statusGreen : (module.percentComplete == 0 ? Colors.grey : AppColors.accentYellow);

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ModuleDetailScreen(module: module)));
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(color: AppColors.cardBlue, shape: BoxShape.circle),
              child: ClipOval(
                child: module.imageUrl != null
                    ? Image.network(module.imageUrl!, fit: BoxFit.cover, errorBuilder: (_,__,___) => Icon(Iconsax.document, color: AppColors.primaryDark))
                    : Icon(Iconsax.document, color: AppColors.primaryDark, size: 28),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    module.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primaryDark, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  Text(statusText, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 24, height: 24,
              child: Center(
                child: isCompletedTab
                    ? Icon(Icons.check_circle, color: AppColors.statusGreen, size: 24)
                    : CircularProgressIndicator(
                  value: module.percentComplete == 0 ? 0.05 : module.percentComplete, // Show a tiny bit if 0
                  color: AppColors.primaryDark,
                  backgroundColor: AppColors.textGrey.withOpacity(0.3),
                  strokeWidth: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}