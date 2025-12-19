
import 'package:cybercare/core/common/entities/user.dart';
import 'package:cybercare/core/error/failures.dart';
import 'package:cybercare/core/usecase_interface/usecase.dart';
import 'package:cybercare/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
class CurrentUser implements UseCase<User, NoParams>{
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);
  @override
  Future<Either<Failure, User>> call(NoParams params) async{
  return await authRepository.currentUser();
  }

}
