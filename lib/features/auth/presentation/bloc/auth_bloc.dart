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
import 'package:namhockey/features/auth/domain/usecase/update_profile_use_case.dart';

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
  final UpdateProfileUseCase _updateProfileUseCase;

  AuthBloc({
    required SignUpUseCase signUpUseCase,
    required LogInUseCase logInUseCase,
    required GetCurrentUserDetailsUseCase getCurrentUserDetailsUseCase,
    required LogOutUseCase logOutUseCase,
    required GetAllUsersUseCase getAllUsersUseCase,
    required MakeCoachUseCase makeCoachUseCase,
    required MakePlayerUseCase makePlayerUseCase,
    required MakeRegularUserUseCase makeRegularUserUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required AppUserCubit appUserCubit,
  }) : _signUpUseCase = signUpUseCase,
       _logInUseCase = logInUseCase,
       _getCurrentUserDetailsUseCase = getCurrentUserDetailsUseCase,
       _logOutUseCase = logOutUseCase,
       _getAllUsersUseCase = getAllUsersUseCase,
       _makeCoachUseCase = makeCoachUseCase,
       _makePlayerUseCase = makePlayerUseCase,
       _makeRegularUserUseCase = makeRegularUserUseCase,
       _updateProfileUseCase = updateProfileUseCase,
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
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  void _onAuthSignUp(AuthSignUpEvent event, Emitter<AuthState> emit) async {
    final res = await _signUpUseCase(
      SignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
        role: event.role,
      ),
    );

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _onAuthLogIn(AuthLogInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _logInUseCase(
      LogInParams(email: event.email, password: event.password),
    );

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _onAuthGetUserData(
    AuthGetUserDetailsEvent event,
    Emitter<AuthState> emit,
  ) async {
    print('AuthBloc: Starting to get user data');
    emit(AuthLoading());

    try {
      final res = await _getCurrentUserDetailsUseCase(NoParams());
      print('AuthBloc: Got user data result');

      res.fold(
        (l) {
          print('AuthBloc: Error getting user data - ${l.message}');
          emit(AuthFailure(l.message));
        },
        (r) {
          print('AuthBloc: Successfully got user data');
          _emitAuthSuccess(r, emit);
        },
      );
    } catch (e) {
      print('AuthBloc: Exception getting user data - $e');
      emit(AuthFailure(e.toString()));
    }
  }

  void _onAuthLogOut(AuthLogOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _logOutUseCase(NoParams());

    res.fold((l) => emit(AuthFailure(l.message)), (r) {
      _appUserCubit.updateUser(null);
      emit(AuthInitial());
    });
  }

  void _emitAuthSuccess(UserEntity user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }

  void _onGetAllUsers(GetAllUsersEvent event, Emitter<AuthState> emit) async {
    try {
      final res = await _getAllUsersUseCase(NoParams());
      if (!emit.isDone) {
        res.fold(
          (l) => emit(AuthFailure(l.message)),
          (r) => emit(UsersLoaded(r)),
        );
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(AuthFailure(e.toString()));
      }
    }
  }

  void _onMakeCoach(MakeCoachEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _makeCoachUseCase(
      MakeCoachParams(
        userId: event.userId,
        teamName: event.teamName,
        teamLogoPath: event.teamLogo.path,
      ),
    );

    result.fold((failure) => emit(AuthFailure(failure.message)), (user) async {
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
    });
  }

  void _onMakePlayer(MakePlayerEvent event, Emitter<AuthState> emit) async {
    print('AuthBloc: Starting make player process');
    emit(AuthLoading());

    try {
      final result = await _makePlayerUseCase(
        MakePlayerParams(userId: event.userId, teamId: event.teamId),
      );

      print('AuthBloc: Got make player result');

      await result.fold(
        (failure) async {
          print('AuthBloc: Error making player - ${failure.message}');
          if (!emit.isDone) {
            emit(AuthFailure(failure.message));
          }
        },
        (user) async {
          print('AuthBloc: Successfully made player, fetching updated users');
          // Fetch updated users list
          final usersResult = await _getAllUsersUseCase(NoParams());
          if (!emit.isDone) {
            usersResult.fold(
              (l) {
                print('AuthBloc: Error fetching users - ${l.message}');
                emit(AuthFailure(l.message));
              },
              (r) {
                print('AuthBloc: Successfully fetched updated users');
                emit(UsersLoaded(r));
              },
            );
          }
        },
      );
    } catch (e) {
      print('AuthBloc: Exception making player - $e');
      if (!emit.isDone) {
        emit(AuthFailure(e.toString()));
      }
    }
  }

  void _onMakeRegularUser(
    MakeRegularUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _makeRegularUserUseCase(
      MakeRegularUserParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  void _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _updateProfileUseCase(
      UpdateProfileParams(
        name: event.name,
        email: event.email,
        profilePicturePath: event.profilePicturePath,
      ),
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }
}
