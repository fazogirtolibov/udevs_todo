import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:udevs_todo/core/data/repositories/home_repo.dart';

import 'database/database_service.dart';
import 'database/local_data_source.dart';

final getIt = GetIt.instance;

Future<void> setUp() async {
  getIt.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl());
  getIt.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());

  final db = await DatabaseService().database;
  getIt.registerLazySingleton<Database>(() => db);
}
