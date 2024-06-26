import 'package:sqflite/sqflite.dart';
import 'package:ets/database/database_service.dart';
import 'package:ets/model/todo.dart';

class TodoDB {
  final tableName = 'todos';

  Future<void> createTable(Database database) async{
    await database.execute("""
    CREATE TABLE IF NOT EXISTS $tableName (
    "id" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "created_at" INTEGER NOT NULL DEFAULT (cast(strftime('%s', 'now') as int)),
    "updated_at" INTEGER,
   PRIMARY KEY("id" AUTOINCREMENT)
    );
    """);
  }

  Future<int> create({required String title, String? description}) async {
    print(description);
    final database = await DatabaseService().database;
    // Returns the latest inserted row
    return await database.rawInsert(
      '''INSERT INTO $tableName (title, description, created_at) VALUES (?,?,?)''',
      [title, description, DateTime.now().millisecondsSinceEpoch],
    );
  }

  Future<List<Todo>> fetchAll() async {
    final database = await DatabaseService().database;
    final todos = await database.rawQuery(
        '''SELECT * from $tableName ORDER BY COALESCE(updated_at, created_at)''');
    return todos.map((todo) => Todo.fromSqfliteDatabase(todo)).toList();
  }

  Future<Todo> fetchById(int id) async {
    final database = await DatabaseService().database;
    final todo = await database.rawQuery('''SELECT * from $tableName WHERE id = ?''', [id]);
    return Todo.fromSqfliteDatabase(todo.first);
  }

  Future<int> update({required int id, String? title, String? description}) async {
    final database = await DatabaseService().database;
    return await database.update(
      tableName,
      {
        if (title != null) 'title':title,
        'updated_at' : DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async {
    final database = await DatabaseService().database;
    await database.rawDelete('''DELETE FROM $tableName WHERE id = ?''', [id]);

  }

}