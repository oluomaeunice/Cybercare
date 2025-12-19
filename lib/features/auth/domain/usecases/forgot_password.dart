import 'package:cybercare/core/error/failures.dart';
import 'package:cybercare/core/usecase_interface/usecase.dart';
import 'package:cybercare/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class ForgotPassword implements UseCase<void, String> {
  final AuthRepository authRepository;
  ForgotPassword(this.authRepository);

  @override
  Future<Either<Failure, void>> call(String email) async {
    return await authRepository.forgotPassword(email);
  }
}