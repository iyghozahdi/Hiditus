import 'Hasil.dart';
import 'package:flutter/material.dart';
import 'koneksi.dart';
import 'perhitungan.dart';
import 'penyakit.dart';

class Riwayat extends StatefulWidget {
  Riwayat({Key key}) : super(key: key);

  @override
  RiwayatState createState() => new RiwayatState();
}

class RiwayatState extends State<Riwayat> {

  bool isselected = false;
  Map<int, bool> selected = new Map();
  List<int> x = new List();
  var dat;

  String getNama(List<penyakit> test){
    return test.map((e) => e.nama).toList().join(" dan ");
  }

  showDialogKeyRiwayat(BuildContext context) async {
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
                Text(" Cara menghapus riwayat", style: TextStyle(fontSize: 18)),
              ],
            ),
            Divider(height: 20, color: Colors.black,),
            Text("Tekan lama pada riwayat yang ingin dihapus, lalu tekan tombol tempat sampah di sebelah kanan atas.", style: TextStyle(fontSize: 16), textAlign: TextAlign.left),
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
                        Navigator.of(context).pop();
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

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        },
      );
  }

  Future<List<Perhitungan>> loadriwayat() async {
    return SaveDB.mulai.PanggilRiwayat();
  }

  AppBar appBar (){
    return AppBar(
      title: Text('Riwayat Diagnosis'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info, color: Colors.white),
              onPressed: ()=> showDialogKeyRiwayat(context),
            ),
          ],
    );
  }

  Future<bool> removeitem(List<int> x) async {
    x.forEach((x){
      SaveDB.mulai.HapusRiwayat(x);
    });
  }

  AppBar contextualAppbar(){
    return AppBar(
      title: Text('Riwayat Diagnosis'),
      backgroundColor: Colors.blue[900],
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            await removeitem(x);
            setState(() => selected.clear());
          },
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return     Scaffold(
      appBar: !selected.values.any((e) => e) ? appBar() : contextualAppbar(),
      body: FutureBuilder(
          future: loadriwayat(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Perhitungan> _data = snapshot.data;
              if(_data.isNotEmpty){
                return Container(
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
                  child: ListView.builder(
                    itemCount: _data.length,
                    itemBuilder: (BuildContext context, int index) {
                      var data = _data[index];
                      dat = _data[index].getHasil();
                      var _penyakit = SaveDB.mulai.getPenyakit;
                      var penyakit = _penyakit.where((a) => dat.contains(a.id.toString())).toList();
                      String tgl = _data[index].tgl;
                      return Card(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        color: selected.keys.any((i)=>i==index)  && selected[index]
                            ? Colors.black26
                            : Colors.white,
                        child: ListTile(
                          title: Text("Anda memiliki kemungkinan terkena penyakit " + getNama(penyakit) + " sebesar "+(data.max*100).toStringAsFixed(2)+"%." , textAlign: TextAlign.left),
                          subtitle: Text('Tanggal : ' + tgl),
                          onTap: () {
                            selected[index] ??= false;
                            if(selected.values.any((e) => e)) {
                              setState(() {
                                selected[index] = !selected[index];
                                if (selected[index]){
                                  x.add(_data[index].id);
                                }else{
                                  x.remove(_data[index].id);
                                }
                              });
                              return;
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => Hasil(per: _data[index]),
                                ));
                          },
                          onLongPress: (){
                            setState(() {
                              x.add(_data[index].id);
                              selected[index] = true;
                            });
                          },
                        ),
                      );
                    },
                  ),
                );
              }else{
                return Container(
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/kosong.png',
                            height: 200,
                            width: 200,
                            alignment: Alignment.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
