import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'
    show databaseFactoryFfi, sqfliteFfiInit;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'
    show databaseFactoryFfiWeb;

class UserRecord {
  const UserRecord({required this.id, required this.username});

  final int id;
  final String username;
}

class JournalRecord {
  const JournalRecord({
    required this.id,
    required this.name,
    required this.location,
    required this.note,
  });

  final int id;
  final String name;
  final String location;
  final String note;
}

class JournalDatabase {
  JournalDatabase._();

  static final JournalDatabase instance = JournalDatabase._();
  Database? _database;
  Future<Database>? _openingDatabase;

  Future<Database> get database async {
    if (_database != null) return _database!;
    return _openingDatabase ??= _openDatabase();
  }

  Future<Database> _openDatabase() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else if (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final databasePath = kIsWeb
        ? 'kalariset.db'
        : path.join(await databaseFactory.getDatabasesPath(), 'kalariset.db');
    final database = await databaseFactory.openDatabase(
      databasePath,
      options: OpenDatabaseOptions(
        version: 2,
        onCreate: (database, version) => _ensureSchema(database),
        onUpgrade: (database, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await database.delete('journal_entries');
          }
          await _ensureSchema(database);
        },
      ),
    );
    await _ensureSchema(database);
    _database = database;
    return database;
  }

  Future<void> _ensureSchema(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password_hash TEXT NOT NULL
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS journal_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        location TEXT NOT NULL,
        note TEXT NOT NULL DEFAULT ''
      )
    ''');
  }

  Future<List<JournalRecord>> getEntries() async {
    final database = await this.database;
    final rows = await database.query('journal_entries', orderBy: 'id ASC');
    return rows
        .map(
          (row) => JournalRecord(
            id: row['id'] as int,
            name: row['name'] as String,
            location: row['location'] as String,
            note: row['note'] as String,
          ),
        )
        .toList();
  }

  Future<int> insertEntry({
    required String name,
    required String location,
    required String note,
  }) async {
    final database = await this.database;
    return database.insert('journal_entries', {
      'name': name,
      'location': location,
      'note': note,
    });
  }

  Future<void> updateEntry({
    required int id,
    required String name,
    required String location,
    required String note,
  }) async {
    final database = await this.database;
    await database.update(
      'journal_entries',
      {'name': name, 'location': location, 'note': note},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteEntry(int id) async {
    final database = await this.database;
    await database.delete('journal_entries', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> createUser({
    required String username,
    required String password,
  }) async {
    final database = await this.database;
    try {
      await database.insert('users', {
        'username': username,
        'password_hash': _hashPassword(password),
      });
      return true;
    } on DatabaseException catch (error) {
      if (error.isUniqueConstraintError()) return false;
      rethrow;
    }
  }

  Future<UserRecord?> authenticateUser({
    required String username,
    required String password,
  }) async {
    final database = await this.database;
    final rows = await database.query(
      'users',
      columns: ['id', 'username'],
      where: 'username = ? AND password_hash = ?',
      whereArgs: [username, _hashPassword(password)],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return UserRecord(
      id: rows.first['id'] as int,
      username: rows.first['username'] as String,
    );
  }

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }
}
