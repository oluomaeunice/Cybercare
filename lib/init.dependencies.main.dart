part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async{
  // Initialize Supabase first
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.SupabaseAnonKey,
  );

  // Register core dependencies
  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerLazySingleton(() => InternetConnection());
  serviceLocator.registerLazySingleton<ConnectionChecker>(
        () => ConnectionCheckerImplementation(serviceLocator()),
  );

  // Initialize feature dependencies
  _initAuth();
  _initResources();

  // Register AppUserCubit after auth is initialized
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth(){
  //this is the data source
  serviceLocator..registerFactory<AuthRemoteDataSource>(()=>AuthRemoteDataSourceImplementation(serviceLocator()))
  //this is the repository
    ..registerFactory<AuthRepository>(()=>AuthRepositoryImplementation(serviceLocator(),serviceLocator()))
  //this is the use cases
    ..registerFactory(()=>UserSignUp(serviceLocator()))
    ..registerFactory(()=>UserLogin(serviceLocator()))
    ..registerFactory(()=>CurrentUser(serviceLocator()))
    ..registerFactory(() => UserLogout(serviceLocator()))
    ..registerFactory(() => UpdateUserProfile(serviceLocator()))
    ..registerFactory(() => ForgotPassword(serviceLocator()))
  //this is the Bloc
    ..registerLazySingleton(() => AuthBloc(userSignUp: serviceLocator(), userLogin: serviceLocator(), currentUser: serviceLocator(), appUserCubit: serviceLocator(),userLogout: serviceLocator(),updateUserProfile: serviceLocator(),
      forgotPassword: serviceLocator(),));
}

void _initResources() {
  serviceLocator
  // Datasource
    ..registerFactory<ResourceRemoteDataSource>(
            () => ResourceRemoteDataSourceImplementation(serviceLocator()))
  // Repository
    ..registerFactory<ResourceRepository>(
            () => ResourceRepositoryImplementation(serviceLocator())) // assuming you check connection
  // Usecases
    ..registerFactory(() => UploadResource(serviceLocator()))
    ..registerFactory(() => GetAllResources(serviceLocator()))
  // Bloc
    ..registerLazySingleton(() => ResourceBloc(
      uploadResource: serviceLocator(),
      getAllResources: serviceLocator(),
    ));
}