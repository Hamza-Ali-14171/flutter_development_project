import 'package:sqflite/sqflite.dart' as sql;

class SqlHelper {
  static Future<void> createTable(sql.Database database) async {
    await database.execute("""CREATE TABLE ali(
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  title TEXT,
  isCompleted INTEGER NOT NULL)""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase("my_db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTable(database);
    });
  }

  static Future<int> createData(String title) async {
    final subhan = await SqlHelper.db();
    Map<String, dynamic> store = {"title": title, 'isCompleted': 0};
    final id = await subhan.insert("ali", store);
    return id;
  }

  static Future<List<Map<String, dynamic>>> readData() async {
    final subhan = await SqlHelper.db();
    final read = await subhan.query("ali", orderBy: "id");
    return read;
  }

  static Future<int> updateData(int id, bool isCompleted) async {
    final subhan = await SqlHelper.db();
    Map<String, dynamic> store2 = {"isCompleted": isCompleted ? 1 : 0};
    final update =
        await subhan.update("ali", store2, where: "id=?", whereArgs: [id]);
    return update;
  }

  static Future<int> deleteData(int id) async {
    final subhan = await SqlHelper.db();
    final delete = await subhan.delete("ali", where: "id=?", whereArgs: [id]);
    return delete;
  }
}
