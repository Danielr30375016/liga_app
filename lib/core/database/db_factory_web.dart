import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

/// En el navegador se usa SQLite compilado a WebAssembly
DatabaseFactory get appDatabaseFactory => databaseFactoryFfiWeb;
