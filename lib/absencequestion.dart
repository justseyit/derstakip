import 'package:flutter/material.dart';
import 'package:projectautumn/utils/dbhepler.dart';
import 'models/lesson.dart';

class AbsenceDialog extends StatefulWidget {
  static const String routeName = "/ques";
  final List<Lesson> lessons;
  AbsenceDialog({@required this.lessons});
  @override
  _AbsenceDialogState createState() => _AbsenceDialogState();
}

class _AbsenceDialogState extends State<AbsenceDialog> {
  DBHelper _dbHelper;
  Map<String, dynamic> m;
  List<Lesson> _lessonsToBeUpdated;


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dbHelper = DBHelper();
    m = Map<String, dynamic>();
    _lessonsToBeUpdated = [];
    /*_dbHelper.allLessons().then((value){
      for(Map map in value){
        widget.lessons.add(Lesson.fromMap(map));
      }
      setState(() {

      });
    });*/

    if (widget.lessons != null) {
      for(Lesson lesson in widget.lessons){
        m['${lesson.id}'] = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Günlük Devamsızlık Takibi",
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Comfortaa-Bold",
          ),
        ),
      ),
      body: widget.lessons == null || widget.lessons.isEmpty || widget. lessons.length == 0 ? Center(
        child: Container(
          child: Text(
            'Veri Yok',
            style: TextStyle(
              fontSize: 35,
              fontFamily: "Comfortaa-Bold",
            ),
          ),
        ),
      ) : Column(
        children: [
          Container(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(8),
              child: Column(
                children: _showEditableLessonAttendances(context, widget.lessons),
              ),
            ),
          ),
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
                  for(Lesson lesson in widget.lessons){
                    if(m['${lesson.id}'] == false){
                      _lessonsToBeUpdated.add(lesson);
                    }
                  }

                  for(Lesson lesson in _lessonsToBeUpdated){
                    _incrementAbsence(lesson);
                    _dbHelper.updateLesson(lesson);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Devamsızlık kaydedildi."),
                    duration: Duration(seconds: 1),
                  ));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
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
              Checkbox(
                value: m['${lesson.id}'],
                onChanged: (value) {
                  setState(() {
                    m['${lesson.id}'] = value;
                  });
                },
              ),
            ],
          );
        },
      ));
    }
    return leslist;
  }
  _incrementAbsence(Lesson lesson) async{
    lesson.numberOfAbsences++;
    _dbHelper.updateLesson(lesson);
  }
}
