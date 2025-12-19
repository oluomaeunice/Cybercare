part of 'resource_bloc.dart';
@immutable
sealed class ResourceEvent {}

final class ResourceUploadEvent extends ResourceEvent {
  final File image;
  final String title;
  final String description; // Added
  final String content;
  final String type;
  final File? pdfFile; // Added

  ResourceUploadEvent({
    required this.image,
    required this.title,
    required this.description,
    required this.content,
    required this.type,
    this.pdfFile,
  });
}

final class FetchAllResources extends ResourceEvent{

}