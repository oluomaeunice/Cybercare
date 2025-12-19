import 'dart:io';

import 'package:cybercare/core/error/exceptions.dart';
import 'package:cybercare/core/error/failures.dart';
import 'package:cybercare/features/resources/data/datasources/remote_data_source.dart';
import 'package:cybercare/features/resources/data/resourcemodel/resource_model.dart';
import 'package:cybercare/features/resources/domain/entity/resource_entity.dart';
import 'package:cybercare/features/resources/domain/repositories/resource_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class ResourceRepositoryImplementation implements ResourceRepository {
  final ResourceRemoteDataSource resourceRemoteDataSource;

  ResourceRepositoryImplementation(this.resourceRemoteDataSource);

  @override
  Future<Either<Failure, ResourcePost>> uploadResource({
    required File image,
    required String title,
    required String description,
    required String content,
    required String type,
    File? pdfFile, // <--- NEW
  }) async {
    try {
      // Initialize Model
      ResourceModel resourceModel = ResourceModel(
        id: const Uuid().v1(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        title: title,
        description: description,
        type: type,
        content: content,
        imageUrl: '',
        fileUrl: null,
      );

      final imageUrl = await resourceRemoteDataSource.uploadResourceImage(
        image: image,
        resources: resourceModel,
      );
      resourceModel = resourceModel.copyWith(imageUrl: imageUrl);

      if (type == 'pdf' && pdfFile != null) {
        final pdfUrl = await resourceRemoteDataSource.uploadResourcePdf(
            pdf: pdfFile,
            resources: resourceModel
        );
        resourceModel = resourceModel.copyWith(fileUrl: pdfUrl);
      }


      final uploadedResource = await resourceRemoteDataSource.uploadResource(resourceModel);

      return right(uploadedResource);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ResourcePost>>> getAllResource() async {
    try {
      final resource = await resourceRemoteDataSource.getAllResource();
      return right(resource);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }catch (e) {
      return left(Failure('Unexpected error: ${e.toString()}'));
    }
  }
}
