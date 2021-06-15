class Lesson{
  int _id;
  String _lessonName;
  String _lessonLecturer;
  DateTime _lessonDateTime;
  int _numberOfAbsences;
  int _numberOfAbsenceRights;
  bool _attendanceBool;
  int _attendance;


//#region Getters & Setters
  bool get attendanceBool {
    if(_attendance == 0 || _attendance == null){
      return false;
    }
    else{
      return true;
    }
  }

  set attendanceBool(bool value) {
    _attendanceBool = value;
    _attendanceBool ? _attendance = 1 : _attendance = 0;
    print(_attendance);
  }

  DateTime get lessonDateTime => _lessonDateTime;

  set lessonDateTime(DateTime value) {
    _lessonDateTime = value;
  }

  String get lessonLecturer => _lessonLecturer;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  set lessonLecturer(String value) {
    _lessonLecturer = value;
  }

  int get numberOfAbsences => _numberOfAbsences;

  set numberOfAbsences(int value) {
    _numberOfAbsences = value;
  }


  String get lessonName => _lessonName;

  set lessonName(String value) {
    _lessonName = value;
  }


  int get numberOfAbsenceRights => _numberOfAbsenceRights;

  set numberOfAbsenceRights(int value) {
    _numberOfAbsenceRights = value;
  }

  //String get lessonLink => _lessonLink;

  /*set lessonLink(String value) {
    _lessonLink = value;
  }*/
//#endregion

//#region Constructors
  Lesson(this._lessonName, this._attendanceBool, [this._lessonLecturer, this._lessonDateTime, this._numberOfAbsences, this._numberOfAbsenceRights]);

  Lesson.withID(this._id, this._lessonName, this._attendanceBool, [this._lessonLecturer, this._lessonDateTime, this._numberOfAbsences, this._numberOfAbsenceRights]);

//#endregion

//#region Map Methods
  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();

    map['id'] = _id;
    map['lessonName'] = _lessonName;
    map['attendance'] = _attendance ?? 1;
    map['lessonLecturer'] = _lessonLecturer;
    map['lessonDateTime'] = _lessonDateTime.toString();
    map['numberOfAbsences'] = _numberOfAbsences;
    map['numberOfAbsenceRights'] = _numberOfAbsenceRights;
    return map;
  }

  Lesson.fromMap(Map<String, dynamic> map){
    this._id = map['id'];
    this._lessonName = map['lessonName'];
    this._attendance = map['attendance'] ?? 1;
    this._lessonLecturer = map['lessonLecturer'] ?? "";
    this._lessonDateTime = DateTime.parse(map['lessonDateTime']) ?? DateTime(2500);
    this._numberOfAbsences = map['numberOfAbsences'] ?? 0;
    this._numberOfAbsenceRights = map['numberOfAbsenceRights'] ?? 0;
  }

//#endregion
}