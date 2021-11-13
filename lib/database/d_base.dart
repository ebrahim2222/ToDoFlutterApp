
import 'package:sqflite/sqflite.dart';
import 'package:to_do/Models/task.dart';

class DatabaseHelper{
  static const String tableName ="tasks";
  static const int version = 1;
  static late Database _database;

   initDataBase()async{


        var path =await getDatabasesPath() + "task.db";
        _database = await openDatabase(path, version: version,
            onCreate: (Database db, int version) async {
              // When creating the db, create the table
              await db.execute(
                  'CREATE TABLE $tableName ('
                      'id INTEGER PRIMARY KEY AUTOINCREMENT,'
                      ' title STRING,'
                      ' note TEXT,'
                      ' date STRING,'
                      ' startTime STRING,'
                      ' endTime STRING,'
                      ' remind INTEGER,'
                      ' repeat STRING,'
                      ' color INTEGER,'
                      'isCompleted INTEGER)'
              );
              print("database created");
            },
          onOpen: (db){
            print("database opened");
          }

            );


  }


  static Future<int> insert({Task? task})async{
       var i = await _database.insert(tableName,task!.toJson());
       print("value $i");
       return i;
  }

  Future<int> update(Task? task) async{
    return await _database.rawUpdate('''
      UPDATE $tableName
      SET isCompleted = ?
      WHERE id = ?
    ''',[1 , task!.id]);
  }

  Future<int> delete(Task? task)async{
    return await _database.delete(tableName,where: "id = ?" ,whereArgs: [task!.id]);
  }

  Future<List<Map<String, dynamic>>>  query()async{
     var list = await _database.rawQuery("SELECT * FROM $tableName");
     print(list);
     return list;
  }

}