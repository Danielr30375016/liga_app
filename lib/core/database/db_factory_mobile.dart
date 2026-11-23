import 'package:sqflite/sqflite.dart';

/// En Android e iOS se usa el SQLite nativo del dispositivo
DatabaseFactory get appDatabaseFactory => databaseFactory;
