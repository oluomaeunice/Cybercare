import 'package:cybercare/app/view/app.dart';
import 'package:cybercare/core/common/cubits/app_user.dart';
import 'package:cybercare/core/enum.dart';
import 'package:cybercare/core/theme/app_theme.dart';
import 'package:cybercare/core/theme/themebloc/theme_bloc.dart';
import 'package:cybercare/core/theme/themebloc/theme_event.dart';
import 'package:cybercare/core/theme/themebloc/theme_state.dart';
import 'package:cybercare/features/achievements/bloc/badgebloc_bloc.dart';
import 'package:cybercare/features/auth/view/bloc/auth_bloc.dart';
import 'package:cybercare/features/modules/moduledata/repository/module_repository.dart';
import 'package:cybercare/features/modules/view/modulebloc/module_bloc.dart';
import 'package:cybercare/features/modules/view/modulebloc/module_event.dart';
import 'package:cybercare/features/resources/view/resourcebloc/resource_bloc.dart';
import 'package:flutter/material.dart';
import 'package:cybercare/init_dependencies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/view/pages/welcomescreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
      BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
      BlocProvider(create: (_) => ThemeBloc()..add(LoadTheme())),
      BlocProvider(create: (_) => serviceLocator<ResourceBloc>()),
      BlocProvider(
        create: (_) => ModuleBloc(
          ModuleRepository(serviceLocator()), // Assuming you registered repo or create it here
        )..add(FetchModulesEvent()), // Load data immediately on startup
      ),
      BlocProvider(
        create: (_) => BadgeBloc(
          ModuleRepository(serviceLocator()),
        )..add(FetchBadgeData()), // Optional: Load badges immediately
      ),
    ],
    child: const MyApp(),
  ));
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
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: state.themeMode.toThemeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: BlocSelector<AppUserCubit, AppUserState, bool>(
            selector: (state) {
              return state is AppUserLoggedIn;
            },
            builder: (context, isLoggedIn) {
              if (isLoggedIn) {
                return MainNavigatorScreen();
              }
              return WelcomeScreen();
            },
          ),
        );
      },
    );
  }
}
