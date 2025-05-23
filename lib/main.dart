import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namhockey/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:namhockey/core/common/navigation/app_routes.dart';
import 'package:namhockey/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:namhockey/features/auth/presentation/pages/sign_in_page.dart';
import 'package:namhockey/features/discussion/presentation/bloc/discussion_bloc.dart';
import 'package:namhockey/features/games/presentation/bloc/games_bloc.dart';
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
    runApp(MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<GamesBloc>()),
        BlocProvider(create: (_) => serviceLocator<DiscussionBloc>()),
        BlocProvider(create: (_) => serviceLocator<NewsBloc>()),
      ],
      child: const MyApp(),
    ));
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthGetUserDetailsEvent());  
    
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NamHockey',
      onGenerateRoute: AppRoutes.generateRoute,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isLoggedIn) {
          if (isLoggedIn) {
            return MainNavigationPage();
          }
          return SignInPage();
        },
      ),
    );
  }
}

