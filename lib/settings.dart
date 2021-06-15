import 'package:flutter/material.dart';
import 'package:projectautumn/about.dart';
import 'package:projectautumn/absencesettings.dart';
import 'package:projectautumn/lessonsettings.dart';
import 'package:projectautumn/studentsettings.dart';
import 'package:projectautumn/uisettings.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ayarlar",
          style: TextStyle(
            fontFamily: "Comfortaa-Bold",
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 8,),
            Container(
              width: MediaQuery.of(context).size.width - 10,
              height: MediaQuery.of(context).size.height - 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Colors.black87,
                    width: 2
                ),
              ),
              child: ListView(
                children: [
                  //Öğrenci Ayarları
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StudentSettings()));
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
                              Icons.person_outline,
                              size: 30,
                            ),
                            SizedBox(width: 20,),
                            Text(
                              "Öğrenci Ayarları",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Comfortaa-Bold",
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                  ),
                  //Ders Ayarları
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LessonSettings()));
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
                                Icons.menu_book_outlined,
                                size: 30,
                              ),
                              SizedBox(width: 20,),
                              Text(
                                "Ders Ayarları",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Comfortaa-Bold",
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                  //Devamsızlık Ayarları
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AbsenceSettings()));
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width - 10,
                        height: (MediaQuery.of(context).size.height - 50)/10,
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
                                Icons.bar_chart_outlined,
                                size: 30,
                              ),
                              SizedBox(width: 20,),
                              Text(
                                "Devamsızlık Ayarları",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Comfortaa-Bold",
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                  //Arayüz Ayarları
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UISettings()));
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width - 10,
                        height: (MediaQuery.of(context).size.height - 50)/10,
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
                                Icons.color_lens_outlined,
                                size: 30,
                              ),
                              SizedBox(width: 20,),
                              Text(
                                "Arayüz Ayarları",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Comfortaa-Bold",
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                  //Hakkında
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width - 10,
                        height: (MediaQuery.of(context).size.height - 50)/10,
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
                                Icons.info_outline,
                                size: 30,
                              ),
                              SizedBox(width: 20,),
                              Text(
                                "Hakkında",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Comfortaa-Bold",
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
      /*Center(
          child: Text(
            "Ayarlar",
            style: TextStyle(
              fontSize: 40,
              fontFamily: "Comfortaa-Bold",
            ),
          ),
      ),*/
    );
  }
}


