import 'package:flutter/material.dart';
import 'dart:io';
import 'Content.dart';
import 'Riwayat.dart';
import 'info.dart';
import 'koneksi.dart';
import 'perhitungan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  final keyIsFirstLoaded = null;
  //'is_first_loaded';
  SaveDB _db;
  Perhitungan per = new Perhitungan();
  Map<int, Data>_myMap = new Map<int, Data>();

  showDialogIfFirstLoaded(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLoaded = prefs.getBool(keyIsFirstLoaded);

    Dialog dialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.info,color: Colors.blue,
                  size: 28,
                ),
                Text(" Apa itu Hiditus ?", style: TextStyle(fontSize: 18)),
              ],
            ),
            Divider(height: 20, color: Colors.black,),
            Text("Hiditus adalah aplikasi sistem pakar diagnosis dini penyakit diabetes melitus dan hipertensi menggunakan metode certainty factor.", style: TextStyle(fontSize: 16), textAlign: TextAlign.left),
            Divider(height: 20, color: Colors.white),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.blue,
                      onPressed: () {
                        // Close the dialog
                        Navigator.of(context).pop();
                        prefs.setBool(keyIsFirstLoaded, false);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("  Tutup", style: TextStyle(fontSize: 18,color: Colors.white)),
                        ],
                      )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (isFirstLoaded == null) {
      showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return dialog;
        },
      );
    }
  }

  showAlertDialog(BuildContext context) {
    Dialog dialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.warning,color: Colors.red,
                  size: 28,
                ),
                Text(" Konfirmasi", style: TextStyle(fontSize: 18),),
              ],
            ),
            Divider(height: 20, color: Colors.black,),
            Text("Apakah anda ingin keluar dari program sekarang?", style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),
            Divider(height: 20, color: Colors.white),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.blue,
                      onPressed: () => Navigator.pop(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                              Icons.clear, color: Colors.white,
                          ),
                          Text("   Batal", style: TextStyle(fontSize: 18,color: Colors.white)),
                        ],
                      )
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  flex: 1,
                  child:  RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.blue,
                      onPressed: () => exit(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                              Icons.check,color: Colors.white,
                          ),
                          Text("   Keluar", style: TextStyle(fontSize: 18, color: Colors.white)),
                        ],
                      )
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
    showDialog(
//      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }
  showMasukDialog(BuildContext context) async{
    _myMap = await getRiwayat();
    Dialog dialog = Dialog (
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.warning,color: Colors.red,
                size: 28,
              ),
              Text(" Konfirmasi", style: TextStyle(fontSize: 18),),
            ],
          ),
          Divider(height: 20, color: Colors.black,),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ConstrainedBox(constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ContentPage(null),
                        ));
                  },
                  child: FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Icon(
                            Icons.add_circle_outline, color: Colors.white,
                          ),
                          Text(" Mulai diagnosis baru", style: TextStyle(fontSize: 18, color: Colors.white)),
                        ],
                      )
                  ),
                ),
              ),
              ConstrainedBox(constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  color: Colors.blue,
                  onPressed: _myMap != null ? () async{
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ContentPage(_myMap),
                        ));
                  }:null,
                  child: FittedBox(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.repeat, color: Colors.white,
                          ),
                          Text(" Lanjutkan diagnosis terakhir", style: TextStyle(fontSize: 18, color: Colors.white)),
                        ],
                      )
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      ),
    );
    showDialog(
//      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }
  Future _doneFuture;

  Future<Map<int, Data>> getRiwayat() async{
    return await SaveDB.mulai.GetLastRiwayat();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => showDialogIfFirstLoaded(context));
    getRiwayat().then((x){
      setState(() {
        _myMap = x;
      });
    });
  }
  Future get initializationDone => _doneFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Row(
          children: <Widget>[
            Icon(Icons.home, color: Colors.white),
            Text("\t\t\t\t\t\t\t" + widget.title),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.1, 1, 0.9],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Colors.white,
              Colors.grey,
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/logo_app.png', width: 200, height: 200),
              Padding(
                padding: EdgeInsets.all(0.0),
              ),
              SizedBox(height: 30),
              new Container(
                padding: EdgeInsets.only(left:10.0, right:10.0),
                child: Column(
                    children: <Widget>[
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () => showMasukDialog(context),
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      // Where the linear gradient begins and ends
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      // Add one stop for each color. Stops should increase from 0 to 1
                                      stops: [0.1, 1],
                                      colors: [
                                        // Colors are easy thanks to Flutter's Colors class.
                                        Colors.blue,
                                        Colors.blue[900],
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Icon(Icons.play_circle_outline, size: 100, color: Colors.white),
                                      Text("Mulai Diagnosis", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                ),
                              )
                          ),
                          SizedBox(width: 10),
                          new Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => InfoPenyakit(),
                                    )),
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      // Where the linear gradient begins and ends
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      // Add one stop for each color. Stops should increase from 0 to 1
                                      stops: [0.1, 1],
                                      colors: [
                                        // Colors are easy thanks to Flutter's Colors class.
                                        Colors.blue,
                                        Colors.blue[900],
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Icon(Icons.info_outline, size: 100, color: Colors.white),
                                      Text("Info Penyakit", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                ),
                              )
                          ),
                        ],
                      )
                    ]
                ),
              ),

              new Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                    children: <Widget>[
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => Riwayat(),
                                    )),
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      // Where the linear gradient begins and ends
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      // Add one stop for each color. Stops should increase from 0 to 1
                                      stops: [0.1, 1],
                                      colors: [
                                        // Colors are easy thanks to Flutter's Colors class.
                                        Colors.blue,
                                        Colors.blue[900],
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Icon(Icons.history, size: 100, color: Colors.white),
                                      Text("Riwayat Diagnosis", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                ),
                              )
                          ),
                          SizedBox(width: 10),
                          new Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () => showAlertDialog(context),
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      // Where the linear gradient begins and ends
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      // Add one stop for each color. Stops should increase from 0 to 1
                                      stops: [0.1, 1],
                                      colors: [
                                        // Colors are easy thanks to Flutter's Colors class.
                                        Colors.blue,
                                        Colors.blue[900],
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Icon(Icons.close, size: 100, color: Colors.white),
                                      Text("Keluar Aplikasi", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                ),
                              )
                          ),
                        ],
                      )
                    ]
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}