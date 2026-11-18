import "dart:io";
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SQLiteBridge {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    Directory documentsDirectory = Directory('/sdcard/Download');
    String path = join(documentsDirectory.path, "database.sqlite3");
    return await openDatabase(path, readOnly: true);
  }

  static Future<Map<String, dynamic>> getParts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('part_part');
    List<Map<String, dynamic>> results = [];
    for (var map in maps) {
      results.add({
        "pk": map['id'],
        "name": map['name'],
        "description": map['description'],
        "IPN": map['IPN'],
        "active": map['active'] == 1,
        "assembly": map['assembly'] == 1,
        "component": map['component'] == 1,
        "purchaseable": map['purchaseable'] == 1,
        "salable": map['salable'] == 1,
        "trackable": map['trackable'] == 1,
        "virtual": map['virtual'] == 1,
        "is_template": map['is_template'] == 1,
        "units": map['units'],
        "category": map['category_id'],
      });
    }
    return {"count": maps.length, "results": results};
  }
}
