import 'dart:io';

import 'package:cybercare/features/modules/moduledata/models/module_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ModuleRepository {
  final SupabaseClient supabase;

  ModuleRepository(this.supabase);

  // --- 1. UPLOAD MODULE CONTAINER ---
  Future<String> createModule({
    required ModuleModel module,
    required File coverImage,
  }) async {
    try {
      // A. Upload Cover Image
      final imagePath = 'modules/covers/${const Uuid().v4()}.jpg';
      await supabase.storage.from('courses').upload(imagePath, coverImage);
      final imageUrl = supabase.storage.from('courses').getPublicUrl(imagePath);

      // B. Insert Module Data
      final response = await supabase.from('modules').insert({
        ...module.toJson(),
        'image_url': imageUrl,
      }).select().single();

      return response['id']; // Return the new Module ID
    } catch (e) {
      throw Exception('Failed to create module: $e');
    }
  }

  // --- 2. UPLOAD TOPIC (With Optional Video) ---
  Future<void> addTopic({
    required TopicModel topic,
    File? videoFile,
  }) async {
    try {
      String? videoUrl;

      // A. Upload Video if it exists
      if (topic.type == 'video' && videoFile != null) {
        final videoPath = 'modules/videos/${topic.moduleId}/${const Uuid().v4()}.mp4';

        await supabase.storage.from('courses').upload(
          videoPath,
          videoFile,
          fileOptions: const FileOptions(contentType: 'video/mp4'),
        );

        videoUrl = supabase.storage.from('courses').getPublicUrl(videoPath);
      }

      // B. Insert Topic Data
      await supabase.from('topics').insert({
        ...topic.toJson(),
        'video_url': videoUrl,
      });
    } catch (e) {
      throw Exception('Failed to add topic: $e');
    }
  }

  Future<List<ModuleModel>> fetchModules() async {
    final userId = supabase.auth.currentUser!.id;

    try {
      // A. Get all modules
      final modulesData = await supabase
          .from('modules')
          .select()
          .order('created_at', ascending: false);

      List<ModuleModel> modules = [];

      for (var m in modulesData) {
        // B. Get Total Topics count (Returns int directly)
        final int totalTopics = await supabase
            .from('topics')
            .count(CountOption.exact)
            .eq('module_id', m['id']);

        // C. Get Completed Topics count (Returns int directly)
        final int completedTopics = await supabase
            .from('user_progress')
            .count(CountOption.exact)
            .eq('module_id', m['id'])
            .eq('user_id', userId);

        // D. Calculate Percentage
        double progress = 0.0;
        if (totalTopics > 0) {
          progress = completedTopics / totalTopics;
        }

        modules.add(ModuleModel.fromJson(m).copyWith(
          percentComplete: progress,
          totalTopics: totalTopics,
          completedTopics: completedTopics,
        ));
      }
      return modules;
    } catch (e) {
      throw Exception('Error fetching modules: $e');
    }
  }


  Future<List<TopicModel>> getTopicsForModule(String moduleId) async {
    final userId = supabase.auth.currentUser!.id;

    try {
      // A. Get all topics for this module, sorted by order
      final topicsData = await supabase
          .from('topics')
          .select()
          .eq('module_id', moduleId)
          .order('order_index', ascending: true);

      // B. Get user's progress for this module
      final progressData = await supabase
          .from('user_progress')
          .select('topic_id')
          .eq('module_id', moduleId)
          .eq('user_id', userId);

      // Create a Set of completed topic IDs for fast lookup
      final completedIds = progressData.map((e) => e['topic_id'] as String).toSet();

      // C. Map to models and set 'isCompleted'
      // Note: You need to add 'isCompleted' to your TopicModel first (see next step)
      return (topicsData as List).map((t) {
        final topic = TopicModel.fromJson(t);
        return topic.copyWith(isCompleted: completedIds.contains(topic.id));
      }).toList();
    } catch (e) {
      throw Exception('Failed to load topics: $e');
    }
  }

  Future<void> markTopicComplete(String moduleId, String topicId) async {
    final userId = supabase.auth.currentUser!.id;
    try {
      await supabase.from('user_progress').upsert({
        'user_id': userId,
        'module_id': moduleId,
        'topic_id': topicId,
        'completed_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to save progress: $e');
    }
  }

  Future<BadgeModel?> getBadgeForModule(String moduleId) async {
    try {
      final data = await supabase
          .from('badges')
          .select()
          .eq('module_id', moduleId)
          .maybeSingle(); // Returns null if no badge exists for this module

      if (data != null) {
        return BadgeModel.fromJson(data);
      }
      return null;
    } catch (e) {
      // Fail silently if badge fetch fails, it shouldn't break the app flow
      return null;
    }
  }

  // --- 7. AWARD BADGE (Insert into user_badges) ---
  Future<void> awardBadge(String moduleId) async {
    final userId = supabase.auth.currentUser!.id;
    try {
      // First find the badge ID
      final badgeData = await supabase
          .from('badges')
          .select('id')
          .eq('module_id', moduleId)
          .maybeSingle();

      if (badgeData != null) {
        // Insert into user_badges. Ignore if already exists (on conflict)
        await supabase.from('user_badges').upsert(
          {
            'user_id': userId,
            'badge_id': badgeData['id'],
            'earned_at': DateTime.now().toIso8601String(),
          },
          onConflict: 'user_id, badge_id', // Assuming you set a unique constraint in SQL
        );
      }
    } catch (e) {
      throw Exception('Failed to award badge: $e');
    }
  }

  Future<List<BadgeModel>> getAllBadges() async {
    try {
      final data = await supabase.from('badges').select();
      return (data as List).map((e) => BadgeModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load badges: $e');
    }
  }

  // --- 9. FETCH USER EARNED BADGES ---
  Future<List<BadgeModel>> getUserBadges() async {
    final userId = supabase.auth.currentUser!.id;
    try {
      // Join query: Get badges linked to the user_badges table
      final data = await supabase
          .from('user_badges')
          .select('badges(*)') // Select all fields from the linked 'badges' table
          .eq('user_id', userId);

      return (data as List)
          .map((e) => BadgeModel.fromJson(e['badges']))
          .toList();
    } catch (e) {
      throw Exception('Failed to load user badges: $e');
    }
  }

  // --- 10. FETCH MODULES WITHOUT BADGES (For Dropdown) ---
  Future<List<ModuleModel>> getModulesWithoutBadges() async {
    try {
      // 1. Get all modules
      final modules = await fetchModules(); // Reusing existing method

      // 2. Get all existing badge module_ids
      final badges = await supabase.from('badges').select('module_id');
      final assignedModuleIds = (badges as List).map((e) => e['module_id']).toSet();

      // 3. Filter: Return only modules whose ID is NOT in the assigned set
      return modules.where((m) => !assignedModuleIds.contains(m.id)).toList();
    } catch (e) {
      throw Exception('Error filtering modules: $e');
    }
  }

  // --- 11. CREATE BADGE ---
  Future<void> createBadge({
    required String name,
    required String description,
    required String moduleId,
    required File imageFile,
  }) async {
    try {
      // A. Upload Image
      final imagePath = 'badges/${const Uuid().v4()}.png';
      await supabase.storage.from('courses').upload(imagePath, imageFile);
      final imageUrl = supabase.storage.from('courses').getPublicUrl(imagePath);

      // B. Insert Badge
      await supabase.from('badges').insert({
        'name': name,
        'description': description,
        'module_id': moduleId,
        'image_url': imageUrl,
      });
    } catch (e) {
      throw Exception('Failed to create badge: $e');
    }
  }
}