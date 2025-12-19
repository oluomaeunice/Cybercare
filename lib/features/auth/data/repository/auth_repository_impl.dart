
import 'dart:io';

import 'package:cybercare/core/common/entities/user.dart';
import 'package:cybercare/core/error/exceptions.dart';
import 'package:cybercare/core/error/failures.dart';
import 'package:cybercare/core/network/connection_checker.dart';
import 'package:cybercare/features/auth/data/datasources/auth_supabase.dart';
import 'package:cybercare/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImplementation implements AuthRepository{
  final AuthRemoteDataSource remoteDataSource;
final ConnectionChecker connectionChecker;
  AuthRepositoryImplementation(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, User>> currentUser() async{
    try{
      if(!await (connectionChecker.isConnected)){
          return left(Failure('User not logged in!'));
      }
      final user = await remoteDataSource.getCurrentUserData();
      if(user == null){
        return left(Failure('User not logged in!'));
      }
      return right(user);
    }on ServerException catch(e){
      throw ServerException(e.toString());
    }

  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({required String email, required String password}) async{
    //wrapper functions
    return _getUser( () async => await remoteDataSource.loginWithEmailPassword(email: email, password: password));
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({required String name, required String email, required String password}) async{

    //wrapper functions
      return _getUser( () async => await remoteDataSource.signUpWithEmailPassword(name: name, email: email, password: password));
  }

  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async{
    try{
      if(!await (connectionChecker.isConnected)){
        return Either.left(Failure('No Internet Connection'));
      }
      final user = await fn();
      return right(user);
    }on ServerException catch(e){
      return Either.left(Failure(e.message));
    }
  }


  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // We generally allow logout even if internet is shaky, but good to check
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No internet connection'));
      }
      await remoteDataSource.signOut();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    required String userId,
    required String name,
    File? image
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No Internet Connection'));
      }
      final user = await remoteDataSource.updateProfile(
          userId: userId,
          name: name,
          imageFile: image
      );
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No Internet Connection'));
      }
      await remoteDataSource.sendPasswordResetEmail(email);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
