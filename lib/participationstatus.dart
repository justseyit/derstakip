import 'package:flutter/material.dart';
import 'package:projectautumn/utils/dbhepler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/lesson.dart';

class AttendanceStatus extends StatefulWidget {
  @override
  _AttendanceStatusState createState() => _AttendanceStatusState();
}

class _AttendanceStatusState extends State<AttendanceStatus> {
  List<Lesson> _lessons = [];
  List<Lesson> _criticalLessons;
  SharedPreferences _prefs;
  bool _lightMode;
  DBHelper _dbHelper;

  @override
  void initState() {
    _lightMode = false;// TODO: implement initState
    super.initState();

    _lessons = [];
    _criticalLessons = [];
    _dbHelper = DBHelper();
    //_dbHelper.deleteAllOfTheLessonTable();
    _dbHelper.allLessons().then((mapList) {
      for(Map map in mapList) {
        _lessons.add(Lesson.fromMap(map));
      }
      _getCriticalLessons(_lessons);
      setState(() {

      });
    }).catchError((err) => print("Devamsızlık hata: "+err.toString()));
    /*for(int i = 0; i<10; i++){
      _lessons.add(Lesson("Ders ${i+1}", true, "", null, 4, 15));
    }*/
    _getSharedPrefs();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //hpc = Provider.of<HomepageC>(context);
    //psc = Provider.of<ParticipationStatusC>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Devam Durumu",
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
              width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width*(80/1080),
              //height: (MediaQuery.of(context).size.height - MediaQuery.of(context).size.height*(600/2160)) / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: _lightMode == false ? Colors.black87 : Colors.grey.shade600,
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //BAŞLIK
                    Text(
                      "Devam Durumu Kritik Olan Dersler",
                      style: TextStyle(
                        fontFamily: "Comfortaa-Bold",
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _criticalLessonsW(_criticalLessons),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 30,
              //height: (MediaQuery.of(context).size.height - MediaQuery.of(context).size.height*(150/2160)) / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.black87,
                  width: 2,
                ),
                //color: Colors.black87,
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //BAŞLIK
                    Text(
                      "Tüm Devam Durumları",
                      style: TextStyle(
                        fontFamily: "Comfortaa-Bold",
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _allLessons(_lessons),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _criticalLessonsW(List<Lesson> lessons) {
    try {
      List<Widget> textButtons = [];
      if(lessons != null){
        for (Lesson lesson in lessons) {
          textButtons.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                child: Text(
                  "${lesson.lessonName}",
                  style: TextStyle(
                    fontFamily: "Comfortaa-Light",
                    fontSize: 25,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.start,
                ),
                onTap: () => print("${lesson.lessonName}"),
              ),
            ),
          );
          textButtons.add(SizedBox(
            height: 4,
          ));
          textButtons.add(Container(
            height: 1,
            width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width*(150/1080),
            decoration: BoxDecoration(
              color: Colors.white12,
            ),
          ),);
          textButtons.add(SizedBox(
            height: 4,
          ));
          print("kritiklere eklendi");
        }
        return lessons == null || lessons.isEmpty || lessons.length == 0 ? Center(
          child: Container(
            child: Text(
              'Harika! Kritik Ders Bulunamadı.',
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Comfortaa-Bold",
              ),
            ),
          ),
        ) : Container(
          height: ((MediaQuery.of(context).size.height - MediaQuery.of(context).size.height*(150/2160)) / 2) - MediaQuery.of(context).size.height*(540/2160),
          child: ListView(
            children: textButtons,
          ),
        );
      }
      else{
        return Container(
          //height: ((MediaQuery.of(context).size.height - MediaQuery.of(context).size.height*(150/2160)) / 2) - MediaQuery.of(context).size.height*(540/2160),
          child: Center(
            child: Text(
              "Veri Yok",
              style: TextStyle(
                fontFamily: "Comfortaa-Light",
                fontSize: 25,
                color: Colors.red,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        );
      }
    }catch(e){
      return Container(
        child: Text(
          'Üzgünüz, bir hata oluştu. Hata ayrıntısı şurada:\n$e\n\nLütfen ders ekleyip bu sayfayı tekrar ziyaret edin. Eğer hata devam ediyorsa lütfen ekran görüntüsü alarak geliştiriciyi haberdar edin. Teşekkürler.',
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Comfortaa-Light",
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

  }

  Widget _allLessons(List<Lesson> lessons) {
    try{
      List<Widget> textButtons = [];
      for (Lesson lesson in lessons) {
        textButtons.add(
            ListTile(
              title: Text(
                "${lesson.lessonName}",
                style: lesson.numberOfAbsences > lesson.numberOfAbsenceRights && lesson.numberOfAbsenceRights != 0 || (lesson.numberOfAbsenceRights-lesson.numberOfAbsences) < lesson.numberOfAbsences && lesson.numberOfAbsenceRights != 0 && lesson.attendanceBool ? TextStyle(
                  fontFamily: "Comfortaa-Light",
                  fontSize: 25,
                  color: Colors.red,
                ):TextStyle(
                  fontFamily: "Comfortaa-Light",
                  fontSize: 25,
                ),
              ),
              subtitle: Text(
                lesson.numberOfAbsences > lesson.numberOfAbsenceRights  && lesson.numberOfAbsenceRights != 0 ? "Yapılan Devamsızlık: ${lesson.numberOfAbsences.toString()}\nDevamsızlık hakkı aşıldı! " : "Yapılan Devamsızlık: ${lesson.numberOfAbsences.toString()}\nKalan Devamsızlık Hakkı: ${(lesson.numberOfAbsenceRights - lesson.numberOfAbsences) < 0 ? "Bilinmiyor" : (lesson.numberOfAbsenceRights - lesson.numberOfAbsences).toString()}",
                style: lesson.numberOfAbsences > lesson.numberOfAbsenceRights && lesson.numberOfAbsenceRights != 0 || (lesson.numberOfAbsenceRights-lesson.numberOfAbsences) < lesson.numberOfAbsences && lesson.numberOfAbsenceRights != 0 && lesson.attendanceBool ? TextStyle(
                  fontFamily: "Comfortaa-Light",
                  fontSize: 14,
                  color: Colors.red,
                ):TextStyle(
                  fontFamily: "Comfortaa-Light",
                  fontSize: 14,
                ),
              ),
              onTap: (){
                print("${lesson.lessonName}");
              },
            )
        );
        print("Tüm devam durumlarına eklendi.");
        /*textButtons.add(
        InkWell(
          child: Text(
            "$name",
            style: TextStyle(
              fontFamily: "Comfortaa-Light",
              fontSize: 25,
            ),
            textAlign: TextAlign.start,
          ),
          onTap: () => print("$name"),
        ),
      );*/
        textButtons.add(SizedBox(
          height: 4,
        ));
        textButtons.add(Container(
          height: 1,
          width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width*(50/1080),
          decoration: BoxDecoration(
            color: Colors.black87,
          ),
        ));
        textButtons.add(SizedBox(
          height: 4,
        ));
      }
      return lessons == null || lessons.isEmpty || lessons.length == 0 ? Center(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Veri Yok',
                style: TextStyle(
                  fontSize: 35,
                  fontFamily: "Comfortaa-Bold",
                ),
              ),
              Text(
                'Neden biraz ders eklemiyorsunuz?',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Comfortaa-Light",
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ) : Container(
        height: ((MediaQuery.of(context).size.height - MediaQuery.of(context).size.height*(150/2160)) / 2) - MediaQuery.of(context).size.height*(250/2160),
        child: ListView(
          children: textButtons,
        ),
      );
    }
    catch(e){
      return Container(
        child: Text(
          'Üzgünüz, bir hata oluştu. Hata ayrıntısı şurada:\n$e\n\nLütfen ders ekleyip bu sayfayı tekrar ziyaret edin. Eğer hata devam ediyorsa lütfen ekran görüntüsü alarak geliştiriciyi haberdar edin. Teşekkürler.',
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Comfortaa-Light",
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  _getSharedPrefs() async{
    SharedPreferences.getInstance().then((value){
      _prefs = value;
      if(!_prefs.containsKey('LightMode')){
        setState(() {
          _lightMode = false;
        });
        _prefs.setBool('LightMode', false);
      }
      else{
        setState(() {
          _lightMode = _prefs.getBool('LightMode') ?? false;
        });
      }
    });
  }

  _getCriticalLessons(List<Lesson> lessons) {
    for(Lesson lesson in lessons){
      if(lesson.attendanceBool){
        if(lesson.numberOfAbsences/lesson.numberOfAbsenceRights>0.68){
          _criticalLessons.add(lesson);
          print("kritiklere eklenecek listeye eklendi");
        }
      }
    }
  }
}
