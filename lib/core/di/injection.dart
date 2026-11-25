import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:liga_app/core/database/app_database.dart';
import 'package:liga_app/core/network/dio_client.dart';
import 'package:liga_app/core/platform/connectivity_service.dart';
import 'package:liga_app/core/platform/share_services.dart';
import 'package:liga_app/features/favorites/data/favorites_local_data_source.dart';
import 'package:liga_app/features/standings/data/datasources/standings_remote_data_source.dart';
import 'package:liga_app/features/standings/data/repositories/standings_repository_impl.dart';
import 'package:liga_app/features/standings/domain/repositories/standings_repository.dart';
import 'package:liga_app/features/standings/presentation/bloc/standings_bloc.dart';

final sl = GetIt.instance;

Future<void> setupInjection() async {
  // Base de datos: se abre UNA vez, antes de arrancar la app
  final database = await AppDatabase.open();
  sl.registerSingleton<AppDatabase>(database);

  // Plataforma
  sl.registerLazySingleton<ShareService>(() => const ShareService());

  sl.registerLazySingleton<ConnectivityService>(
    () => const ConnectivityService(),
  );

  // red
  sl.registerLazySingleton<Dio>(DioClient.create);

  // Data
  sl.registerLazySingleton<StandingsRemoteDataSource>(
    () => StandingsRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<StandingsRepository>(
    () => StandingsRepositoryImpl(sl()),
  );

  sl.registerFactory<StandingsBloc>(() => StandingsBloc(sl()));

  // Favorites
  sl.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSource(sl()),
  );
}
