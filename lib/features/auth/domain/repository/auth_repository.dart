import 'dart:io';

import 'package:cybercare/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';
import 'package:cybercare/core/common/entities/user.dart';

abstract interface class AuthRepository {

  Future<Either<Failure, User>> signUpWithEmailPassword(
      {required String name, required String email, required String password});

  Future<Either<Failure, User>> loginWithEmailPassword(
      {required String email, required String password});

  Future<Either<Failure, User>> currentUser();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, User>> updateProfile({
    required String userId,
    required String name,
    File? image,
  });

  Future<Either<Failure, void>> forgotPassword(String email);
}
