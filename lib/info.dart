import 'package:flutter/material.dart';
import 'About_Penyakit.dart';

class InfoPenyakit extends StatefulWidget {

  @override
  _InfoPenyakitState createState() => _InfoPenyakitState();
}
class _InfoPenyakitState extends State<InfoPenyakit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Pilih Informasi Penyakit"),
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
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset('assets/info.png', width: 200, height: 200),
            Divider(
              height: 20,
            ),
            new Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => AboutPenyakit(0),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/logoDM.png', width: 80, height: 80),
                        SizedBox(height: 10),
                        Text("Diabetes Melitus", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                )
            ),
            SizedBox(height: 10),
            new Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => AboutPenyakit(1),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/logoHiper.png', width: 80, height: 80),
                        SizedBox(height: 10),
                        Text("Hipertensi", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}