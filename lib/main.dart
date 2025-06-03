import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namhockey/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:namhockey/core/common/navigation/app_routes.dart';
import 'package:namhockey/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:namhockey/features/auth/presentation/pages/sign_in_page.dart';
import 'package:namhockey/features/discussion/presentation/bloc/discussion_bloc.dart';
import 'package:namhockey/features/games/presentation/bloc/games_bloc.dart';
import 'package:namhockey/features/live_matches/presentation/bloc/live_match_bloc.dart';
import 'package:namhockey/features/news/presentation/bloc/news_bloc.dart';
import 'package:namhockey/init_dependencies.dart';
import 'package:namhockey/main_nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
          BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
          BlocProvider(create: (_) => serviceLocator<GamesBloc>()),
          BlocProvider(create: (_) => serviceLocator<DiscussionBloc>()),
          BlocProvider(create: (_) => serviceLocator<NewsBloc>()),
          BlocProvider(create: (_) => serviceLocator<LiveMatchBloc>()),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    // Only check for user details on first app launch
    if (_isInitialLoad) {
      context.read<AuthBloc>().add(AuthGetUserDetailsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NamHockey',
      onGenerateRoute: AppRoutes.generateRoute,
      home: BlocBuilder<AuthBloc, AuthState>(
        buildWhen:
            (previous, current) =>
                current is AuthInitial ||
                (previous is AuthInitial && current is AuthLoading) ||
                current is AuthSuccess ||
                current is AuthFailure,
        builder: (context, state) {
          if (_isInitialLoad &&
              (state is AuthInitial || state is AuthLoading)) {
            return const LoadingScreen();
          }

          if (state is AuthSuccess || state is AuthFailure) {
            _isInitialLoad = false;
          }

          return BlocSelector<AppUserCubit, AppUserState, bool>(
            selector: (state) => state is AppUserLoggedIn,
            builder: (context, isLoggedIn) {
              if (isLoggedIn) {
                return const MainNavigationPage();
              }
              return const SignInPage();
            },
          );
        },
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            SizedBox(height: 120, child: Image.asset("assets/images/nht.jpg")),
            const SizedBox(height: 32),
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 24),
            // Loading text
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
