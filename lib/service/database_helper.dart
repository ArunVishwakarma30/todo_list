import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_list/model/task_model.dart';

class DatabaseHelper {
  static final _dbName = 'task.db';
  static final _dbVersion = 1;

  static final _tableName = 'task_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colIsCompleted = 'isCompleted';
  String colDueDate = 'dueDate';
  String colPriority = 'priority';

  // singleton class
  DatabaseHelper._privateConstructor();

  static late final Completer<Database> _dbCompleter = Completer<Database>();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static late Database _database;

  Future<Database> get database async {
    if (!_dbCompleter.isCompleted) {
      _initiateDatabase();
    }
    return _dbCompleter.future;
  }

  _initiateDatabase() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String path = join(directory.path, _dbName);
      _database =
          await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
      _dbCompleter.complete(_database);
    } catch (e) {
      _dbCompleter.completeError(e);
    }
  }

  Future? _onCreate(Database db, int version) {
    db.execute(''' CREATE TABLE $_tableName(
                    $colId INTEGER PRIMARY KEY AUTOINCREMENT,
                    $colTitle TEXT NOT NULL,
                    $colDescription TEXT NOT NULL,
                    $colDueDate TEXT NOT NULL,
                    $colIsCompleted INTEGER ,
                    $colPriority INTEGER )
             ''');
  }

  // Insert a task into database
  Future<int> insertTask(Task task) async {
    Database db = await instance.database;
    var result = await db.insert(_tableName, task.toMap());
    return result;
  }

  // Get All tasks from the database
  Future<List<Map<String, dynamic>>> getAllTasks() async {
    Database db = await instance.database;
    var result = await db.query(
      _tableName,
      orderBy: '$colIsCompleted ASC, $colId ASC',
    );
    // var result = await db.query(_tableName, where: '$colDay = ?', whereArgs: [day]);
    return result;
  }

  Future<List<Map<String, dynamic>>> getTasksByPriority() async {
    Database db = await instance.database;
    var result = await db.query(
      _tableName,
      orderBy: '$colPriority DESC, $colId ASC',
    );
    return result;
  }

  Future<List<Map<String, dynamic>>> getTasksByCompletionStatus(
      bool isCompleted) async {
    Database db = await instance.database;
    var result = await db.query(
      _tableName,
      where: '$colIsCompleted = ?',
      whereArgs: [isCompleted ? 1 : 0], // 1 for completed, 0 for incomplete
    );
    return result;
  }

  Future<List<Task>> getCompletedTaskList(bool isCompleted) async {
    Database db = await instance.database;
    var taskMapList = await getTasksByCompletionStatus(isCompleted);
    int count = taskMapList.length;
    List<Task> taskList = [];
    for (int i = 0; i < count; i++) {
      taskList.add(Task.fromMapObject(taskMapList[i]));
    }

    return taskList;
  }

  // Update an task
  Future<int> updateTask(Task task) async {
    Database db = await instance.database;
    var result = db.update(_tableName, task.toMap(),
        where: '$colId = ? ', whereArgs: [task.id]);
    return result; // this will return number of rows affected
  }

  // delete an task
  Future<int> deleteTask(int? id) async {
    Database db = await instance.database;
    var result = db.delete(_tableName, where: '$colId = ?', whereArgs: [id]);
    return result;
  }

  // get number of tasks present in the database
  Future<int?> getCount() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $_tableName');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }

// Get the 'Map List' [ List<Map> ] and convert it to 'task List' [ List<Note> ]
  Future<List<Task>> getTaskList() async {
    Database db = await instance.database;
    var taskMapList = await getAllTasks();
    int count = taskMapList.length;
    List<Task> taskList = [];
    for (int i = 0; i < count; i++) {
      taskList.add(Task.fromMapObject(taskMapList[i]));
    }

    return taskList;
  }

// Get the 'Map List' [ List<Map> ] and convert it to 'task List' [ List<Note> ]
  Future<List<Task>> getPriorityTaskList() async {
    Database db = await instance.database;
    var taskMapList = await getTasksByPriority();
    int count = taskMapList.length;
    List<Task> taskList = [];
    for (int i = 0; i < count; i++) {
      taskList.add(Task.fromMapObject(taskMapList[i]));
    }

    return taskList;
  }

  // Get All tasks from the database sorted by due date
  Future<List<Map<String, dynamic>>> getTasksSortedByDueDate() async {
    Database db = await instance.database;
    var result = await db.query(
      _tableName,
      orderBy: '$colDueDate ASC',
    );
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'task List' [ List<Note> ] sorted by due date
  Future<List<Task>> getTaskListSortedByDueDate() async {
    Database db = await instance.database;
    var taskMapList = await getTasksSortedByDueDate();
    int count = taskMapList.length;
    List<Task> taskList = [];
    for (int i = 0; i < count; i++) {
      taskList.add(Task.fromMapObject(taskMapList[i]));
    }

    return taskList;
  }

  // drop table
  Future<void> dropTable() async {
    Database db = await instance.database;
    await db.execute('DROP TABLE IF EXISTS $_tableName');
  }
}
