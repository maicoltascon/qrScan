// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_reader/models/scan_model.dart';
export 'package:qr_reader/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';

class DbProvider {
  static Database? _database;

  static final DbProvider db = DbProvider._();
  DbProvider._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    // Path de donde almacenaremos la base de datos
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(appDocumentsDirectory.path, 'scans.db');

    print(path);

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE scans (id INTEGER PRIMARY KEY, tipo TEXT, valor TEXT)',
        );
      },
    );
  }

  Future<int> newScanRaw(ScanModel newScan) async {
    final db = await database;

    final res = await db.rawInsert(
      'INSERT INTO scans (id, tipo, valor) VALUES (?, ?, ?)',
      [newScan.id, newScan.tipo, newScan.valor],
    );

    return res;
  }

  Future<int> newScan(ScanModel newScan) async {
    final db = await database;
    final res = await db.insert('scans', newScan.toJson());
    return res;
  }

  Future<ScanModel> getScanById(int i) async {
    final db = await database;
    final res = await db.query('scans', where: 'id = ?', whereArgs: [i]);
    return res.isNotEmpty
        ? ScanModel.fromJson(res.first)
        : ScanModel(valor: '');
  }

  Future<List<ScanModel>> getScans() async {
    final db = await database;
    final res = await db.query('scans');
    return res.isNotEmpty ? res.map((s) => ScanModel.fromJson(s)).toList() : [];
  }

  Future<List<ScanModel>> getScansByType(String type) async {
    final db = await database;
    final res = await db.query('scans', where: 'tipo = ?', whereArgs: [type]);
    return res.isNotEmpty ? res.map((s) => ScanModel.fromJson(s)).toList() : [];
  }

  Future<int> updateScan(ScanModel updateScan) async {
    final db = await database;
    final res = await db.update('scans', updateScan.toJson(),
        where: 'id = ?', whereArgs: [updateScan.id]);
    return res;
  }

  Future<int> deleteByIdScan(int id) async {
    final db = await database;
    final res = await db.delete('scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteByTypeScan(String type) async {
    final db = await database;
    final res = await db.delete('scans', where: 'tipo = ?', whereArgs: [type]);
    return res;
  }

  Future<int> deleteAllScan() async {
    final db = await database;
    final res = await db.delete('scans');
    return res;
  }

  Future<void> closeDB() async {
    final db = await database;
    await db.close();
  }
}
