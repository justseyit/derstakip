import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentSettings extends StatefulWidget {
  @override
  _StudentSettingsState createState() => _StudentSettingsState();
}

class _StudentSettingsState extends State<StudentSettings> {
  String _name;
  var _nameKey = GlobalKey<FormState>();
  SharedPreferences _prefs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSharedPrefs();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //_prefs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Öğrenci Ayarları",
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
                  //Name and Surname
                  InkWell(
                    onTap: (){
                      _showAlertDialogStudentName(context);
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
                                Icons.drive_file_rename_outline,
                                size: 30,
                              ),
                              SizedBox(width: 20,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Adı ve Soyadı Düzenle",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Comfortaa-Bold",
                                    ),
                                  ),
                                  SizedBox(height: 4,),
                                  Text(
                                    _name == null || _name == "" ? "İsim girilmedi." : _name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Comfortaa-Light",
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Aşağıdaki özellikler üzerinde çalışıyoruz. Detaylar için "Hakkında" bölümüne göz atabilirsiniz.',
                        style: TextStyle(
                          //fontSize: 14,
                          fontFamily: "Comfortaa-Light",
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      //borderRadius: BorderRadius.circular(12),
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black87,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  //Select University
                  Container(
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
                              Icons.school_outlined,
                              size: 30,
                            ),
                            SizedBox(width: 20,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Üniversite Seç",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "Comfortaa-Bold",
                                  ),
                                ),
                                SizedBox(height: 4,),
                                Text(
                                  "Seçilen Üniversite",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Comfortaa-Light",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                  ),
                  //University Settings
                  Container(
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
                              Icons.settings_outlined,
                              size: 30,
                            ),
                            SizedBox(width: 20,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Üniversiteye Özel Ayarlar",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "Comfortaa-Bold",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextEditingController _nameController = TextEditingController();

  _showAlertDialogStudentName(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        return AlertDialog(
          title: Text(
            "Adı ve Soyadı Düzenle",
            style: TextStyle(
              fontSize: 20,
              fontFamily: "Comfortaa-Bold",
            ),
          ),
          content: Form(
            key: _nameKey,
            child: TextFormField(
              controller: _nameController,
              onSaved: (name){
                _name = name;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline),
                hintText: 'Adınız ve Soyadınız',
                labelText: 'Ad Soyad',
                border: OutlineInputBorder(),
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
                  onPressed: (){
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
                  onPressed: () {
                    _nameKey.currentState.save();
                    _prefs.setString('OgrenciAdi', _name.toString());
                    _nameController.text = _name.toString();
                    print("Set Student name.");
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("İsim kaydedildi."),duration: Duration(seconds: 1),));
                    setState(() {});
                  },
                ),
              ],
            ),
          ]
        );
      }
    );
  }

  _getSharedPrefs() async{
    SharedPreferences.getInstance().then((value){
      _prefs = value;
      try{
        if(_prefs.containsKey('OgrenciAdi')){
          setState(() {
            _name = _prefs.getString('OgrenciAdi');
            _nameController.text = _name ?? ''.toString();
          });
        }
        else{
          setState(() {
            _name = "";
            _nameController.text = _name ?? '';
          });
        }

      }
      catch(e){
        print(e.toString());
      }
    });
  }
}
