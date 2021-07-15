import 'package:flutter/material.dart';
import 'dart:async';
import 'MenuUtama.dart';
import 'koneksi.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}
const PrimaryColor = Colors.blue;
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Pakar Diagnosa Diabetea Melitus dan Hipertensi',
      theme: ThemeData(
          primaryColor: PrimaryColor,
          primaryTextTheme: TextTheme(
              title: TextStyle(
                  color: Colors.white
              )
          )
      ),
      home: new SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/MyHomePage': (BuildContext context) => new MyHomePage(title: 'Menu Utama')
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }
  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/MyHomePage');
  }

  Widget splash(){
    startTime();
    return new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        new Image.asset('assets/logo_app.png', width: 240, height: 240),
      ]
      )
      );
  }

  @override
  void initState() {
    super.initState();
    startTime();
    SaveDB();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[200],
      body: new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        new Image.asset('assets/logo_app.png', width: 240, height: 240),
      ]
      )
      ),
    );
  }
}