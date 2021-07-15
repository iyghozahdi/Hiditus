import 'package:flutter/material.dart';
import 'koneksi.dart';

class AboutPenyakit extends StatefulWidget {

  @override
  AboutPenyakitState createState() => new AboutPenyakitState();
  AboutPenyakit(this.dat);
  int dat;
}

class AboutPenyakitState extends State<AboutPenyakit> {

  @override
  Widget build(BuildContext context) {
    var data = SaveDB.mulai.getPenyakit;
    var dat = data.firstWhere((e) => e.id == widget.dat);
    return Scaffold(
      appBar: AppBar(
        title: Text(dat.nama),
        centerTitle: false,
      ),
    body: Column(
      children: <Widget>[
        Expanded(
          child: new ListView(
              padding: const EdgeInsets.all(15.0),
              children: <Widget>[
                new Card(
                  child: new Container(
                    padding: new EdgeInsets.all(15.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text('Apa itu '+ dat.nama +' ?', style: TextStyle(fontSize: 16), textAlign: TextAlign.left),
                        Divider(color: Colors.blue,),
                        new Text(dat.pengertian, style: TextStyle(fontSize: 16), textAlign: TextAlign.left)
                      ],
                    ),
                  ),
                ),
                Divider(color:Colors.white,height: 10,),
                new Card(
                  child: new Container(
                    padding: new EdgeInsets.all(15.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text('Apa penyebab '+ dat.nama +' ?', style: TextStyle(fontSize: 16), textAlign: TextAlign.left),
                        Divider(color: Colors.blue,),
                        new Text(dat.penyebab, style: TextStyle(fontSize: 16), textAlign: TextAlign.left),
                      ],
                    ),
                  ),
                ),
                Divider(color:Colors.white,height: 10,),
                new Card(
                  child: new Container(
                    padding: new EdgeInsets.all(15.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text('Apa solusi untuk '+ dat.nama +' ?', style: TextStyle(fontSize: 16), textAlign: TextAlign.left),
                        Divider(color: Colors.blue,),
                        new Text(dat.solusi, style: TextStyle(fontSize: 16), textAlign: TextAlign.left),
                      ],
                    ),
                  ),
                ),
                Divider(color:Colors.white,height: 10,),
                new Card(
                  child: new Container(
                    padding: new EdgeInsets.all(15.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text('Apa saja obat herbal untuk '+ dat.nama +' ?', style: TextStyle(fontSize: 16), textAlign: TextAlign.left),
                        Divider(color: Colors.blue,),
                        new Text(dat.obat_herbal, style: TextStyle(fontSize: 16), textAlign: TextAlign.left),
                      ],
                    ),
                  ),
                ),
              ]
          ),
        ),
        Divider(color: Colors.black, height: 10),
        Align(
            alignment: FractionalOffset.bottomCenter,
            child: RaisedButton(
              onPressed: ()=> Navigator.popUntil(
                  context,
                  ModalRoute.withName('/MyHomePage')
              ),
              color: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.blue[900],
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.home, color: Colors.white
                    ),
                    Text(
                      "   Kembali Ke Menu Utama",
                      style: new TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
        ),
      ],
    ),
    );
  }
}
