import 'package:cybercare/features/resources/domain/entity/resource_entity.dart';

class ResourceModel extends ResourcePost {
    ResourceModel({
        required super.id,
        required super.title,
        required super.description,
        required super.type,
        required super.content,
        required super.imageUrl,
        super.fileUrl,
        required super.createdAt,
        super.updatedAt,
    });

    factory ResourceModel.fromJson(Map<String, dynamic> json) {
        return ResourceModel(
            id: json['id'] ?? '',
            title: json['title'] ?? '',
            description: json['description'] ?? '',
            type: json['type'] ?? 'article', // Default fallback
            content: json['content'] ?? '',
            imageUrl: json['image_url'] ?? '',
            fileUrl: json['file_url'], // This is nullable
            createdAt: json['created_at'] == null
                ? DateTime.now()
                : DateTime.parse(json['created_at']),
            updatedAt: json['updated_at'] == null
                ? null
                : DateTime.parse(json['updated_at']),
        );
    }

    // Convert to JSON (e.g., when sending data to Supabase)
    Map<String, dynamic> toJson() {
        return {
            'id': id,
            'title': title,
            'description': description,
            'type': type,
            'content': content,
            'image_url': imageUrl,
            'file_url': fileUrl,
            'created_at': createdAt.toIso8601String(),
            'updated_at': updatedAt?.toIso8601String(),
        };
    }

    // Create a copy with updated values
    ResourceModel copyWith({
        String? id,
        String? title,
        String? description,
        String? type,
        String? content,
        String? imageUrl,
        String? fileUrl,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) {
        return ResourceModel(
            id: id ?? this.id,
            title: title ?? this.title,
            description: description ?? this.description,
            type: type ?? this.type,
            content: content ?? this.content,
            imageUrl: imageUrl ?? this.imageUrl,
            fileUrl: fileUrl ?? this.fileUrl,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );
    }
}