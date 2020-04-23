import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:Staffield/constants/sqlite_tables.dart';
import 'package:Staffield/core/exceptions/e_insert_entry.dart';
import 'package:Staffield/services/sqlite/srvc_sqlite_init.dart';

final getIt = GetIt.instance;

class SrvcSqliteEntries {
  SrvcSqliteEntries() {
    final init = getIt<SrvcSqliteInit>();
    initComplete = init.initComplete;
    initComplete.whenComplete(() {
      dbEntries = init.db;
    });
  }

  Future<void> initComplete;
  Database dbEntries;

  //-----------------------------------------
  Future<List<Map<String, dynamic>>> fetchEntries() async {
    await initComplete;
    return dbEntries.query(SqliteTable.entries);
  }

  //-----------------------------------------
  Future<List<Map<String, dynamic>>> fetchPenalties() async {
    await initComplete;
    return dbEntries.query(SqliteTable.penalties);
  }

  //-----------------------------------------
  Future<bool> addOrUpdate(Map<String, dynamic> entry) async {
    await initComplete;
    var result = await dbEntries.insert(SqliteTable.entries, entry,
        conflictAlgorithm: ConflictAlgorithm.replace);
    if (result <= 0)
      throw EInsertEntry('Can\'t insert SrvcSqliteEntries');
    else
      return true;
  }

  //-----------------------------------------
  Future<void> remove(String uid) async {
    await initComplete;
    dbEntries.delete(
      SqliteTable.entries,
      where: 'uid = ?',
      whereArgs: [uid],
    );
    dbEntries.delete(
      SqliteTable.penalties,
      where: 'parentUid = ?',
      whereArgs: [uid],
    );
  }
}
