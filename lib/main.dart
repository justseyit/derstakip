
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:projectautumn/absencequestion.dart';
import 'package:projectautumn/homepage.dart';
import 'package:projectautumn/utils/dbhepler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'models/lesson.dart';
import 'models/receivednotification.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin(); //Bildiriimler için yeri bir FlutterLocalNotificationsPlugin nesnesi oluşturduk.
String selectedNotificationPayload; //Seçili olan bildirimin içinde veri tutabilmek için bir değişken atadık.
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>(); //Alınan bildirimlerin nesne özelliğine göre alınıp alınmadığını belirlemek için bir BehaviorSubject nesnesi tanımladık.

final BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>(); //Seçilen bildirimi tutmak için ise ayrı bir BehaviorSubject tanımladık.
DateTime questionDT; //Devamsızlık sorusu sorulacak zamanı tutmak için.
bool question; //Soru sorulsun mu yoksa sorulmasın mı bunu belirlemek için.
DateTime ndt; //Günlük dersleri belirleyebilmek için seçilen devamsızlık sorusu zamanından tam 24 saat öncesini tutmak için.
DBHelper _dbh = DBHelper(); //Veritabanı bağlantısı için bir veritabanı nesnesi.
List<Lesson> today; //Bugünkü dersleri tutmak için.
List<Lesson> alles; //Bütün dersleri tutmak için.

//Workmanager ile arkaplan görevlerini yaparken kullanılacak olan BackgroundTaskHandler tipindeki fonksiyonu içeren callback metodu.
callbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async { //(task, inputData) async {} şeklindekii isimsiz fonksiyon, BackgroundTaskHandler tipindeki fonksiyondur.
    switch(task){ //Her görev için bu fonksiyon çağırılır ve task String'ine göre hangi görev yapılacaksa o case çalıştırılır.
      case 'notificationTask':
        print("Native called background task.");
        _getLessons().then((value){
          alles = value;
          for(Lesson lesson in alles){
            if(lesson.lessonDateTime.isBefore(DateTime.now())){
              lesson.lessonDateTime = _calculateLessonDT(lesson.lessonDateTime.weekday, lesson.lessonDateTime.hour, lesson.lessonDateTime.minute);
              _dbh.updateLesson(lesson);
            }
          }
          today = _getTodaysLessons(value);
        });
        _showNotification();
        break;

      case 'periodicControlTask':
        _getLessons().then((value){
          alles = value;
          for(Lesson lesson in alles){
            if(lesson.lessonDateTime.isBefore(DateTime.now())){
              lesson.lessonDateTime = _calculateLessonDT(lesson.lessonDateTime.weekday, lesson.lessonDateTime.hour, lesson.lessonDateTime.minute);
              _dbh.updateLesson(lesson);
            }
          }
        });
        break;

      case 'lessonRemember':
        _showRememberNotification(inputData);
        Workmanager().registerOneOffTask('oneoffcontrol', 'periodicControlTask',);
        DateTime dtime = DateTime.parse(inputData['ldt']);
        Duration drt = DateTimeRange(start: DateTime.now(), end: dtime.subtract(Duration(minutes: int.parse(inputData['mins'])))).duration;
        Workmanager().registerPeriodicTask('0', 'periodicControlTask', tag: 'control', frequency: Duration(hours: 1), existingWorkPolicy: ExistingWorkPolicy.keep);
        Workmanager().registerOneOffTask("lesson${inputData['id']}", "lessonRemember", tag: "lr${inputData['id']}", inputData:{'id': inputData['id'], 'name': inputData['name'], 'ldt': inputData['ldt'], 'mins': inputData['mins']}, initialDelay: drt, existingWorkPolicy: ExistingWorkPolicy.replace);
        break;

    }
    return Future.value(true);//Görevin başarılı olduğuna dair true şeklinde bool değer geriye döndürülür.
  });
}

