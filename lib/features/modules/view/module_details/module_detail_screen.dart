import 'package:cybercare/core/constants/app_colors.dart';
import 'package:cybercare/features/modules/moduledata/models/module_model.dart';
import 'package:cybercare/features/modules/moduledata/repository/module_repository.dart';
import 'package:cybercare/features/modules/view/module_details/badge_reveal_dialog.dart';
import 'package:cybercare/features/modules/view/module_details/topic_view.dart';
import 'package:cybercare/features/modules/view/modulebloc/module_details_bloc.dart';
import 'package:cybercare/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';

class ModuleDetailScreen extends StatelessWidget {
  final ModuleModel module;

  const ModuleDetailScreen({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    // Providing Bloc locally since it's specific to this screen
    return BlocProvider(
      create: (_) => ModuleDetailBloc(ModuleRepository(serviceLocator()))
        ..add(LoadModuleDetails(module.id!)),
      child: BlocListener<ModuleDetailBloc, ModuleDetailState>(
        listener: (context, state) {
          if (state is ModuleDetailLoaded && state.newlyEarnedBadge != null) {
            // Trigger the celebration!
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => BadgeRevealDialog(badge: state.newlyEarnedBadge!),
            );
          }
        },
  child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // 1. Sliver App Bar with Image
            _buildSliverAppBar(context),
            
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressSection(),
                    const SizedBox(height: 20),
                    _buildTabs(),
                    const SizedBox(height: 20),
                    _buildTopicList(context),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildContinueButton(context),
      ),
),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250.0,
      backgroundColor: AppColors.primaryDark,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (module.imageUrl != null)
              Image.network(module.imageUrl!, fit: BoxFit.cover)
            else
              Container(color: Colors.grey),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    module.title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Iconsax.clock, color: Colors.white70, size: 16),
                      const SizedBox(width: 4),
                      Text(module.duration, style: const TextStyle(color: Colors.white70)),
                      const SizedBox(width: 16),
                      const Icon(Iconsax.level, color: Colors.white70, size: 16),
                      const SizedBox(width: 4),
                      Text(module.difficulty, style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    return BlocBuilder<ModuleDetailBloc, ModuleDetailState>(
      builder: (context, state) {
        double progress = 0;
        if (state is ModuleDetailLoaded) progress = state.progress;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Course Progress", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${(progress * 100).toInt()}% Completed"),
              ],
            ),
            const SizedBox(height: 8),
            LinearPercentIndicator(
              lineHeight: 8.0,
              percent: progress,
              backgroundColor: Colors.grey.shade200,
              progressColor: progress == 1.0 ? Colors.green : AppColors.accentYellow,
              barRadius: const Radius.circular(10),
              padding: EdgeInsets.zero,
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopicList(BuildContext context) {
    return BlocBuilder<ModuleDetailBloc, ModuleDetailState>(
      builder: (context, state) {
        if (state is ModuleDetailLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ModuleDetailLoaded) {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.topics.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final topic = state.topics[index];
              return _TopicTile(
                topic: topic,
                index: index + 1,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TopicViewerScreen(topic: topic)),
                  );
                  // When they come back, mark as complete
                  context.read<ModuleDetailBloc>().add(MarkTopicCompleted(module.id!, topic.id!));
                },
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildContinueButton(BuildContext parentContext) {
    return BlocBuilder<ModuleDetailBloc, ModuleDetailState>(
      builder: (context, state) {
        if (state is ModuleDetailLoaded) {
          // Find first uncompleted topic
          final nextTopic = state.topics.firstWhere(
                (t) => !t.isCompleted,
            orElse: () => state.topics.last, // Or handle "All Done" logic
          );

          final isAllDone = state.progress == 1.0;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Logic to open nextTopic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isAllDone ? Colors.green : AppColors.primaryDark,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                isAllDone ? "Download Certificate" : "Continue Learning",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        _TabButton(text: "Modules", isSelected: true),
        const SizedBox(width: 16),
        _TabButton(text: "Description", isSelected: false),
        const SizedBox(width: 16),
        _TabButton(text: "Certificates", isSelected: false),
      ],
    );
  }
}

class _TopicTile extends StatelessWidget {
  final TopicModel topic;
  final int index;
  final VoidCallback onTap;

  const _TopicTile({required this.topic, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: topic.isCompleted ? Colors.green.shade100 : Colors.grey.shade100,
          child: topic.isCompleted
              ? const Icon(Icons.check, color: Colors.green)
              : Text("$index", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
        ),
        title: Text(topic.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(topic.type == 'video' ? "Video Lesson" : "Reading Material"),
        trailing: Icon(
            topic.isCompleted ? Iconsax.unlock : Iconsax.lock,
            color: topic.isCompleted ? Colors.green : Colors.grey
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  const _TabButton({required this.text, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryDark : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300),
      ),
      child: Text(
        text,
        style: TextStyle(color: isSelected ? Colors.white : Colors.grey),
      ),
    );
  }
}