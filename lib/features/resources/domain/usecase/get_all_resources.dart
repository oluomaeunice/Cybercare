
import 'package:cybercare/core/error/failures.dart';
import 'package:cybercare/core/usecase_interface/usecase.dart';
import 'package:cybercare/features/resources/domain/entity/resource_entity.dart';
import 'package:cybercare/features/resources/domain/repositories/resource_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllResources implements UseCase<List<ResourcePost>, NoParams>{
  final ResourceRepository resourceRepository;
  GetAllResources(this.resourceRepository);

  @override
  Future<Either<Failure, List<ResourcePost>>> call(NoParams params) async{
    return await resourceRepository.getAllResource();
  }
}