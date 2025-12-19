// 1. The Module (The Container)
class ModuleModel {
  final String? id;
  final String title;
  final String description;
  final String difficulty; // 'Beginner', 'Intermediate', 'Advanced'
  final String duration;   // '2 Hours'
  final String? imageUrl;
  final DateTime? createdAt;
  final double percentComplete; // 0.0 to 1.0
  final int totalTopics;
  final int completedTopics;

  ModuleModel({
    this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.duration,
    this.imageUrl,
    this.createdAt,
    this.percentComplete = 0.0,
    this.totalTopics = 0,
    this.completedTopics = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'difficulty': difficulty,
      'duration': duration,
      'image_url': imageUrl,
      // 'id' and 'created_at' are handled by Supabase
    };
  }

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      difficulty: json['difficulty'],
      duration: json['duration'],
      imageUrl: json['image_url'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  ModuleModel copyWith({
    double? percentComplete,
    int? totalTopics,
    int? completedTopics,
  }) {
    return ModuleModel(
      id: id,
      title: title,
      description: description,
      difficulty: difficulty,
      duration: duration,
      imageUrl: imageUrl,
      percentComplete: percentComplete ?? this.percentComplete,
      totalTopics: totalTopics ?? this.totalTopics,
      completedTopics: completedTopics ?? this.completedTopics,
    );
  }
}

// 2. The Topic (The Lesson - Text OR Video)
// lib/features/modules/data/models/module_models.dart

class TopicModel {
  final String? id;
  final String moduleId;
  final String title;
  final String type; // 'text' or 'video'
  final String content; // Markdown text
  final String? videoUrl;
  final int orderIndex;
  final bool isCompleted;

  TopicModel({
    this.id,
    required this.moduleId,
    required this.title,
    required this.type,
    required this.content,
    this.videoUrl,
    required this.orderIndex,
    this.isCompleted = false,
  });

  // --- ADD THIS METHOD ---
  TopicModel copyWith({
    String? id,
    String? moduleId,
    String? title,
    String? type,
    String? content,
    String? videoUrl,
    int? orderIndex,
    bool? isCompleted,
  }) {
    return TopicModel(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      title: title ?? this.title,
      type: type ?? this.type,
      content: content ?? this.content,
      videoUrl: videoUrl ?? this.videoUrl,
      orderIndex: orderIndex ?? this.orderIndex,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
  // -----------------------

  Map<String, dynamic> toJson() {
    return {
      'module_id': moduleId,
      'title': title,
      'type': type,
      'content': content,
      'video_url': videoUrl,
      'order_index': orderIndex,
    };
  }

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'],
      moduleId: json['module_id'],
      title: json['title'],
      type: json['type'],
      content: json['content'],
      videoUrl: json['video_url'],
      orderIndex: json['order_index'],
      isCompleted: false, // Default is false, updated later via copyWith
    );
  }
}



class BadgeModel {
  final String name;
  final String imageUrl;
  final String? description;

  BadgeModel({
    required this.name,
    required this.imageUrl,
    this.description,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      name: json['name'] ?? 'Module Master',
      imageUrl: json['image_url'] ?? '',
      description: json['description'],
    );
  }
}