Future<void> main() async { //main() metodu
  WidgetsFlutterBinding.ensureInitialized(); //Widget ağacının kurulu olduğundan emin olmak için bu yöntem çağırılır.
  _getLessons().then((value){ //Veritabanından tüm dersleri çekmek için _getLessons() çağırılır. .then içindeki (value){} isimsiz fonksiyonu, _getLessons()'ın asenkron olarak çekip bize gönderdiği verileri liste halinde tutar ve kullanmamıza olanak verir.
    alles = value; //Tüm derslerin atamasını yaptık.
    today = _getTodaysLessons(value); //Bugünkü dersleri ayırması adına _getTodaysLessons()'ı çağırdık.
  });
  //today = await _getTodaysLessons(les);

  //await _configureLocalTimeZone();
  //_scheduleNotification();
  //_cancelAllNotifications();
  //Workmanager().cancelAll();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false); //Workmanager eklentisini, initialize ettik yani başlattık.
  // Periodic task registration
  //#region workmanagerreg
  Workmanager().registerPeriodicTask('0', 'periodicControlTask', tag: 'control', frequency: Duration(hours: 1), existingWorkPolicy: ExistingWorkPolicy.keep);
  //#endregion

  final NotificationAppLaunchDetails notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();//Bildirimden başlatılan uygulamanın detaylarını tutmak için.
  String initialRoute = MyHome.routeName; //Uygulamanın açılış şekline göre belirlenen rota adını tutmak için.
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("@mipmap/launcher_icon"); //Bildirimin ikonunu ayarladık.

  if (notificationAppLaunchDetails.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails.payload;
    if(today.isEmpty || today == null || today.length == 0){
      initialRoute = MyHome.routeName;
    }
    initialRoute = AbsenceDialog.routeName;
  }
  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    selectedNotificationPayload = payload;
    selectNotificationSubject.add(payload);
  });
  runApp(Phoenix(child: MyApp()));
}

DateTime _calculateLessonDT(int day, int hour, int minute) {
  try {
    const int monday = 1;
    const int tuesday = 2;
    const int wednesday = 3;
    const int thursday = 4;
    const int friday = 5;
    const int saturday = 6;
    const int sunday = 7;
    DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, hour ?? 0, minute ?? 0);

    switch (day) {
      case monday:
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

      case tuesday:
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

      case wednesday:
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

      case thursday:
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

      case friday:
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

      case saturday:
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

      case sunday:
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

      default:
        return DateTime(DateTime.now().year + 13);
        break;
    }
  } catch (e) {
    return DateTime(DateTime.now().year + 13);
  }
}

