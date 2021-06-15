import 'package:flutter/material.dart';
import 'package:projectautumn/models/lesson.dart';
import 'package:projectautumn/utils/dbhepler.dart';

class LessonProgram extends StatefulWidget {
  @override
  _LessonProgramState createState() => _LessonProgramState();
}

class _LessonProgramState extends State<LessonProgram> {
  List<Lesson> _lessons;
  List<Lesson> _monLesson;
  List<Lesson> _tueLesson;
  List<Lesson> _wedLesson;
  List<Lesson> _thuLesson;
  List<Lesson> _friLesson;
  List<Lesson> _satLesson;
  List<Lesson> _sunLesson;
  List<Lesson> _nodLesson;
  DBHelper _dbHelper;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dbHelper = DBHelper();
    _lessons = [];
    _monLesson = [];
    _tueLesson = [];
    _wedLesson = [];
    _thuLesson = [];
    _friLesson = [];
    _satLesson = [];
    _sunLesson = [];
    _nodLesson = [];



    //_dbHelper.deleteAllOfTheLessonTable();


    _dbHelper.allLessons().then((mapList){
      for(Map map in mapList){
        _lessons.add(Lesson.fromMap(map));
      }
      _extractLessons(_lessons);
      setState(() {});
    }
    ).catchError((err) => print("Hata: "+err.toString()));

