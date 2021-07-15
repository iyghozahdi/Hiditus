import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Hasil.dart';
import 'aturan.dart';
import 'perhitungan.dart';
import 'koneksi.dart';

class ContentPage extends StatefulWidget {
  @override
  ContentState createState() => new ContentState();
  ContentPage(this.map);
  Map<int, Data>map;
}

class ContentState extends State<ContentPage> {
  bool isButtonEnabled = false;
  int cf = 0;
  double vale = 0;
  Map<int, bool>_termsChecked = new Map<int, bool>();
  Map<int, Data>_myMap = new Map<int, Data>();
  SaveDB _db;

  @override
  void initState() {
    super.initState();
    _db = SaveDB.mulai;
    if (widget.map != null){
        widget.map.forEach((x,y){
          setState(() {
            _termsChecked[x] = true;
          });
        });
      }
    if (_termsChecked.isNotEmpty){
      setState(() {
        _myMap = widget.map;
        _myMap.forEach((x,y){
          selectedkeyakinan[x] = GetKeyakinan(y.nk);
        });
      });
    }
    if(_myMap.length > 1){
      isButtonEnabled = true;
    }else{
      isButtonEnabled=false;
    }
  }

  GetKeyakinan(double x){
    int tk ;
    if (x == 1.0)
      tk = 0;
    else if (x == 0.7)
      tk = 1;
    else if (x == 0.4)
      tk = 2;
    else
      tk = 3;
    return tk;
  }
  
  List<int> selectedkeyakinan = new List(50);
  List<dataCF> keyakinan = [
    new dataCF("Sangat Yakin", 1.0),
    new dataCF("Yakin", 0.7),
    new dataCF("Sedikit Yakin", 0.4),
    new dataCF("Ragu-Ragu", 0.1),
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Pilih Gejala'),
        centerTitle: false,
//        actions: <Widget>[
//          IconButton(
//              icon: Icon(Icons.clear_all),
//              onPressed: (){
//                setState(() {
//                  selectedkeyakinan = new List(50);
//                  _termsChecked.clear();
//                  _myMap.clear();
//                });
//              })
//        ],
      ),
      body: Center(
          child: new Column(
              children: [
                new Container(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Expanded(child: new Text("Pilihlah gejala yang sesuai dengan gejala yang anda alami \n(minimal 2 gejala)", style: TextStyle(fontSize: 18), textAlign: TextAlign.left)),
                      Image.asset('assets/pilihan.png', width: 75, height: 75),
                    ],
                  ),
                ),
                Divider(color: Colors.black, height: 1),
                new Expanded(
                  child: ListView.builder(
                      itemCount: _db.getGejala.length,
                      itemExtent: 60.0,
                      itemBuilder: (BuildContext context, int index) {
                        var _gejala = _db.getGejala[index];
                        return new CheckboxListTile(
                          title: Text(_gejala.nama, style: TextStyle(fontSize: 16)),
                          subtitle: selectedkeyakinan[index]!=null ? Text('${keyakinan[selectedkeyakinan[index]].keyakinan}') : null,
                          value: _termsChecked[index] ?? false,
                          onChanged: (bool value) {
                            if (value) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SimpleDialog(
                                      title: Text("Tingkat Keyakinan"),
                                      children: keyakinan.map((x){
                                        return SimpleDialogOption(
                                          child: Text(x.keyakinan),
                                          onPressed: ()async{
                                            List<aturan> _aturan = new List();
                                            _aturan = await _db.GetCF(index);
                                            _aturan.forEach((x){
                                              if(x.id_penyakit==0){
                                                _gejala.cf_dm = x.nilai_cf;
                                              } else
                                                _gejala.cf_hp = x.nilai_cf;;
                                            });
                                            setState(() {
                                              selectedkeyakinan[index] = keyakinan.indexOf(x);
                                              _termsChecked[index] = value;
                                              Navigator.pop(context);

                                              dynamic _nk = keyakinan[selectedkeyakinan[index]].nilai;
                                              Data _data = new Data(_nk is double ? _nk : _nk.toDouble(), _gejala);
                                              _myMap[index] = _data;
                                              if(_myMap.length > 1){
                                                isButtonEnabled = true;
                                              }else{
                                                isButtonEnabled=false;
                                              }
                                            });
                                          },
                                        );
                                      }).toList(),
                                    );
                                  });
                            }else{
                              setState(() {
                                _termsChecked[index] = value;
                                selectedkeyakinan[index] = null;
                              });
                              _myMap.remove(index);
                              if(_myMap.length > 1){
                                isButtonEnabled = true;
                              }else{
                                isButtonEnabled=false;
                              }
                            }
                          },
                        );
                      }),
                    ),
                Divider(color: Colors.black, height: 5),
                RaisedButton(
                  onPressed: isButtonEnabled?() async {
                      String tgl = DateFormat("dd-MM-yyyy H:m").format(
                          DateTime.now());
                      var baru = _myMap.keys.toList();
                      baru.sort((a, b) => a - b);
                      List<Data> terbaru = List();
                      baru.forEach((i) async{
                        terbaru.add(_myMap[i]);
                      });
                      Perhitungan per = new Perhitungan(
                        tgl: tgl,
                        mylist: terbaru,
                      );
                      per.penyakit = per.getHasil();
                      _db.SaveRiwayat(per);
//                      if (!saved) return;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Hasil(per: per),
                          )
                      );
                  }:null,
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.blue[900],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                          Icons.assessment, color: Colors.white,
                      ),
                      Text(
                        "  Hasil Diagnosis",
                        style: new TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                )
              ])
          ));
  }
}


class dataCF {
  String keyakinan;
  double nilai;

  dataCF(this.keyakinan, this.nilai);
  

}