import 'package:get_it/get_it.dart';
import 'package:namhockey/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:namhockey/core/secrets/app_secrets.dart';
import 'package:namhockey/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:namhockey/features/auth/data/repository/auth_repository_impl.dart';
import 'package:namhockey/features/auth/domain/repository/auth_repository.dart';
import 'package:namhockey/features/auth/domain/usecase/get_all_users_use_case.dart';
import 'package:namhockey/features/auth/domain/usecase/get_current_user_details_use_case.dart';
import 'package:namhockey/features/auth/domain/usecase/log_in_use_case.dart';
import 'package:namhockey/features/auth/domain/usecase/log_out_use_case.dart';
import 'package:namhockey/features/auth/domain/usecase/make_coach_use_case.dart';
import 'package:namhockey/features/auth/domain/usecase/make_player_use_case.dart';
import 'package:namhockey/features/auth/domain/usecase/make_regular_user_use_case.dart';
import 'package:namhockey/features/auth/domain/usecase/sign_up_use_case.dart';
import 'package:namhockey/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:namhockey/features/discussion/data/datasources/discussion_remote_source.dart';
import 'package:namhockey/features/discussion/data/repository/discussion_repository_impl.dart';
import 'package:namhockey/features/discussion/domain/repository/discussion_repository.dart';
import 'package:namhockey/features/discussion/domain/usecase/get_messages_usecase.dart';
import 'package:namhockey/features/discussion/domain/usecase/send_message_usecase.dart';
import 'package:namhockey/features/discussion/presentation/bloc/discussion_bloc.dart';
import 'package:namhockey/features/games/data/datasources/games_remote_source.dart';
import 'package:namhockey/features/games/data/repository/game_repository_impl.dart';
import 'package:namhockey/features/games/domain/repository/game_repository.dart';
import 'package:namhockey/features/games/domain/usecase/get_games_usecase.dart';
import 'package:namhockey/features/games/domain/usecase/make_games_usecase.dart';
import 'package:namhockey/features/games/presentation/bloc/games_bloc.dart';
import 'package:namhockey/features/news/data/datasource/news_remote_data_source.dart';
import 'package:namhockey/features/news/data/repository/news_repository_impl.dart';
import 'package:namhockey/features/news/domain/repository/news_repository.dart';
import 'package:namhockey/features/news/domain/usecase/add_news_usecase.dart';
import 'package:namhockey/features/news/domain/usecase/get_news_usecase.dart';
import 'package:namhockey/features/news/domain/usecase/delete_news_usecase.dart';
import 'package:namhockey/features/news/presentation/bloc/news_bloc.dart';
import 'package:namhockey/features/teams/data/datasources/team_remote_source.dart';
import 'package:namhockey/features/teams/data/repository/team_repository_impl.dart';
import 'package:namhockey/features/teams/domain/repository/team_repository.dart';
import 'package:namhockey/features/teams/domain/usecase/get_team_name_usecase.dart';
import 'package:namhockey/features/teams/presentation/bloc/team_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  serviceLocator.registerLazySingleton(() => AppUserCubit());

  // External
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);

  // Initialize all features
  _initAuth();
  _initGames();
  _initDiscussion();
  _initTeams();
  _initNews();
}

void _initAuth() {
  // Data sources
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: serviceLocator()),
  );

  // Repositories
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authRemoteDataSource: serviceLocator()),
  );

  // Use cases
  serviceLocator.registerLazySingleton(() => SignUpUseCase(authRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => LogInUseCase(authRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetCurrentUserDetailsUseCase(authRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => LogOutUseCase(authRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetAllUsersUseCase(authRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => MakeCoachUseCase(authRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => MakePlayerUseCase(authRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => MakeRegularUserUseCase(authRepository: serviceLocator()));

  // Bloc
  serviceLocator.registerFactory(() => AuthBloc(
    signUpUseCase: serviceLocator(),
    logInUseCase: serviceLocator(),
    getCurrentUserDetailsUseCase: serviceLocator(),
    logOutUseCase: serviceLocator(),
    appUserCubit: serviceLocator(),
    getAllUsersUseCase: serviceLocator(),
    makeCoachUseCase: serviceLocator(),
    makePlayerUseCase: serviceLocator(),
    makeRegularUserUseCase: serviceLocator(),
  ));
}

void _initGames() {
  serviceLocator.registerLazySingleton<GamesRemoteDataSource>(
    () => GamesRemoteDataSourceImpl(supabaseClient: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<GameRepository>(
    () => GameRepositoryImpl(serviceLocator()),
  );

  serviceLocator.registerLazySingleton(() => GetGamesUseCase(gameRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => MakeGamesUseCase(gameRepository: serviceLocator()));

  serviceLocator.registerFactory(() => GamesBloc(
    getGamesUseCase: serviceLocator(),
    makeGamesUseCase: serviceLocator(),
  ));
}

void _initDiscussion() {
  serviceLocator.registerLazySingleton<DiscussionRemoteDataSource>(
    () => DiscussionRemoteDataSourceImpl(supabaseClient: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<DiscussionRepository>(
    () => DiscussionRepositoryImpl(serviceLocator()),
  );

  serviceLocator.registerLazySingleton(() => GetMessagesUseCase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => SendMessageUseCase(repository: serviceLocator()));

  serviceLocator.registerFactory(() => DiscussionBloc(
    getMessagesUseCase: serviceLocator(),
    sendMessageUseCase: serviceLocator(),
  ));
}

void _initTeams() {
  serviceLocator.registerLazySingleton<TeamRemoteDataSource>(
    () => TeamRemoteDataSourceImpl(supabaseClient: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<TeamRepository>(
    () => TeamRepositoryImpl(serviceLocator()),
  );

  serviceLocator.registerLazySingleton(() => GetTeamNameUseCase(serviceLocator()));

  serviceLocator.registerFactory(() => TeamBloc(
    getTeamNameUseCase: serviceLocator(),
  ));
}

void _initNews() {
  serviceLocator.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(supabaseClient: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(remoteDataSource: serviceLocator()),
  );

  serviceLocator.registerLazySingleton(() => GetNewsUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => AddNewsUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => DeleteNewsUseCase(serviceLocator()));

  serviceLocator.registerFactory(() => NewsBloc(
    getNewsUseCase: serviceLocator(),
    addNewsUseCase: serviceLocator(),
    deleteNewsUseCase: serviceLocator(),
  ));
}

