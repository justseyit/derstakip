import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projectautumn/models/lesson.dart';
import 'package:projectautumn/models/onlinelesson.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{

  static DBHelper _dbhelper;
  static Database _database;

  String _tableNameLesson = 'lesson';
  String _tableNameOnlineLesson = 'onlinelesson';
  String _columnID = 'id';
  String _columnOnlineLessonID = 'id';
  String _columnForeignID = 'lessonID';
  String _columnLessonName = 'lessonName';
  String _columnLessonLecturer = 'lessonLecturer';
  String _columnLessonLink = 'lessonLink';
  String _columnLessonDateTime = 'lessonDateTime';
  String _columnNumberOfAbsences = 'numberOfAbsences';
  String _columnNumberOfAbsenceRights = 'numberOfAbsenceRights';
  String _columnAttendance = 'attendance';

  factory DBHelper(){
    if(_dbhelper == null){
      _dbhelper = DBHelper._internal();
      return _dbhelper;
    }
    else{
      return _dbhelper;
    }
  }

  DBHelper._internal();

  Future<Database> _getDatabase() async{
    if(_database == null){
      _database = await _initializeDatabase();
      return _database;
    }
    else{
      return _database;
    }
  }

  _initializeDatabase() async{
    Directory _path = await getApplicationDocumentsDirectory();
    String _dbPath = join(_path.path, 'lesson.db');

    var _lessonDB = openDatabase(_dbPath, version: 1, onCreate: _createDatabase);
    return _lessonDB;
  }

  _createDatabase(Database db, int version) async{
    await db.execute('CREATE TABLE $_tableNameLesson ($_columnID	INTEGER NOT NULL UNIQUE,$_columnLessonName TEXT NOT NULL,$_columnAttendance INTEGER NOT NULL,$_columnLessonLecturer TEXT,$_columnLessonDateTime	TEXT,$_columnNumberOfAbsences	INTEGER,$_columnNumberOfAbsenceRights	INTEGER,PRIMARY KEY($_columnID AUTOINCREMENT) )');
    await db.execute('CREATE TABLE "$_tableNameOnlineLesson" ($_columnOnlineLessonID	INTEGER NOT NULL,$_columnLessonLink	TEXT,$_columnForeignID	INTEGER,FOREIGN KEY($_columnForeignID) REFERENCES $_tableNameLesson($_columnID),PRIMARY KEY($_columnOnlineLessonID AUTOINCREMENT) )');
  }

  Future<int> addLesson(Lesson lesson) async{
    var db = await _getDatabase();
    var result = await db.insert(_tableNameLesson, lesson.toMap(), nullColumnHack: '$_columnID');
    print('Ekleme işlemi başarılı.');
    return result;
  }

  Future<List<Map<String, dynamic>>> allLessons() async{
    var db = await _getDatabase();
    var result = await db.query(_tableNameLesson, orderBy: '$_columnID DESC');
    return result;
  }

  Future<List<Map<String, dynamic>>> allOnlineLessons() async{
    var db = await _getDatabase();
    var result = await db.query(_tableNameOnlineLesson, orderBy: '$_columnOnlineLessonID DESC');
    return result;
  }

  Future<int> updateLesson(Lesson lesson) async{
    var db = await _getDatabase();
    var result = await db.update(_tableNameLesson, lesson.toMap(), where: '$_columnID = ?', whereArgs: [lesson.id]);
    return result;
  }


  Future<int> updateOnlineLesson(OnlineLesson onlineLesson) async{
    var db = await _getDatabase();
    var result = await db.update(_tableNameOnlineLesson, onlineLesson.toMap(), where: '$_columnOnlineLessonID = ?', whereArgs: [onlineLesson.id]);
    return result;
  }

  Future<int> deleteLesson(int id) async{
    var db = await _getDatabase();
    var result = await db.delete(_tableNameLesson, where: '$_columnOnlineLessonID = ?', whereArgs: [id]);
    return result;
  }

  Future<int> deleteOnlineLesson(int id) async{
    var db = await _getDatabase();
    var result = await db.delete(_tableNameOnlineLesson, where: '$_columnOnlineLessonID = ?', whereArgs: [id]);
    return result;
  }

  Future<int> deleteAllOfTheLessonTable() async{
    var db = await _getDatabase();
    var result = await db.delete(_tableNameLesson);
    return result;
  }
}

