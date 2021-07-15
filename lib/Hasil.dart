import 'package:flutter/material.dart';
import 'package:skripsiprogram/penyakit.dart';
import 'penyakit.dart';
import 'perhitungan.dart';
import 'koneksi.dart';

class Hasil extends StatefulWidget {
  Perhitungan per;
  Hasil({Key key, @required this.per}) : super(key: key);

  @override
  HasilState createState() => new HasilState();
}

class HasilState extends State<Hasil> {

  String tk(double x){
    String tk = "";
        if (x == 1.0)
          tk = "Sangat Yakin";
        else if (x == 0.7)
          tk = "Yakin";
        else if (x == 0.4)
          tk = "Sedikit Yakin";
        else
          tk = "Ragu-Ragu";
    return tk;
  }

  Map<String, double> dataMap = new Map();
  String getNama(List<penyakit> test){
    return test.map((e) => e.nama).toList().join(" dan ");
  }



  @override
  Widget build(BuildContext context) {
    var data = SaveDB.mulai.getPenyakit;
    var dat = data.where((a) => widget.per.getHasil().contains(a.id.toString())).toList();
    double max = widget.per.max;
    return new Scaffold(
        appBar: AppBar(
          title: Text('Hasil Diagnosis'),
          centerTitle: false,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Divider(color: Colors.white,height: 8.0),
                        Image.asset('assets/hasil.png', width: 200, height: 200),
                        Divider(color: Colors.white,height: 8.0),
                        Container(
                          child: ListTile(
                            title: Text(
                                (dat.length > 1 ? "Certainty factor bernilai sama : "+max.toStringAsFixed(4)+"\nMaka anda memiliki kemungkinan terkena penyakit " : "Certainty factor tertinggi : "+max.toStringAsFixed(4)+"\nMaka anda memiliki kemungkinan terkena penyakit ")  +  getNama(dat) + " sebesar "+ (max*100).toStringAsFixed(2)+"%.",
                                style: TextStyle(fontSize: 16, color: Colors.black),
                                textAlign: TextAlign.left
                            ),
                            subtitle: Text(
                                (max > 0.5 ? "\nCatatan: Segera periksakan diri anda ke dokter terdekat untuk melakukan pengecekan lebih lanjut":"\nCatatan: Lakukan pemeriksaan secara berkala sesuai dengan kebutuhan"),
                                style: TextStyle(fontSize: 14, color: Colors.red),
                                textAlign: TextAlign.left
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            children: <Widget>[
                              Container(
                                child: Text("0.0"),
                              ),
                              Expanded(
                                  child: Slider(
                                      max: 1.0,
                                      min: 0.0,
                                      value: max,
                                      label: max.toStringAsFixed(5),
                                      divisions: 1000,
                                      onChanged: (x){
                                        setState(() {
                                          max = max;
                                        });
                                      })
                              ),
                              Container(
                                child: Text("1.0"),
                              )
                            ],

                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.only(top:5,bottom: 5),
                          child : Card(
                              shape: RoundedRectangleBorder(
                                  side: new BorderSide(color: Colors.blue, width: 1.0),
                                  borderRadius: BorderRadius.circular(4.0)),
                            child: Container(
                              padding: EdgeInsets.only(top:5,bottom: 5),
                              child: ListTile(
                                title: Text(
                                    "Solusi untuk penyakit "+ getNama(dat) +" : ",
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.left
                                ),
                                subtitle: Column(
                                  children: dat.map((e) => Text(
                                      "\n"+ e.solusi,
                                      style: TextStyle(fontSize: 16, color: Colors.black),
                                      textAlign: TextAlign.left
                                  )).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ExpansionTile(
                          title: Text("Apa itu Certainty Factor ? ", style: TextStyle(fontSize: 16)),
                          children: <Widget>[
                            Container(
                              child: ListTile(
                                title: Text("Certainty factor digunakan untuk menunjukkan kepastian ketika kesimpulan didapatkan dari aturan - aturan yang ada. Nilai certainty factor dalam sistem pakar ini hanya menghasilkan nilai certainty factor positif, sehingga memiliki batasan nilai dari 0 sampai 1. Jika nilai certainty factor mendekati angka 1, berarti semakin menuju kepastian. Jika nilai certainty factor mendekati angka 0, berarti semakin menuju ketidakpastian."+
                                    "\n\n(Sumber : Papadopoulos, Andreou, dan Bramer, Artificial Intelligence Aplications and Innovations, 2010)",
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                    textAlign: TextAlign.left
                                ),
                                subtitle: Text(""),
                              ),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          title: Text("Gejala dan tingkat keyakinan yang dipilih", style: TextStyle(fontSize: 16)),
                          children: widget.per.mylist.map((x){
                            return ListTile(
                              title: Text("${x.datgejala.nama}"),
                              subtitle: Text(tk(x.nk)),
                            );
                          }).toList(),
                        ),
                      ]),
                )
            ),
            Divider(color: Colors.black, height: 5),
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
                          Icons.home, color: Colors.white,
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