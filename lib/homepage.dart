import 'package:flutter/material.dart';
import 'package:projectautumn/settings.dart';
import 'package:projectautumn/lessonprogram.dart';
import 'package:projectautumn/participationstatus.dart';
import 'package:projectautumn/appointmenthistory.dart';
import 'package:projectautumn/upcomingappointments.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Homepage extends StatefulWidget{

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>{
  SharedPreferences _prefs;
  String _name;
  bool _lightMode = false;


  @override
  void initState() {
    _lightMode = false;
    super.initState();
    _getSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * (80 / 2160),
          ),
          //KARŞILAMA
          InkWell(
            child: Container(
              width: MediaQuery.of(context).size.width -
                  MediaQuery.of(context).size.width * (80 / 1080),
              height: (MediaQuery.of(context).size.height -
                      MediaQuery.of(context).size.height * (150 / 2160)) /
                  3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: _lightMode == false ? Colors.black87 : Colors.grey.shade600,
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hoşgeldiniz",
                      style: TextStyle(
                        fontFamily: "Comfortaa-Bold",
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      _name == null || _name == "" ? "" : "sn. $_name",
                      style: TextStyle(
                        fontFamily: "Comfortaa-Light",
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Detayları görmek veya düzenlemek için bir işlem seçiniz. Ayarlar için bu kutuyu tıklayınız.",
                      style: TextStyle(
                        fontFamily: "Comfortaa-Light",
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Settings()))
                  .then((value) {
                setState(() {
                  _name = _prefs.getString('OgrenciAdi');
                  _lightMode = _prefs.getBool('LightMode') ?? false;
                });
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //YAKLAŞAN RANDEVULAR
                InkWell(
                  child: Container(
                    width: ((MediaQuery.of(context).size.width -
                                MediaQuery.of(context).size.width *
                                    (80 / 1080)) /
                            2) -
                        4,
                    height: (MediaQuery.of(context).size.height -
                            MediaQuery.of(context).size.height * (150 / 2160)) /
                        3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: _lightMode == false
                          ? Colors.black87
                          : Colors.grey.shade600,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.laptop_chromebook_outlined,
                            size: 100,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Yaklaşan\nOnline Dersler",
                            style: TextStyle(
                              fontFamily: "Comfortaa-Bold",
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpcomingAppointments()),
                    );
                  },
                ),
                SizedBox(
                  width: 8,
                ),
                //DERS PROGRAMI
                InkWell(
                  child: Container(
                    width: ((MediaQuery.of(context).size.width -
                                MediaQuery.of(context).size.width *
                                    (80 / 1080)) /
                            2) -
                        4,
                    height: (MediaQuery.of(context).size.height -
                            MediaQuery.of(context).size.height * (150 / 2160)) /
                        3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: _lightMode == false
                          ? Colors.black87
                          : Colors.grey.shade600,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 0, height: 0,),
                          Icon(
                            Icons.my_library_books_outlined,
                            size: 100,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Ders\nProgramı",
                            style: TextStyle(
                              fontFamily: "Comfortaa-Bold",
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LessonProgram()));
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //GEÇMİŞ RANDEVULAR
                InkWell(
                  child: Container(
                    width: ((MediaQuery.of(context).size.width -
                                MediaQuery.of(context).size.width *
                                    (80 / 1080)) /
                            2) -
                        4,
                    height: (MediaQuery.of(context).size.height -
                            MediaQuery.of(context).size.height * (150 / 2160)) /
                        3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: _lightMode == false
                          ? Colors.black87
                          : Colors.grey.shade600,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.access_time_outlined,
                            size: 100,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Geçmiş\nOnline Dersler",
                            style: TextStyle(
                              fontFamily: "Comfortaa-Bold",
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppointmentHistory()),
                    );
                  },
                ),
                SizedBox(
                  width: 8,
                ),
                //DEVAM DURUMU
                InkWell(
                  child: Container(
                    width: ((MediaQuery.of(context).size.width -
                                MediaQuery.of(context).size.width *
                                    (80 / 1080)) /
                            2) -
                        4,
                    height: (MediaQuery.of(context).size.height -
                            MediaQuery.of(context).size.height * (150 / 2160)) /
                        3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: _lightMode == false
                          ? Colors.black87
                          : Colors.grey.shade600,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 0, height: 0,),
                          Icon(
                            Icons.bar_chart_outlined,
                            size: 100,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Devam\nDurumu",
                            style: TextStyle(
                              fontFamily: "Comfortaa-Bold",
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AttendanceStatus()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getSharedPrefs() async {
    SharedPreferences.getInstance().then((value) {
      _prefs = value;
      if (!_prefs.containsKey('LightMode')) {
        setState(() {
          _lightMode = false;
        });
        _prefs.setBool('LightMode', false);
      }
      else {
        setState(() {
          _lightMode = _prefs.getBool('LightMode') ?? false;
        });
      }

      if (!_prefs.containsKey('OgrenciAdi')) {
        setState(() {
          _name = '';
        });
        _prefs.setString('OgrenciAdi', '');
      }
      else {
        setState(() {
          _name = _prefs.getString('OgrenciAdi') ?? '';
        });
      }
      //WidgetsBinding.instance.addPostFrameCallback((_) => Phoenix.rebirth(context));
    });
  }
}
