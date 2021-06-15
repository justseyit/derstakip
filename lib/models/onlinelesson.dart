import 'package:projectautumn/models/lesson.dart';

class OnlineLesson extends Lesson{
  String _lessonLink;

//#region Getters & Setters
  DateTime get lessonDateTime => super.lessonDateTime;

  set lessonDateTime(DateTime value) {
    super.lessonDateTime = value;
  }

  String get lessonLecturer => super.lessonLecturer;

  int get id => super.id;

  set id(int value) {
    super.id = value;
  }

  set lessonLecturer(String value) {
    super.lessonLecturer = value;
  }

  int get numberOfAbsences => super.numberOfAbsences;

  set numberOfAbsences(int value) {
    super.numberOfAbsences = value;
  }


  String get lessonName => super.lessonName;

  set lessonName(String value) {
    super.lessonName = value;
  }

  bool get attendance => super.attendanceBool;
  set attendance(bool value){
    super.attendanceBool=value;
  }

  int get numberOfAbsenceRights => super.numberOfAbsenceRights;

  set numberOfAbsenceRights(int value) {
    super.numberOfAbsenceRights = value;
  }

  String get lessonLink => _lessonLink;

  set lessonLink(String value) {
    _lessonLink = value;
  }
//#endregion

//#region Constructors
OnlineLesson(String lessonName, this._lessonLink, bool attendance, [String lessonLecturer, DateTime lessonDateTime, int numberOfAbsences, int numberOfAbsenceRights]):super(lessonName, attendance, lessonLecturer, lessonDateTime, numberOfAbsences, numberOfAbsenceRights);

OnlineLesson.withID(int id, String lessonName, this._lessonLink, bool attendance, [String lessonLecturer, DateTime lessonDateTime, int numberOfAbsences, int numberOfAbsenceRights]):super.withID(id, lessonName, attendance, lessonLecturer, lessonDateTime, numberOfAbsences, numberOfAbsenceRights);
//#endregion

//#region Map Methods
  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['id'] = super.id;
    map['lessonName'] = super.lessonName;
    map['lessonLecturer'] = super.lessonLecturer;
    map['lessonLink'] = _lessonLink;
    map['attendance'] = super.attendanceBool;
    map['lessonDateTime'] = super.lessonDateTime.toString();
    map['numberOfAbsences'] = super.numberOfAbsences;
    map['numberOfAbsenceRights'] = super.numberOfAbsenceRights;
    return map;
  }

  OnlineLesson.fromMap(Map<String, dynamic> map):super.fromMap(map){
    this._lessonLink = map['lessonLink'];
  }

//#endregion
}