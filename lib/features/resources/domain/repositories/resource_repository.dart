import 'dart:io';

import 'package:cybercare/core/error/failures.dart';
import 'package:cybercare/features/resources/domain/entity/resource_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ResourceRepository {
  Future<Either<Failure, ResourcePost>> uploadResource({
    required File image,
    required String title,
    required String description, // Added
    required String content,
    required String type,
    File? pdfFile,        // Added
  });

  Future<Either<Failure, List<ResourcePost>>> getAllResource();
}