Future<void> _showNotification() async {
  if(today == null || today.isEmpty|| today.length == 0){
    const BigTextStyleInformation btsi = BigTextStyleInformation(
      'Görünüşe göre bugün eklemeniz gereken bir devamsızlık bilgisi yok. İyi günler!',
      htmlFormatBigText: true,
      contentTitle: 'Harika!',
      htmlFormatContentTitle: true,
      summaryText: 'Devamsızlık Takibi',
      htmlFormatSummaryText: true,
    );
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('0', 'com.chainbreak.derstakip', 'projectderstakip',
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: btsi,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Devamsızlık Takibi',
      'Görünüşe göre bugün eklemeniz gereken bir devamsızlık bilgisi yok. İyi günler!',
      //RepeatInterval.everyMinute,
      //_nextInstanceOfDT('00','21'),
      platformChannelSpecifics,
      //payload: 'item x',
      //androidAllowWhileIdle: true,
      //uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      //matchDateTimeComponents: DateTimeComponents.time,
    );
  }
  else
  {
    const BigTextStyleInformation btsi = BigTextStyleInformation(
      'Bugünkü dersleriniz için devamsızlık bilginizi kaydetmek ister misiniz? Bunun için lütfen tıklayın.',
      htmlFormatBigText: true,
      contentTitle: 'Devamsızlık Kaydı',
      htmlFormatContentTitle: true,
      summaryText: 'Devamsızlık Takibi',
      htmlFormatSummaryText: true,
    );
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('0', 'com.chainbreak.derstakip', 'projectderstakip',
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: btsi,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Devamsızlık Takibi',
      'Bugünkü dersleriniz için devamsızlık bilginizi kaydetmek ister misiniz? Bunun için tıklayın.',
      //RepeatInterval.everyMinute,
      //_nextInstanceOfDT('00','21'),
      platformChannelSpecifics,
      //payload: 'item x',
      //androidAllowWhileIdle: true,
      //uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      //matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}

Future<void> _showRememberNotification(Map lesson) async {
  BigTextStyleInformation btsi = BigTextStyleInformation(
    '${lesson['mins'].toString()} dakika sonra ${lesson['name'].toString()} dersiniz var.',
    htmlFormatBigText: true,
    contentTitle: 'Hatırlatma',
    htmlFormatContentTitle: true,
    summaryText: 'Ders Hatırlatıcısı',
    htmlFormatSummaryText: true,
  );
  AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('0', 'com.chainbreak.derstakip', 'projectderstakip',
    playSound: true,
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    styleInformation: btsi,
  );
  NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    'Ders Hatırlatıcısı',
    '${lesson['mins'].toString()} dakika sonra ${lesson['name'].toString()} dersiniz var.',
    //RepeatInterval.everyMinute,
    //_nextInstanceOfDT('00','21'),
    platformChannelSpecifics,
    //payload: 'item x',
    //androidAllowWhileIdle: true,
    //uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    //matchDateTimeComponents: DateTimeComponents.time,
  );
}

Future<void> _cancelAllNotifications() async { //Beklemede olanlar da dahil tüm bildirimleri iptal eder.
  await flutterLocalNotificationsPlugin.cancelAll();
}

Future<List<Lesson>> _getLessons() async{ //Veritabanından, kayıtlı tüm dersleri çeker.
  DBHelper _helper = DBHelper(); //Veritabanı sınıfı nesnesi.
  List<Lesson> lessons = [];
  _helper.allLessons().then((value){ //DBHelper sınıfı içinde bulunan allLessons() metodundan aldığı Map şeklindeki derslerin listesini, .then() içindeki (value){} isimsiz fonksiyonuna parametre olarak verir.
    if (value != null) {
      for(Map map in value){ //Alınan map listesini tek tek döner.
        lessons.add(Lesson.fromMap(map)); //map şeklindeki veriyi, Lesson sınıfında yer alan fromMap() kurucusuyla Lesson nesnesine çevirir. Ardından lessons[] listesine ekler.
      }
    }
  });
  return lessons; //Geriye lessons listesini döndürür.
}

_getTodaysLessons(List<Lesson> lessons) {
  List<Lesson> todays = [];
  if (lessons != null) {
    for(Lesson lesson in lessons){
      if(lesson.lessonDateTime.isBefore(questionDT) && lesson.lessonDateTime.isAfter(ndt)){
        todays.add(lesson);
      }
    }
  }
  return todays;
}

/*Future<DateTime> _getSharedPrefsForQuestion() async{
  DateTime dt;
  SharedPreferences _prefs;
  await SharedPreferences.getInstance().then((value){
    _prefs = value;
    if(_prefs.containsKey("SelectedQHour") && _prefs.containsKey("SelectedQMinute") && _prefs.containsKey("Question")){
      question = _prefs.getBool("Question") ?? true;
      dt = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, int.parse(_prefs.getString("SelectedQHour")) ?? 23, int.parse(_prefs.getString("SelectedQMinute")) ?? 0);
      if(dt.isBefore(DateTime.now())){
        dt = dt.add(Duration(days: 1));
      }
      //questionDT = dt;
      return dt;
    }
    else{
      question = true;
      DateTime dt = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 0);
      if(dt.isBefore(DateTime.now())){
        dt = dt.add(Duration(days: 1));
      }
      //questionDT = dt;
      //ndt = questionDT.subtract(Duration(days: 1));
      return dt;
    }
  });
  return dt;
}*/


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences _prefs;
  bool _lightMode = false;
  //List<Lesson> _lessons;

  @override
  void initState() {
    // TODO: implement initState
    _lightMode = false;
    super.initState();
    //_lessons = [];
    //_sharedPreferences = SharedPreferences.getInstance();
    _getSharedPrefs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Ders Takip",
      theme: _lightMode == false ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      initialRoute: "/main",
      routes: {
        MyHome.routeName : (_) => MyHome(),
        AbsenceDialog.routeName : (_) => AbsenceDialog(lessons: today,)
      },
      //home: MyHome(),
    );
  }

  _getSharedPrefs() async {
    SharedPreferences.getInstance().then((value) {
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
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHome()));
    //Phoenix.rebirth(context);
  }
}

class MyHome extends StatefulWidget {
  static const String routeName = "/main";
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  bool _lightMode = false;
  @override
  void initState() {
    _lightMode = false;
    super.initState();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Homepage());
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      Navigator.pushNamed(context, '/ques');
    });
  }
  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream.listen((ReceivedNotification receivedNotification) async {
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: receivedNotification.title != null ? Text(receivedNotification.title) : null,
            content: receivedNotification.body != null ? Text(receivedNotification.body) : null,
            actions: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  await Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return AbsenceDialog(lessons: today,);
                        }
                    ),
                  );
                },
                child: const Text('Ok'),
              )
            ],
          );
        },
      );
    });
  }
}
