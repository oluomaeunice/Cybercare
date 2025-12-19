import 'dart:async';
import 'dart:io';

import 'package:cybercare/core/common/cubits/app_user.dart';
import 'package:cybercare/core/common/entities/user.dart';
import 'package:cybercare/core/usecase_interface/usecase.dart';
import 'package:cybercare/features/auth/domain/usecases/current_user.dart';
import 'package:cybercare/features/auth/domain/usecases/forgot_password.dart';
import 'package:cybercare/features/auth/domain/usecases/update_user_profile.dart';
import 'package:cybercare/features/auth/domain/usecases/user_login.dart';
import 'package:cybercare/features/auth/domain/usecases/user_logout.dart';
import 'package:cybercare/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  final UpdateUserProfile _updateUserProfile; // Add this
  final ForgotPassword _forgotPassword;
  final UserLogout _userLogout;

  AuthBloc(
      {required UserSignUp userSignUp,
      required UserLogin userLogin,
      required CurrentUser currentUser,
      required AppUserCubit appUserCubit,
        required UpdateUserProfile updateUserProfile,
        required ForgotPassword forgotPassword,
        required UserLogout userLogout,})
      : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        _updateUserProfile = updateUserProfile,
        _forgotPassword = forgotPassword,
        _userLogout = userLogout,
        super(AuthInitial()) {
    on<AuthEvent>((_,emit)=>emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<AuthLogout>(_onAuthLogout);
    on<AuthUpdateProfile>(_onUpdateProfile);
    on<AuthForgotPassword>(_onForgotPassword);
  }

  _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    final res = await _userSignUp(UserSignUpParams(
        name: event.name, email: event.email, password: event.password));

    res.fold(
          (l) => emit(AuthFailure(l.message)),
          (user) => emit(AuthSignUpSuccess()), // Emit specific state
    );
  }

  _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final res = await _userLogin(
        UserLoginParams(email: event.email, password: event.password));

    res.fold(
          (l) => emit(AuthFailure(l.message)),
          (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _isUserLoggedIn(
      AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    final res = await _currentUser(NoParams());
    res.fold((l) => emit(AuthFailure(l.message)),
        (user) => _emitAuthSuccess(user, emit));
  }

  _onAuthLogout(AuthLogout event, Emitter<AuthState> emit) async {
    final res = await _userLogout(NoParams());
    res.fold(
          (l) => emit(AuthFailure(l.message)),
          (_) {
        _appUserCubit.updateUser(null); // Clear the global user state
        emit(AuthInitial()); // Reset auth state
      },
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }


  void _onUpdateProfile(AuthUpdateProfile event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _updateUserProfile(UpdateProfileParams(
        userId: event.userId,
        name: event.name,
        image: event.image
    ));

    res.fold(
          (l) => emit(AuthFailure(l.message)),
          (user) => _emitAuthSuccess(user, emit), // Use your existing helper
    );
  }

  void _onForgotPassword(AuthForgotPassword event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _forgotPassword(event.email);

    res.fold(
          (l) => emit(AuthFailure(l.message)),
          (_) => emit(AuthForgotPasswordSuccess()),
    );
  }
}