    /*for (int i = 0; i < 10; i++) {
      _monLesson.add(Lesson("pztDers ${i + 1}", true, '', DateTime.now()));
      _tueLesson.add(Lesson("salDers ${i + 1}", true, '', DateTime.now()));
      _wedLesson.add(Lesson("carDers ${i + 1}", true, '', DateTime.now()));
      _thuLesson.add(Lesson("perDers ${i + 1}", true, '', DateTime.now()));
      _friLesson.add(Lesson("cumDers ${i + 1}", true, '', DateTime.now()));
      _satLesson.add(Lesson("ctsDers ${i + 1}", true, '', DateTime.now()));
      _sunLesson.add(Lesson("pazDers ${i + 1}", true, '', DateTime.now()));
      _nodLesson.add(Lesson("nodDers ${i + 1}", true, '', DateTime.now()));
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ders Programı",
          style: TextStyle(
            fontFamily: "Comfortaa-Bold",
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width -
              MediaQuery.of(context).size.width * (80 / 1080),
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).size.height * (300 / 2160),
          child: buildLessonProgram(context),
        ),
      ),
    );
  }

  ListView buildLessonProgram(BuildContext context) {
    return ListView(
      children: [
        //MON
        Container(
          width: MediaQuery.of(context).size.width -
              MediaQuery.of(context).size.width * (80 / 1080),
          //height: MediaQuery.of(context).size.height - 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.black87,
              width: 2,
            ),
            //color: Colors.black87,
          ),
          child: Column(
            children: [
              //Gün Başlığı
              Container(
                width: MediaQuery.of(context).size.width -
                    MediaQuery.of(context).size.width * (80 / 1080),
                height: (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).size.height * (1500 / 2160)) /
                    4,
                decoration: _monLesson.length == 0 ? BoxDecoration() : BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black87,
                      width: 2,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    "PAZARTESİ",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Comfortaa-Bold",
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width -
                    MediaQuery.of(context).size.width * (80 / 1080),
                //height: (MediaQuery.of(context).size.height - 500)*2.9/4,
                child: Column(
                  children: _getLessons(_monLesson),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        //TUE
        Container(
          width: MediaQuery.of(context).size.width -
              MediaQuery.of(context).size.width * (80 / 1080),
          //height: MediaQuery.of(context).size.height - 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.black87,
              width: 2,
            ),
            //color: Colors.black87,
          ),
          child: Column(
            children: [
              //Gün Başlığı
              Container(
                width: MediaQuery.of(context).size.width -
                    MediaQuery.of(context).size.width * (80 / 1080),
                height: (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).size.height * (1500 / 2160)) /
                    4,
                decoration: _tueLesson.length == 0 ? BoxDecoration() : BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black87,
                      width: 2,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    "SALI",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Comfortaa-Bold",
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width -
                    MediaQuery.of(context).size.width * (80 / 1080),
                //height: (MediaQuery.of(context).size.height - 500)*2.9/4,
                child: Column(
                  children: _getLessons(_tueLesson),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        //WED
        Container(
          width: MediaQuery.of(context).size.width -
              MediaQuery.of(context).size.width * (80 / 1080),
          //height: MediaQuery.of(context).size.height - 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.black87,
              width: 2,
            ),
            //color: Colors.black87,
          ),
          child: Column(
            children: [
              //Gün Başlığı
              Container(
                width: MediaQuery.of(context).size.width -
                    MediaQuery.of(context).size.width * (80 / 1080),
                height: (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).size.height * (1500 / 2160)) /
                    4,
                decoration: _wedLesson.length == 0 ? BoxDecoration() : BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black87,
                      width: 2,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    "ÇARŞAMBA",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Comfortaa-Bold",
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width -
                    MediaQuery.of(context).size.width * (80 / 1080),
                //height: (MediaQuery.of(context).size.height - 500)*2.9/4,
                child: Column(
                  children: _getLessons(_wedLesson),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        //THU
        Container(
          width: MediaQuery.of(context).size.width -
              MediaQuery.of(context).size.width * (80 / 1080),
          //height: MediaQuery.of(context).size.height - 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.black87,
              width: 2,
            ),
            //color: Colors.black87,
          ),
          child: Column(
            children: [
              //Gün Başlığı
              Container(
                width: MediaQuery.of(context).size.width -
                    MediaQuery.of(context).size.width * (80 / 1080),
                height: (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).size.height * (1500 / 2160)) /
                    4,
                decoration: _thuLesson.length == 0 ? BoxDecoration() : BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black87,
                      width: 2,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    "PERŞEMBE",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Comfortaa-Bold",
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width -
                    MediaQuery.of(context).size.width * (80 / 1080),
                //height: (MediaQuery.of(context).size.height - 500)*2.9/4,
                child: Column(
                  children: _getLessons(_thuLesson),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        //FRI
        Container(
          width: MediaQuery.of(context).size.width -
              MediaQuery.of(context).size.width * (80 / 1080),
          //height: MediaQuery.of(context).size.height - 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.black87,
              width: 2,
            ),
            //color: Colors.black87,
          ),
          child: Column(
            children: [
              //Gün Başlığı
              Container(
                width: MediaQuery.of(context).size.width -
                    MediaQuery.of(context).size.width * (80 / 1080),
                height: (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).size.height * (1500 / 2160)) /
                    4,
                decoration: _friLesson.length == 0 ? BoxDecoration() : BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black87,
                      width: 2,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    "CUMA",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Comfortaa-Bold",
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width -
                    MediaQuery.of(context).size.width * (80 / 1080),
                //height: (MediaQuery.of(context).size.height - 500)*2.9/4,
                child: Column(
                  children: _getLessons(_friLesson),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        //SAT
        Container(
          width: MediaQuery.of(context).size.width -
              MediaQuery.of(context).size.width * (80 / 1080),
          //height: MediaQuery.of(context).size.height - 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.black87,
              width: 2,
            ),
            //color: Colors.black87,
          ),
          child: Column(
            children: [
              //Gün Başlığı
              Container(
                width: MediaQuery.of(context).size.width -
                    MediaQuery.of(context).size.width * (80 / 1080),
                height: (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).size.height * (1500 / 2160)) /
                    4,
                decoration: _satLesson.length == 0 ? BoxDecoration() : BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black87,
                      width: 2,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    "CUMARTESİ",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Comfortaa-Bold",
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width -
                    MediaQuery.of(context).size.width * (80 / 1080),
                //height: (MediaQuery.of(context).size.height - 500)*2.9/4,
                child: Column(
                  children: _getLessons(_satLesson),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        //SUN
        Container(
          width: MediaQuery.of(context).size.width -
              MediaQuery.of(context).size.width * (80 / 1080),
          //height: MediaQuery.of(context).size.height - 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.black87,
              width: 2,
            ),
            //color: Colors.black87,
          ),
          child: Column(
            children: [
              //Gün Başlığı
              Container(
                width: MediaQuery.of(context).size.width -
                    MediaQuery.of(context).size.width * (80 / 1080),
                height: (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).size.height * (1500 / 2160)) /
                    4,
                decoration: _sunLesson.length == 0 ? BoxDecoration() : BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black87,
                      width: 2,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    "PAZAR",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Comfortaa-Bold",
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width -
                    MediaQuery.of(context).size.width * (80 / 1080),
                //height: (MediaQuery.of(context).size.height - 500)*2.9/4,
                child: Column(
                  children: _getLessons(_sunLesson),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ), //SUN
        Container(
          width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width * (80 / 1080),
          //height: MediaQuery.of(context).size.height - 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.black87,
              width: 2,
            ),
            //color: Colors.black87,
          ),
          child: Column(
            children: [
              //Gün Başlığı
              Container(
                width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width * (80 / 1080),
                height: (MediaQuery.of(context).size.height - MediaQuery.of(context).size.height * (1500 / 2160)) / 4,
                decoration: _nodLesson.length == 0 ? BoxDecoration() :  BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black87,
                      width: 2,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    "ZAMANI BELİRTİLMEMİŞ",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Comfortaa-Bold",
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width * (80 / 1080),
                //height: (MediaQuery.of(context).size.height - 500)*2.9/4,
                child: Column(
                  children: _getLessons(_nodLesson),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  _getLessons(List<Lesson> lessonList) {
    List<Widget> lessons = [];
    String h ="",m="";
    int i = 0;
    for (Lesson lesson in lessonList) {
      lesson.lessonDateTime.hour <= 9 ? h = "0" : h = "";
      lesson.lessonDateTime.minute <= 9 ? m = "0" : m = "";
      h += lesson.lessonDateTime.hour.toString();
      m += lesson.lessonDateTime.minute.toString();
      lesson.lessonDateTime == DateTime(2500) ? lessons.add(
        Container(
          width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width * (80 / 1080),
          //height: (MediaQuery.of(context).size.height - 500)/5,
          decoration: i == lessonList.length-1 ? BoxDecoration() : BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.black87,
              ),
            ),
          ),
          child: Container(
            //width: (MediaQuery.of(context).size.width - 35)*0.7,
            //height: (MediaQuery.of(context).size.height - 500)/5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "${lesson.lessonName}",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Comfortaa-Light",
                  ),
                ),
              ),
            ),
          ),
        ),
      ):
      lessons.add(
        Container(
          width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width * (80 / 1080),
          //height: (MediaQuery.of(context).size.height - 500)/5,
          decoration: i == lessonList.length-1 ? BoxDecoration() : BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.black87,
              ),
            ),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 3,
                child: Container(
                  //width: (MediaQuery.of(context).size.width - 35)*0.3,
                  //height: (MediaQuery.of(context).size.height - 500)/5,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "$h:$m",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Comfortaa-Bold",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 7,
                child: Container(
                  //width: (MediaQuery.of(context).size.width - 35)*0.7,
                  //height: (MediaQuery.of(context).size.height - 500)/5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "${lesson.lessonName}",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Comfortaa-Light",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      i++;
    }
    return lessons;
  }

  _extractLessons(List<Lesson> lessons) {
    for (Lesson lesson in lessons) {
      try{
        if(lesson.lessonDateTime == DateTime(2500)){
          _nodLesson.add(lesson);
        }
        else{
          switch (lesson.lessonDateTime.weekday) {
            case 1:
              _monLesson.add(lesson);
              break;

            case 2:
              _tueLesson.add(lesson);
              break;

            case 3:
              _wedLesson.add(lesson);
              break;

            case 4:
              _thuLesson.add(lesson);
              break;

            case 5:
              _friLesson.add(lesson);
              break;

            case 6:
              _satLesson.add(lesson);
              break;

            case 7:
              _sunLesson.add(lesson);
              break;

            default:
              _nodLesson.add(lesson);
              break;
          }
        }
      }
      catch(e){
        _nodLesson.add(lesson);
      }
    }
  }
}
