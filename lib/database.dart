import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

// Fonction qui ouvre la DB
Future<Database> openDB() async {
  final dbPath = await getDatabasesPath();
  return openDatabase(
    join(dbPath, 'auth.db'),
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT, password TEXT)',
      );
    },
    version: 1,
  );
}

// Ajoute un user dans la db
Future<void> addUser(String username, String password) async {
  final db = await openDB();
  await db.insert(
    'users',
    {'username': username, 'password': password},
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}