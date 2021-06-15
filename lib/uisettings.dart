import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UISettings extends StatefulWidget {
  @override
  _UISettingsState createState() => _UISettingsState();
}

class _UISettingsState extends State<UISettings> {
  Future<SharedPreferences> _sharedPreferences;
  SharedPreferences _prefs;
  bool _lightMode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _lightMode = false;
    });
    _sharedPreferences = SharedPreferences.getInstance();
    _getSharedPrefs();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Arayüz Ayarları",
          style: TextStyle(
            fontFamily: "Comfortaa-Bold",
          ),
        ),
      ),
      body:  Center(
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
                  //Light Mode
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
                        padding: const EdgeInsets.all(8.0),
                        child: SwitchListTile(
                          value: _lightMode == null ? false:_lightMode,
                          onChanged: (newValue) async{
                            setState(() {
                              _lightMode=newValue;
                              _prefs.setBool('LightMode', newValue);
                            });
                            Phoenix.rebirth(context);
                          },
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              "Açık Renk Modu",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Comfortaa-Bold",
                              ),
                            ),
                          ),
                          subtitle:  Text(
                            "Bu ayarı değiştirdiğinizde, yeni tercihinizi uygulamak için uygulama yeniden başlatılır.",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: "Comfortaa-Light",
                            ),
                          ),
                          secondary: Icon(
                            Icons.wb_sunny_outlined,
                            size: 30,
                          ),
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

  _getSharedPrefs() async{
    _prefs = await _sharedPreferences;
    try{
      setState(() {
        _lightMode = _prefs.getBool('LightMode');
      });
    }
    catch(e){
      _lightMode = false;
      _prefs.setBool('LightMode', false);
    }
  }
}
