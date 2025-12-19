


import 'package:cybercare/core/usecase_interface/usecase.dart';
import 'package:cybercare/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:cybercare/core/common/entities/user.dart';
import 'package:cybercare/core/error/failures.dart';

class UserLogin implements UseCase<User, UserLoginParams>{
  final AuthRepository authRepository;
  const UserLogin(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
      return await authRepository.loginWithEmailPassword(email: params.email, password: params.password);
  }
}
class UserLoginParams{
  final String email;
  final String password;

  UserLoginParams({required this.email, required this.password});


}