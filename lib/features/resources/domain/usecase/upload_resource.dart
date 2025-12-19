import 'dart:io';
import 'package:cybercare/core/error/failures.dart';
import 'package:cybercare/core/usecase_interface/usecase.dart';
import 'package:cybercare/features/resources/domain/entity/resource_entity.dart';
import 'package:cybercare/features/resources/domain/repositories/resource_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadResource implements UseCase<ResourcePost, UploadResourceParams> {
  final ResourceRepository resourceRepository;

  UploadResource(this.resourceRepository);

  @override
  Future<Either<Failure, ResourcePost>> call(UploadResourceParams params) async {
    return await resourceRepository.uploadResource(
      image: params.image,
      title: params.title,
      description: params.description, // Added
      content: params.content,
      type: params.type,
      pdfFile: params.pdfFile,
    );
  }
}

class UploadResourceParams {
  final File image;
  final String title;
  final String description;
  final String content;
  final String type;
  final File? pdfFile;

  UploadResourceParams({
    required this.image,
    required this.title,
    required this.description,
    required this.content,
    required this.type,this.pdfFile,
  });
}
