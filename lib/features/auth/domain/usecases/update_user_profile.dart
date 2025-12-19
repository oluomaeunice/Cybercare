import 'dart:io';
import 'package:cybercare/core/common/entities/user.dart';
import 'package:cybercare/core/error/failures.dart';
import 'package:cybercare/core/usecase_interface/usecase.dart';
import 'package:cybercare/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateUserProfile implements UseCase<User, UpdateProfileParams> {
  final AuthRepository authRepository;
  UpdateUserProfile(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UpdateProfileParams params) async {
    return await authRepository.updateProfile(
      userId: params.userId,
      name: params.name,
      image: params.image,
    );
  }
}

class UpdateProfileParams {
  final String userId;
  final String name;
  final File? image;
  UpdateProfileParams({required this.userId, required this.name, this.image});
}