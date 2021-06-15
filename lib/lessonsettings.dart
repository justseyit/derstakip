import 'package:flutter/material.dart';
import 'package:projectautumn/models/lesson.dart';
import 'package:projectautumn/utils/dbhepler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class LessonSettings extends StatefulWidget {
  @override
  _LessonSettingsState createState() => _LessonSettingsState();
}

class _LessonSettingsState extends State<LessonSettings> {
  SharedPreferences _prefs;
  bool _remember;
  String _lessonName;
  String _lessonLecturer;
  String _selectedDay;
  String _selectedHour;
  String _selectedMinute;
  DateTime _lessonDateTime;
  int _numberOfAbsences;
  int _numberOfAbsenceRights;
  var _lessonAddKey = GlobalKey<FormState>();
  var _lessonUpdateKey = GlobalKey<FormState>();
  List<Lesson> _lessons;
  List<DropdownMenuItem> _lessonsDropDownItems;
  Lesson _selectedLesson;
  DBHelper _dbHelper;

  @override
  void initState() {
    // TODO: implement initState
    _remember = false;
    super.initState();
    _lessons = [];
    _lessonsDropDownItems = [];
    _dbHelper = DBHelper();
    _dbHelper.allLessons().then((mapList) {
      for (Map map in mapList) {
        _lessons.add(Lesson.fromMap(map));
      }
      setState(() {
        _lessonsDropDownItems = _itemsLesson(_lessons);
      });
    }).catchError((err) => print(err.toString()));
    _getSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Ders Ayarları",
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
                  //Add Lesson
                  InkWell(
                    onTap: () {
                      _addLessonDialog(context);
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width - 10,
                        //height: (MediaQuery.of(context).size.height - 50)/10,
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
                                Icons.post_add_outlined,
                                size: 30,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Ders Ekle",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Comfortaa-Bold",
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                  //Update Lesson
                  InkWell(
                    onTap: () {
                      _updateLessonDialog(context);
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width - 10,
                        //height: (MediaQuery.of(context).size.height - 50)/10,
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
                                "Ders Güncelle",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Comfortaa-Bold",
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                  //Delete Lesson
                  InkWell(
                    onTap: () {
                      _deleteLessonDialog(context);
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width - 10,
                        //height: (MediaQuery.of(context).size.height - 50)/10,
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
                                Icons.delete_outlined,
                                size: 30,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Ders Sil",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Comfortaa-Bold",
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      _rememberDialog(context);
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
                              "Ders Hatırlatıcısı\nAyarları",
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

//#region Add Controllers
  TextEditingController _addControllerLessonName = TextEditingController();
  TextEditingController _addControllerLessonLecturer = TextEditingController();
  TextEditingController _addControllerNumberOfAbsences = TextEditingController();
  TextEditingController _addControllerNumberOfAbsenceRights = TextEditingController();

//#endregion

//#region Update Controllers
  TextEditingController _controllerLessonName = TextEditingController();
  TextEditingController _controllerNumberOfAbsences = TextEditingController();
  TextEditingController _controllerNumberOfAbsenceRights = TextEditingController();
  TextEditingController _controllerLessonLecturer = TextEditingController();

//#endregion

//#region Dialogs
  _addLessonDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Text(
                  "Ders Ekle",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Comfortaa-Bold",
                  ),
                ),
                content: SingleChildScrollView(
                  padding: EdgeInsets.all(8),
                  child: Form(
                    key: _lessonAddKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _addControllerLessonName,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ders adı boş olamaz.';
                            }
                            return null;
                          },
                          onSaved: (lessonName) {
                            _lessonName = lessonName;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.book_outlined),
                            hintText: 'Ders Adı',
                            labelText: 'Ders Adı',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          controller: _addControllerNumberOfAbsences,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              _addControllerNumberOfAbsences.text = "0";
                            }
                            return null;
                          },
                          onSaved: (absences) {
                            _numberOfAbsences = int.parse(absences);
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.bar_chart),
                            hintText: 'Devamsızlık Sayısı',
                            labelText: 'Devamsızlık Sayısı',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          controller: _addControllerNumberOfAbsenceRights,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              _addControllerNumberOfAbsenceRights.text = "0";
                            }
                            return null;
                          },
                          onSaved: (absenceRights) {
                            _numberOfAbsenceRights = int.parse(absenceRights);
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.menu),
                            hintText: 'Devamsızlık Hakkı',
                            labelText: 'Devamsızlık Hakkı',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          controller: _addControllerLessonLecturer,
                          onSaved: (lessonLecturer) {
                            _lessonLecturer = lessonLecturer;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outline),
                            hintText: 'Öğretim Görevlisi',
                            labelText: 'Öğretim Görevlisi',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Ders gününü seçmediğiniz takdirde eklediğiniz ders, ders programında "Zamanı Belirtilmemiş Dersler" kısmında görüntülenir.',
                          style: TextStyle(
                              fontFamily: "Comfortaa-Light",
                              fontSize: 12
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        //Select a Day From Week
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Gün:',
                              style: TextStyle(
                                fontFamily: "Comfortaa-Bold",
                              ),
                            ),
                            DropdownButtonHideUnderline(
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(),
                                ),
                                child: DropdownButton(
                                  hint: Text(
                                    "Bir gün seçin.",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Comfortaa-Bold",
                                    ),
                                  ),
                                  value: _selectedDay,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedDay = value;
                                    });
                                    print(_selectedDay);
                                  },
                                  items: _weekDaysItems(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        //Select Time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Saat:',
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
                                      items: _itemsNumber(24),
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
                                      items: _itemsNumber(60),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                          setState(() {
                            _addControllerLessonName.text = "";
                            _addControllerNumberOfAbsences.text = "";
                            _addControllerNumberOfAbsenceRights.text = "";
                            _addControllerLessonLecturer.text = "";
                            _selectedDay = null;
                            _selectedHour = null;
                            _selectedMinute = null;
                          });
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
                          if (_lessonAddKey.currentState.validate()) {
                            _lessonAddKey.currentState.save();
                            DateTime ldt = _calculateLessonDT(_selectedDay, _selectedHour ?? "0", _selectedMinute ?? "0") ?? DateTime(2500);
                            _dbHelper.addLesson(Lesson(_addControllerLessonName.text, true, _addControllerLessonLecturer.text ?? "", ldt, int.parse(_addControllerNumberOfAbsences.text) ?? 0, int.parse(_addControllerNumberOfAbsenceRights.text) ?? 0));
                            _lessons.add(Lesson(_addControllerLessonName.text, true, _addControllerLessonLecturer.text ?? "", ldt, int.parse(_addControllerNumberOfAbsences.text) ?? 0, int.parse(_addControllerNumberOfAbsenceRights.text) ?? 0));
                            setState(() {
                              _lessonsDropDownItems = _itemsLesson(_lessons);
                            });
                            print(ldt.toString());
                            print("Add lesson.");
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Ders kaydedildi."),
                              duration: Duration(seconds: 1),
                            ));
                            _addControllerNumberOfAbsences.text = "";
                            _addControllerNumberOfAbsenceRights.text = "";
                            _addControllerLessonName.text = "";
                            _addControllerLessonLecturer.text = "";
                            _selectedDay = null;
                            _selectedHour = null;
                            _selectedMinute = null;
                            setState(() {});
                          }
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

  _updateLessonDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                  title: Text(
                    "Ders Düzenle",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Comfortaa-Bold",
                    ),
                  ),
                  content: SingleChildScrollView(
                    padding: EdgeInsets.all(8),
                    child: Form(
                      key: _lessonUpdateKey,
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
                                isExpanded: true,
                                hint: Text(
                                  "Güncellemek için bir ders seçin.",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Comfortaa-Bold",
                                  ),
                                ),
                                value: _selectedLesson,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedLesson = value;
                                    _controllerLessonName.text =
                                        _selectedLesson.lessonName;
                                    _controllerNumberOfAbsences.text =
                                        _selectedLesson.numberOfAbsences
                                            .toString();
                                    _controllerNumberOfAbsenceRights.text =
                                        _selectedLesson.numberOfAbsenceRights
                                            .toString();
                                    _controllerLessonLecturer.text =
                                        _selectedLesson.lessonLecturer;
                                    if(!(_selectedLesson.lessonDateTime == DateTime(2500))){
                                      _selectedDay = _getWeekDay(_selectedLesson);
                                      _selectedHour = _getHour(_selectedLesson);
                                      _selectedMinute = _getMinute(_selectedLesson);
                                    }
                                    else{
                                      Workmanager().cancelByTag('lr${_selectedLesson.id}');
                                    }
                                  });
                                },
                                items: _lessonsDropDownItems,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: _controllerLessonName,
                            onSaved: (lessonName) {
                              _lessonName = lessonName;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.book_outlined),
                              hintText: 'Ders Adı',
                              labelText: 'Ders Adı',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _controllerNumberOfAbsences,
                            onSaved: (absences) {
                              _numberOfAbsences = int.parse(absences);
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.bar_chart),
                              hintText: 'Devamsızlık Sayısı',
                              labelText: 'Devamsızlık Sayısı',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _controllerNumberOfAbsenceRights,
                            onSaved: (absenceRights) {
                              _numberOfAbsenceRights = int.parse(absenceRights);
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.menu),
                              hintText: 'Devamsızlık Hakkı',
                              labelText: 'Devamsızlık Hakkı',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: _controllerLessonLecturer,
                            onSaved: (lessonLecturer) {
                              _lessonLecturer = lessonLecturer;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person_outline),
                              hintText: 'Öğretim Görevlisi',
                              labelText: 'Öğretim Görevlisi',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Ders gününü seçmediğiniz takdirde eklediğiniz ders, ders programında "Zamanı Belirtilmemiş Dersler" kısmında görüntülenir.',
                            style: TextStyle(
                              fontFamily: "Comfortaa-Light",
                              fontSize: 12
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          //Select a Day From Week
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Gün:',
                                style: TextStyle(
                                  fontFamily: "Comfortaa-Bold",
                                ),
                              ),
                              DropdownButtonHideUnderline(
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(),
                                  ),
                                  child: DropdownButton(
                                    hint: Text(
                                      "Bir gün seçin.",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Comfortaa-Bold",
                                      ),
                                    ),
                                    value: _selectedDay,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedDay = value;
                                      });
                                      print(_selectedDay);
                                    },
                                    items: _weekDaysItems(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          //Select Time
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Saat:',
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
                                        items: _itemsNumber(24),
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
                                        items: _itemsNumber(60),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                            setState(() {
                              _selectedLesson = null;
                              _controllerLessonName.text = "";
                              _controllerNumberOfAbsences.text = "";
                              _controllerNumberOfAbsenceRights.text = "";
                              _controllerLessonLecturer.text = "";
                              _selectedDay = null;
                              _selectedHour = null;
                              _selectedMinute = null;
                            });
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
                            if (_selectedLesson != null) {
                              _lessonUpdateKey.currentState.save();
                              //await _prefs.setString('OgrenciAdi', _name.toString());
                              print("Update lesson.");
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Ders kaydedildi."),
                                duration: Duration(seconds: 1),
                              ));
                              _lessons.remove(_selectedLesson);
                              _selectedLesson.lessonLecturer = _controllerLessonLecturer.text ?? "";
                              _selectedLesson.lessonName = _controllerLessonName.text;
                              _selectedLesson.numberOfAbsences = int.parse(_controllerNumberOfAbsences.text);
                              _selectedLesson.numberOfAbsenceRights = int.parse(_controllerNumberOfAbsenceRights.text);
                              DateTime ldt = _calculateLessonDT(_selectedDay, _selectedHour ?? "0", _selectedMinute ?? "0") ?? DateTime(2500);
                              _selectedLesson.lessonDateTime = ldt;
                              _dbHelper.updateLesson(_selectedLesson);
                              _lessons.add(_selectedLesson);
                              _selectedLesson = null;
                              _selectedMinute = null;
                              _selectedHour = null;
                              _selectedDay = null;
                              _controllerLessonName.text = "";
                              _controllerNumberOfAbsences.text = "";
                              _controllerNumberOfAbsenceRights.text = "";
                              _controllerLessonLecturer.text = "";
                              if(_selectedLesson.lessonDateTime!=DateTime(2500)){
                                Workmanager().registerOneOffTask("lesson${_selectedLesson.id}", "lessonRemember", tag: "lr${_selectedLesson.id}", inputData:{'id': _selectedLesson.id, 'name': _selectedLesson.lessonName}, existingWorkPolicy: ExistingWorkPolicy.replace);
                              }
                              setState(() {
                                _lessonsDropDownItems = _itemsLesson(_lessons);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ]);
            },
            //child: ,
          );
        });
  }

  _deleteLessonDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Text(
                  "Ders Sil",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Comfortaa-Bold",
                  ),
                ),
                content: SingleChildScrollView(
                  padding: EdgeInsets.all(8),
                  child: Form(
                    child: DropdownButtonHideUnderline(
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(),
                        ),
                        child: DropdownButton(
                          isExpanded: true,
                          hint: Text(
                            "Silmek için bir ders seçin.",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Comfortaa-Bold",
                            ),
                          ),
                          value: _selectedLesson,
                          onChanged: (value) {
                            setState(() {
                              _selectedLesson = value;
                            });
                            setState(() {});
                          },
                          items: _lessonsDropDownItems,
                        ),
                      ),
                    ),
                  ),
                ),
                actions: [
                  ButtonBar(
                    children: [
                      TextButton(
                        child: Text(
                          'Sil',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Comfortaa-Bold",
                            color: Colors.red,
                          ),
                        ),
                        onPressed: () async {
                          if (_selectedLesson != null) {
                            //await _prefs.setString('OgrenciAdi', _name.toString());
                            _dbHelper.deleteLesson(_selectedLesson.id);
                            _lessons.remove(_selectedLesson);
                            Workmanager().cancelByTag('lr${_selectedLesson.id}');
                            //_lessonsDropDownItems = _itemsLesson(_lessons);
                            setState(() {
                              //_lessons = _listRepair(_lessons);
                              _selectedLesson = null;
                              _lessonsDropDownItems = _itemsLesson(_lessons);
                            });
                            print("Delete lesson.");

                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Ders silindi."),
                              duration: Duration(seconds: 1),
                            ));
                          }
                        },
                      ),
                      TextButton(
                        child: Text(
                          'İptal',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Comfortaa-Bold",
                            color: Colors.blue,
                          ),
                        ),
                        onPressed: () {
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

  _rememberDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                "Ders Hatırlatıcısı",
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
                          isExpanded: true,
                          hint: Text(
                            "Bir ders seçin.",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Comfortaa-Bold",
                            ),
                          ),
                          value: _selectedLesson,
                          onChanged: (value) {
                            setState(() {
                              _selectedLesson = value;
                              if(!(_selectedLesson.lessonDateTime == DateTime(2500))){
                                _selectedDay = _getWeekDay(_selectedLesson);
                                _selectedHour = _getHour(_selectedLesson);
                                _selectedMinute = _getMinute(_selectedLesson);
                              }
                            });
                          },
                          items: _lessonsDropDownItems,
                        ),
                      ),
                    ),
                    SwitchListTile(
                      value: _remember ?? false,
                      onChanged: (value) {
                        setState(() {
                          _remember = value;
                          if(_remember == false){
                            _selectedMinute = null;
                            _selectedHour = null;
                          }
                        });

                      },
                      title: Text(
                        "Hatırlatma Yapılsın",
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
                          'Şu kadar\ndakika önce\nhatırlatılsın:',
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
                                  items: _itemsNumber(60),
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
                      "Ders saatinden seçtiğiniz dakika kadar önce size bir hatırlatma bildirimi gönderilir. En fazla 59 dakika öncesi için bir hatırlatma talep edebilirsiniz.",
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
                        if (_selectedLesson != null) {
                          if (_selectedMinute == null) {
                            _remember ? _selectedMinute = "30" : _selectedMinute = null;
                          }
                          _prefs.setBool('Remember', _remember);
                          if(_remember){
                            DateTime qdt = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, int.parse(_selectedHour) ?? 23, int.parse(_selectedMinute) ?? 0);
                            if(qdt.isBefore(DateTime.now())){
                              qdt = qdt.add(Duration(days: 1));
                            }
                            _prefs.setString('Remember${_selectedLesson.id}', _selectedMinute);
                            String s = _selectedLesson.lessonDateTime.toString();
                            Duration drt = DateTimeRange(start: DateTime.now(), end: _selectedLesson.lessonDateTime.subtract(Duration(minutes: int.parse(_selectedMinute)))).duration;
                            Workmanager().registerPeriodicTask('0', 'periodicControlTask', tag: 'control', frequency: Duration(hours: 1), existingWorkPolicy: ExistingWorkPolicy.keep,);
                            Workmanager().registerOneOffTask("lesson${_selectedLesson.id}", "lessonRemember", tag: "lr${_selectedLesson.id}", inputData:{'id': _selectedLesson.id, 'name': _selectedLesson.lessonName, 'ldt': s, 'mins': _selectedMinute}, initialDelay: drt, existingWorkPolicy: ExistingWorkPolicy.replace);
                            print(DateTimeRange(start: DateTime.now(), end: qdt).duration.toString());
                          }
                          else{
                            Workmanager().cancelByTag('lr${_selectedLesson.id}');
                          }
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Tercihiniz kaydedildi."),
                            duration: Duration(seconds: 1),
                          ));
                          setState(() {});
                        }
                        else{
                          Navigator.of(context).pop();
                        }
                        print("Save the choice.");

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

