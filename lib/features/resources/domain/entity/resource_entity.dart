

class ResourcePost {
  final String id;
  final String title;
  final String description;
  final String type;
  final String content;
  final String imageUrl;
  final String? fileUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ResourcePost({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.content,
    required this.imageUrl,
    this.fileUrl,
    required this.createdAt,
    required this.updatedAt,
  });
}
