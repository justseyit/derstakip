import 'package:flutter/material.dart';
import 'package:projectautumn/utils/dbhepler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'models/lesson.dart';


class AbsenceSettings extends StatefulWidget {
  @override
  _AbsenceSettingsState createState() => _AbsenceSettingsState();
}

class _AbsenceSettingsState extends State<AbsenceSettings> {
  //Future<SharedPreferences> _sharedPreferences;
  SharedPreferences _prefs;
  List<Lesson> _lessons;
  List<DropdownMenuItem> _lessonsDropDownItems;
  Lesson _selectedLesson;
  int _absence;
  bool _question = true;
  String _selectedHour;
  String _selectedMinute;
  DBHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _dbHelper = DBHelper();
    //_sharedPreferences = SharedPreferences.getInstance();
    _getSharedPrefs();
    _lessons = [];
    _lessonsDropDownItems = [];

    _dbHelper.allLessons().then((mapList) {
      for (Map map in mapList) {
        _lessons.add(Lesson.fromMap(map));
      }
      setState(() {
        _lessonsDropDownItems = itemsLesson(_lessons);
      });
    }).catchError((err) => print("Hata: " + err.toString()));
    /*for (int i = 0; i < 10; i++) {
      _lessons.add(Lesson("Ders ${i + 1}", true, "", null, 4, 15));
    }*/
    //_lessonsDropDownItems = itemsLesson(_lessons);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Devamsızlık Ayarları",
          style: TextStyle(
            fontFamily: "Comfortaa-Bold",
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 10,
              height: MediaQuery.of(context).size.height - 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black87, width: 2),
              ),
              child: ListView(
                children: [
                  //Devamsızlık ekle-sil
                  InkWell(
                    onTap: () {
                      _editAbsenceDialog(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 10,
                      //height: (MediaQuery.of(context).size.height - 50) / 10,
                      decoration: BoxDecoration(
                        //borderRadius: BorderRadius.circular(12),
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black87,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 30,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Devamsızlık Ekle - Sil",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Comfortaa-Bold",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //Devam Zorunluluğu Ayarları
                  InkWell(
                    onTap: () {
                      _attendanceDialog(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 10,
                      //height: (MediaQuery.of(context).size.height - 50) / 10,
                      decoration: BoxDecoration(
                        //borderRadius: BorderRadius.circular(12),
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black87,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.skip_next_outlined,
                              size: 30,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Devam Zorunluluğu\nAyarları",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Comfortaa-Bold",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //Devamsızlık Bildirimi Sıklığı
                  InkWell(
                    onTap: () {
                      _participtionQuestionDialog(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 10,
                      //height: (MediaQuery.of(context).size.height - 50) / 10,
                      decoration: BoxDecoration(
                        //borderRadius: BorderRadius.circular(12),
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black87,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.notifications_none,
                              size: 30,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Devamsızlık Sorusu\nAyarları",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Comfortaa-Bold",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _editAbsenceDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                "Devamsızlık Ekle - Sil",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Comfortaa-Bold",
                ),
              ),
              content: SingleChildScrollView(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    DropdownButtonHideUnderline(
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(),
                        ),
                        child: DropdownButton(
                          hint: Text(
                            "Ders seçin.",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Comfortaa-Bold",
                            ),
                          ),
                          isExpanded: true,
                          value: _selectedLesson,
                          onChanged: (value) {
                            setState(() {
                              _selectedLesson = value;
                            });
                            _selectedLesson == null
                                ? setState(() {
                                    _absence = 0;
                                  })
                                : setState(() {
                                    _absence = _selectedLesson.numberOfAbsences;
                                  });
                          },
                          items: _lessonsDropDownItems,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width) / (5 / 3),
                      height: (MediaQuery.of(context).size.height - 50) / 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.black87,
                          //width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              //width: (MediaQuery.of(context).size.width)/5,
                              //height: (MediaQuery.of(context).size.height - 50)/10,
                              decoration: BoxDecoration(
                                //borderRadius: BorderRadius.circular(12),
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: _selectedLesson == null
                                      ? () => null
                                      : () {
                                          _changeAbsence(false, _absence);
                                          setState(() {
                                            setState(() {});
                                          });
                                        },
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              child: Text(
                                _absence == null ? "0" : "$_absence",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Comfortaa-Bold",
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              //width: (MediaQuery.of(context).size.width)/5,
                              //height: (MediaQuery.of(context).size.height - 50)/10,
                              decoration: BoxDecoration(
                                //borderRadius: BorderRadius.circular(12),
                                border: Border(
                                  left: BorderSide(
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: _selectedLesson == null
                                      ? () => null
                                      : () {
                                          _changeAbsence(true, _absence);
                                          setState(() {});
                                        },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                ButtonBar(
                  children: [
                    TextButton(
                      child: Text(
                        'İptal',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Comfortaa-Bold",
                          color: Colors.red,
                        ),
                      ),
                      onPressed: () {
                        _absence = 0;
                        _selectedLesson = null;
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(
                        'Kaydet',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Comfortaa-Bold",
                          color: Colors.blue,
                        ),
                      ),
                      onPressed: _selectedLesson == null
                          ? () => null
                          : () async {
                              _selectedLesson.numberOfAbsences = _absence;
                              _dbHelper.updateLesson(_selectedLesson);
                              //await _prefs.setString('OgrenciAdi', _name.toString());
                              print("Set new absence.");
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Devamsızlık kaydedildi."),
                                duration: Duration(seconds: 1),
                              ));
                              _absence = 0;
                              _selectedLesson = null;
                              setState(() {});
                            },
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<DropdownMenuItem> itemsLesson(List<Lesson> lessons) {
    List<DropdownMenuItem> listLesson = [];

    for (Lesson lesson in lessons) {
      if (lesson != null) {
        listLesson.add(DropdownMenuItem(
          value: lesson,
          child: lesson.lessonLecturer == null || lesson.lessonLecturer == ""
              ? SingleChildScrollView(
                  child: Text(
                    '${lesson.lessonName}',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Comfortaa-Bold",
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        '${lesson.lessonName}',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Comfortaa-Bold",
                        ),
                      ),
                      Text(
                        '${lesson.lessonLecturer}',
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: "Comfortaa-Bold",
                        ),
                      ),
                    ],
                  ),
                ),
        ));
      }
    }
    return listLesson;
  }

  _changeAbsence(bool increase, int absence) {
    increase ? absence++ : absence--;
    absence < 0 ? _absence = 0 : _absence = absence;
    print(_absence);
  }

  _attendanceDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Text(
                  "Devam Zorunluluğu Düzenle",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Comfortaa-Bold",
                  ),
                ),
                content: SingleChildScrollView(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: _showEditableLessonAttendances(context, _lessons),
                  ),
                ),
                actions: [
                  ButtonBar(
                    children: [
                      TextButton(
                        child: Text(
                          'Tamam',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Comfortaa-Bold",
                            color: Colors.blue,
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        });
  }

  _showEditableLessonAttendances(BuildContext context, List<Lesson> lessons) {
    List<Widget> leslist = [];
    for (Lesson lesson in lessons) {
      leslist.add(StatefulBuilder(
        builder: (context, setState) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "${lesson.lessonName}",
                    style: TextStyle(
                      fontFamily: "Comfortaa-Bold",
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    lesson.lessonLecturer != null
                        ? "${lesson.lessonLecturer}"
                        : "",
                    style:
                        TextStyle(fontFamily: "Comfortaa-Light", fontSize: 10),
                  )
                ],
              ),
              Switch(
                value: lesson.attendanceBool,
                onChanged: (value) {
                  setState(() {
                    lesson.attendanceBool = value;
                  });
                  _dbHelper.updateLesson(lesson);
                },
              ),
            ],
          );
        },
      )
          /*SwitchListTile(
          value: lesson.attendanceBool,
          onChanged: (value){
            setState(() {
              //lesson.attendanceBool ? lesson.attendanceBool = false : lesson.attendanceBool = true;
              lesson.attendanceBool = value;
            });
          },
          title: Text(
            "${lesson.lessonName}",
            style: TextStyle(
              fontFamily: "Comfortaa-Bold",
            ),
          ),
          subtitle: lesson.lessonLecturer != null ? Text(
            "${lesson.lessonLecturer}",
            style: TextStyle(
              fontFamily: "Comfortaa-Bold",
            ),
          ) : null,
        )*/
          );
    }
    return leslist;
  }

  _participtionQuestionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                "Devamsızlık Sorusu",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Comfortaa-Bold",
                ),
              ),
              content: SingleChildScrollView(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: _question ?? false,
                      onChanged: (value) {
                        setState(() {
                          _question = value;
                          if(_question == false){
                            _selectedMinute = null;
                            _selectedHour = null;
                          }
                        });

                      },
                      title: Text(
                        "Devamsızlık Sorusu Sorulsun",
                        style: TextStyle(
                          fontFamily: "Comfortaa-Bold",
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sorma\nSaati:',
                          style: TextStyle(
                            fontFamily: "Comfortaa-Bold",
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(),
                                ),
                                child: DropdownButton(
                                  hint: Text(
                                    "Saat",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Comfortaa-Bold",
                                    ),
                                  ),
                                  value: _selectedHour,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedHour = value;
                                    });
                                    print(_selectedHour);
                                  },
                                  items: itemsNumber(24),
                                ),
                              ),
                              Text(
                                '  :  ',
                                style: TextStyle(
                                  fontFamily: "Comfortaa-Bold",
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(),
                                ),
                                child: DropdownButton(
                                  hint: Text(
                                    "Dakika",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Comfortaa-Bold",
                                    ),
                                  ),
                                  value: _selectedMinute,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedMinute = value;
                                    });
                                    print(_selectedMinute);
                                  },
                                  items: itemsNumber(60),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Her gün seçtiğiniz saatte size, o periyottaki derslere girip girmediğiniz sorulur.",
                      style: TextStyle(
                          fontFamily: "Comfortaa-Light", fontSize: 10),
                    ),
                  ],
                ),
              ),
              actions: [
                ButtonBar(
                  children: [
                    TextButton(
                      child: Text(
                        'İptal',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Comfortaa-Bold",
                          color: Colors.red,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(
                        'Kaydet',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Comfortaa-Bold",
                          color: Colors.blue,
                        ),
                      ),
                      onPressed: () async {
                        if (_selectedHour == null) {
                          _question ? _selectedHour = "23" : _selectedHour = null;
                        }
                        if (_selectedMinute == null) {
                          _question ? _selectedMinute = "00" : _selectedMinute = null;
                        }
                        _prefs.setBool('Question', _question);
                        if(_question){
                          DateTime qdt = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, int.parse(_selectedHour) ?? 23, int.parse(_selectedMinute) ?? 0);
                          if(qdt.isBefore(DateTime.now())){
                            qdt = qdt.add(Duration(days: 1));
                          }
                          _prefs.setString('SelectedQHour', _selectedHour);
                          _prefs.setString('SelectedQMinute', _selectedMinute);
                          Workmanager().registerPeriodicTask('0', 'periodicControlTask', tag: 'control', frequency: Duration(hours: 1), existingWorkPolicy: ExistingWorkPolicy.keep);
                          Workmanager().registerPeriodicTask('1', 'notificationTask', tag: 'notify', frequency: Duration(hours: 24), initialDelay: DateTimeRange(start: DateTime.now(), end: qdt).duration, existingWorkPolicy: ExistingWorkPolicy.replace);
                          print(DateTimeRange(start: DateTime.now(), end: qdt).duration.toString());
                        }
                        else{
                          Workmanager().cancelByTag('notify');
                        }
                        print("Save the choice.");
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Tercihiniz kaydedildi."),
                          duration: Duration(seconds: 1),
                        ));
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<DropdownMenuItem> itemsNumber(int num) {
    List<DropdownMenuItem> listNum = [];
    for (int i = 0; i < num; i++) {
      listNum.add(
        DropdownMenuItem(
          value: i <= 9 ? '0$i' : '$i',
          child: Text(
            i <= 9 ? '0$i' : '$i',
            style: TextStyle(
              fontSize: 20,
              fontFamily: "Comfortaa-Bold",
            ),
          ),
        ),
      );
    }
    return listNum;
  }

  _getSharedPrefs() async {
    SharedPreferences.getInstance().then((value) {
      _prefs = value;
      setState(() {
        if(_prefs.containsKey("Question")){
          _question = _prefs.getBool('Question') ?? false;
        }
        else{
          _question = false;
          _prefs.setBool('Question', false);
        }

        if(_prefs.containsKey("SelectedQHour")){
          _selectedHour = _prefs.getString('SelectedQHour');
        }
        else{
          _selectedHour = null;
          _prefs.setString('SelectedQHour', "23");
        }

        if(_prefs.containsKey("SelectedQMinute")){
          _selectedMinute = _prefs.getString('SelectedQMinute');
        }
        else{
          _selectedMinute = null;
          _prefs.setString('SelectedQMinute', '00');
        }
      });
    });
  }
}