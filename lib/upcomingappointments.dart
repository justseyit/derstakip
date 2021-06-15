import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectautumn/models/onlinelesson.dart';


class UpcomingAppointments extends StatefulWidget {
  @override
  _UpcomingAppointmentsState createState() => _UpcomingAppointmentsState();
}

class _UpcomingAppointmentsState extends State<UpcomingAppointments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bu bölümde listelenen dersler, test amaçlı olarak oluşturulmuş olan bir ders API\'ı üzerinden alınmaktadır. Detaylar için "Hakkında" bölümüne göz atabilirsiniz.',
                style: TextStyle(
                  fontFamily: "Comfortaa-Bold",
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UpcomingAppointmentsP()),);
                    },
                    child: Text(
                      'Önizlemeyi Görmek İstiyorum',
                      style: TextStyle(
                        fontFamily: "Comfortaa-Bold",
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black87, // background
                      onPrimary: Colors.white, // foreground
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpcomingAppointmentsP extends StatefulWidget {
  @override
  _UpcomingAppointmentsPState createState() => _UpcomingAppointmentsPState();
}

class _UpcomingAppointmentsPState extends State<UpcomingAppointmentsP> {
  List<OnlineLesson> _upcomingOnlineLessons;
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    _upcomingOnlineLessons = [];
    _getLessonsFromAPI().then((value){
      List<OnlineLesson> lessons = [];
      lessons = value;
      for(OnlineLesson lesson in lessons){
        if(!lesson.lessonDateTime.isBefore(DateTime.now())){
          _upcomingOnlineLessons.add(lesson);
        }
      }
      setState(() {});
    });

    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yaklaşan Randevular', style: TextStyle(fontFamily: "Comfortaa-Bold",),),
      ),
      body: _upcomingOnlineLessons == null || _upcomingOnlineLessons.length == 0 || _upcomingOnlineLessons.isEmpty ? Center(child: CircularProgressIndicator()):
      Center(
        child: Container(
          width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width*(10/1080),
          height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height*(50/2160),
          child:ListView(
            children: _listUpcomingOnlineLessons(_upcomingOnlineLessons),
          ),
        ),
      ),
    );
  }

  List<Widget> _listUpcomingOnlineLessons(List<OnlineLesson> lessons){
    List<Widget> onlinelessons = [];
    onlinelessons.add(SizedBox(height: 8,));
    for(OnlineLesson lesson in lessons){
      onlinelessons.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            InkWell(
              onTap: (){
                print('${lesson.lessonName} dersinin linkine git: ${lesson.lessonLink}');
              },
              child: Container(
                width: MediaQuery.of(context).size.width-10,
                height: MediaQuery.of(context).size.height/8,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.menu_book, size: 35,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${lesson.lessonName}', style: TextStyle(fontSize: 20, fontFamily: "Comfortaa-Bold",),),
                        Container(
                          width: MediaQuery.of(context).size.width/1.5,
                          height: 1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.grey,
                          ),
                        ),
                        Text('Ders Zamanı: ${lesson.lessonDateTime.toString()}', style: TextStyle(fontSize: 10, fontFamily: "Comfortaa-Light",),),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_outlined, size: 35,),
                  ],
                ),
                /*child: ListTile(
                      leading: Icon(Icons.menu_book),
                      title: Text('${index+1}. Ders'),
                      subtitle: Text('Ders Zamanı: ${index+1}. dersin saati ve tarihi'),
                      trailing: Icon(Icons.arrow_forward_ios_outlined),
                    ),*/
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.black87,
                      width: 2
                  ),
                ),
              ),
            ),
            SizedBox(height: 4,),
          ],
        ),
      ));
      setState(() {

      });
    }
    return onlinelessons;
  }

  Future<List<OnlineLesson>> _getLessonsFromAPI() async {
    //List<OnlineLesson> listless = [];
    var response = await http.get(Uri.parse("https://raw.githubusercontent.com/seyitahmetgkc/lessonsapi/master/lessons.json"));
    //print(response);
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List).map((e) => OnlineLesson.fromMap(e)).toList();
      //print(parsed);
      //return listless;
    } else {
      throw Exception("Hata oluştu. Kod: ${response.statusCode}");
    }
  }
}