//#endregion

//region Helper Methods
  _getSharedPrefs() async {
    SharedPreferences.getInstance().then((value) {
      _prefs = value;
      setState(() {
        if(_prefs.containsKey("Remember")){
          _remember = _prefs.getBool('Remember') ?? false;
        }
        else{
          _remember = false;
          _prefs.setBool('Remember', false);
        }
      });
    });
  }

  List<DropdownMenuItem> _itemsNumber(int num) {
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

  List<DropdownMenuItem> _itemsLesson(List<Lesson> lessons) {
    List<DropdownMenuItem> listLesson = [];

    for (Lesson lesson in lessons) {
      if (lesson != null) {
        listLesson.add(DropdownMenuItem(
          value: lesson,
          child: lesson.lessonLecturer == null || lesson.lessonLecturer == ""
              ? Text(
                  '${lesson.lessonName}',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Comfortaa-Bold",
                  ),
                )
              : Column(
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
        ));
      }
    }
    return listLesson;
  }

  List<DropdownMenuItem> _weekDaysItems() {
    return <DropdownMenuItem>[
      DropdownMenuItem(
        value: 'Pazartesi',
        child: Text(
          'Pazartesi',
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Comfortaa-Bold",
          ),
        ),
      ),
      DropdownMenuItem(
        value: 'Salı',
        child: Text(
          'Salı',
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Comfortaa-Bold",
          ),
        ),
      ),
      DropdownMenuItem(
        value: 'Çarşamba',
        child: Text(
          'Çarşamba',
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Comfortaa-Bold",
          ),
        ),
      ),
      DropdownMenuItem(
        value: 'Perşembe',
        child: Text(
          'Perşembe',
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Comfortaa-Bold",
          ),
        ),
      ),
      DropdownMenuItem(
        value: 'Cuma',
        child: Text(
          'Cuma',
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Comfortaa-Bold",
          ),
        ),
      ),
      DropdownMenuItem(
        value: 'Cumartesi',
        child: Text(
          'Cumartesi',
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Comfortaa-Bold",
          ),
        ),
      ),
      DropdownMenuItem(
        value: 'Pazar',
        child: Text(
          'Pazar',
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Comfortaa-Bold",
          ),
        ),
      ),
    ];
  }

  DateTime _calculateLessonDT(String day, String hour, String minute) {
    try {
      int monday = 1;
      int tuesday = 2;
      int wednesday = 3;
      int thursday = 4;
      int friday = 5;
      int saturday = 6;
      int sunday = 7;
      int h = int.parse(hour) ?? 0;
      int m = int.parse(minute) ?? 0;
      DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, h, m);

      switch (day) {
        case "Pazartesi":
          if (now.weekday == monday) {
            double lessont = double.parse(now.hour.toString()) +
                double.parse(now.minute.toString()) / 60.0;
            double nowt = double.parse(DateTime.now().hour.toString()) +
                double.parse(DateTime.now().minute.toString()) / 60.0;
            if (lessont < nowt) {
              now = now.add(Duration(days: 1));
            }
          }
          while (now.weekday != monday) {
            now = now.add(new Duration(days: 1));
          }
          return now;
          break;

        case "Salı":
          if (now.weekday == tuesday) {
            double lessont = double.parse(now.hour.toString()) +
                double.parse(now.minute.toString()) / 60.0;
            double nowt = double.parse(DateTime.now().hour.toString()) +
                double.parse(DateTime.now().minute.toString()) / 60.0;
            if (lessont < nowt) {
              now = now.add(Duration(days: 1));
            }
          }
          while (now.weekday != tuesday) {
            now = now.add(new Duration(days: 1));
          }
          return now;
          break;

        case "Çarşamba":
          if (now.weekday == wednesday) {
            double lessont = double.parse(now.hour.toString()) +
                double.parse(now.minute.toString()) / 60.0;
            double nowt = double.parse(DateTime.now().hour.toString()) +
                double.parse(DateTime.now().minute.toString()) / 60.0;
            if (lessont < nowt) {
              now = now.add(Duration(days: 1));
            }
          }
          while (now.weekday != wednesday) {
            now = now.add(new Duration(days: 1));
          }
          return now;
          break;

        case "Perşembe":
          if (now.weekday == thursday) {
            double lessont = double.parse(now.hour.toString()) +
                double.parse(now.minute.toString()) / 60.0;
            double nowt = double.parse(DateTime.now().hour.toString()) +
                double.parse(DateTime.now().minute.toString()) / 60.0;
            if (lessont < nowt) {
              now = now.add(Duration(days: 1));
            }
          }
          while (now.weekday != thursday) {
            now = now.add(new Duration(days: 1));
          }
          return now;
          break;

        case "Cuma":
          if (now.weekday == friday) {
            double lessont = double.parse(now.hour.toString()) +
                double.parse(now.minute.toString()) / 60.0;
            double nowt = double.parse(DateTime.now().hour.toString()) +
                double.parse(DateTime.now().minute.toString()) / 60.0;
            if (lessont < nowt) {
              now = now.add(Duration(days: 1));
            }
          }
          while (now.weekday != friday) {
            now = now.add(new Duration(days: 1));
          }
          return now;
          break;

        case "Cumartesi":
          if (now.weekday == saturday) {
            double lessont = double.parse(now.hour.toString()) +
                double.parse(now.minute.toString()) / 60.0;
            double nowt = double.parse(DateTime.now().hour.toString()) +
                double.parse(DateTime.now().minute.toString()) / 60.0;
            if (lessont < nowt) {
              now = now.add(Duration(days: 1));
            }
          }
          while (now.weekday != saturday) {
            now = now.add(new Duration(days: 1));
          }
          return now;
          break;

        case "Pazar":
          if (now.weekday == sunday) {
            double lessont = double.parse(now.hour.toString()) +
                double.parse(now.minute.toString()) / 60.0;
            double nowt = double.parse(DateTime.now().hour.toString()) +
                double.parse(DateTime.now().minute.toString()) / 60.0;
            if (lessont < nowt) {
              now = now.add(Duration(days: 1));
            }
          }
          while (now.weekday != sunday) {
            now = now.add(new Duration(days: 1));
          }
          return now;
          break;
      }
    } catch (e) {
      return DateTime(2500);
    }
  }

  String _getWeekDay(Lesson selectedLesson) {
    if (selectedLesson.lessonDateTime.weekday == 1) {
      return 'Pazartesi';
    } else if (selectedLesson.lessonDateTime.weekday == 2) {
      return 'Salı';
    } else if (selectedLesson.lessonDateTime.weekday == 3) {
      return 'Çarşamba';
    } else if (selectedLesson.lessonDateTime.weekday == 4) {
      return 'Perşembe';
    } else if (selectedLesson.lessonDateTime.weekday == 5) {
      return 'Cuma';
    } else if (selectedLesson.lessonDateTime.weekday == 6) {
      return 'Cumartesi';
    } else if (selectedLesson.lessonDateTime.weekday == 7) {
      return 'Pazar';
    } else {
      return null;
    }
  }

  String _getHour(Lesson selectedLesson) {
    int hour = selectedLesson.lessonDateTime.hour;
    if (hour <= 9) {
      return '0$hour';
    } else {
      return '$hour';
    }
  }

  String _getMinute(Lesson selectedLesson) {
    int minute = selectedLesson.lessonDateTime.minute;
    if (minute <= 9) {
      return '0$minute';
    } else {
      return '$minute';
    }
  }
//#endregion
}
