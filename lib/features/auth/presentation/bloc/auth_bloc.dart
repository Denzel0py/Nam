import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namhockey/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:namhockey/core/common/entities/user_entity.dart';
import 'package:namhockey/core/usecase/use_case.dart';
import 'package:namhockey/features/auth/domain/usecase/get_all_users_use_case.dart';
import 'package:namhockey/features/auth/domain/usecase/get_current_user_details_use_case.dart';
import 'package:namhockey/features/auth/domain/usecase/log_in_use_case.dart';
import 'package:namhockey/features/auth/domain/usecase/log_out_use_case.dart';
import 'package:namhockey/features/auth/domain/usecase/make_coach_use_case.dart';
import 'package:namhockey/features/auth/domain/usecase/make_player_use_case.dart';
import 'package:namhockey/features/auth/domain/usecase/make_regular_user_use_case.dart';
import 'package:namhockey/features/auth/domain/usecase/sign_up_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase _signUpUseCase;
  final LogInUseCase _logInUseCase;
  final GetCurrentUserDetailsUseCase _getCurrentUserDetailsUseCase;
  final LogOutUseCase _logOutUseCase;
  final AppUserCubit _appUserCubit;
  final GetAllUsersUseCase _getAllUsersUseCase;
  final MakeCoachUseCase _makeCoachUseCase;
  final MakePlayerUseCase _makePlayerUseCase;
  final MakeRegularUserUseCase _makeRegularUserUseCase;
  
  AuthBloc({
    required SignUpUseCase signUpUseCase,
    required LogInUseCase logInUseCase,
    required GetCurrentUserDetailsUseCase getCurrentUserDetailsUseCase,
    required LogOutUseCase logOutUseCase,
    required GetAllUsersUseCase getAllUsersUseCase,
    required MakeCoachUseCase makeCoachUseCase,
    required MakePlayerUseCase makePlayerUseCase,
    required MakeRegularUserUseCase makeRegularUserUseCase,
    required AppUserCubit appUserCubit,
  })  : _signUpUseCase = signUpUseCase,
        _logInUseCase = logInUseCase,
        _getCurrentUserDetailsUseCase = getCurrentUserDetailsUseCase,
        _logOutUseCase = logOutUseCase,
        _getAllUsersUseCase = getAllUsersUseCase,
        _makeCoachUseCase = makeCoachUseCase,
        _makePlayerUseCase = makePlayerUseCase,
        _makeRegularUserUseCase = makeRegularUserUseCase,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    
    on<AuthSignUpEvent>(_onAuthSignUp);
    on<AuthLogInEvent>(_onAuthLogIn);
    on<AuthGetUserDetailsEvent>(_onAuthGetUserData);
    on<AuthLogOutEvent>(_onAuthLogOut);
    on<GetAllUsersEvent>(_onGetAllUsers);
    on<MakeCoachEvent>(_onMakeCoach);
    on<MakePlayerEvent>(_onMakePlayer);
    on<MakeRegularUserEvent>(_onMakeRegularUser);
  }

  void _onAuthSignUp (AuthSignUpEvent event, Emitter<AuthState> emit) async {
    final res = await _signUpUseCase(SignUpParams(name: event.name, email: event.email, password: event.password, role: event.role));
    
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _onAuthLogIn (AuthLogInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _logInUseCase(LogInParams(email: event.email, password: event.password));
    
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

void _onAuthGetUserData (AuthGetUserDetailsEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _getCurrentUserDetailsUseCase(NoParams());
    
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _onAuthLogOut(AuthLogOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _logOutUseCase(NoParams());
    
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) {
        _appUserCubit.updateUser(null);
        emit(AuthInitial());
      },
    );
  }

  void _emitAuthSuccess (UserEntity user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }

  void _onGetAllUsers(GetAllUsersEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _getAllUsersUseCase(NoParams());
    
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(UsersLoaded(r)),
    );
  }

  void _onMakeCoach(MakeCoachEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _makeCoachUseCase(MakeCoachParams(
      userId: event.userId,
      teamName: event.teamName,
      teamLogoPath: event.teamLogo.path,
    ));

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) async {
        // If the current user was made a coach, refresh their session
        if (user.id == (_appUserCubit.state as AppUserLoggedIn).user.id) {
          await _getCurrentUserDetailsUseCase(NoParams()).then((res) {
            res.fold(
              (l) => emit(AuthFailure(l.message)),
              (r) => _emitAuthSuccess(r, emit),
            );
          });
        } else {
          emit(AuthSuccess(user));
        }
      },
    );
  }

  void _onMakePlayer(MakePlayerEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _makePlayerUseCase(MakePlayerParams(
      userId: event.userId,
      teamId: event.teamId,
    ));

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  void _onMakeRegularUser(MakeRegularUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _makeRegularUserUseCase(MakeRegularUserParams(
      userId: event.userId,
    ));

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }
}