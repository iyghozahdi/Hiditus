import 'dart:io';
import 'package:path/path.dart';
import 'package:skripsiprogram/riwayat_model.dart';
import 'package:skripsiprogram/gejala.dart';
import 'package:skripsiprogram/penyakit.dart';
import 'package:skripsiprogram/perhitungan.dart';
import 'package:sqflite/sqflite.dart';
import 'package:skripsiprogram/aturan.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

class SaveDB{
  Future _doneFuture;
  var _db;
  static SaveDB mulai;

  List<gejala> _gejala = List<gejala>();
  List<penyakit> _penyakit = List<penyakit>();

  SaveDB() {
    _doneFuture = _init();
    mulai = this;
  }
  Future get initializationDone => _doneFuture;

  _init() async {
    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, "database.db3");

    var exists = await databaseExists(dbPath);

    if (!exists){
      try{
        await Directory(dirname(dbPath)).create(recursive: true);
      } catch(_){}
      ByteData data = await rootBundle.load(join("assets","db_sistempakar_skripsi.db3"));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes, flush: true);
    }
    _db = await openDatabase(dbPath);

    List<Map> list = await _db.rawQuery('SELECT * FROM gejala order by id');
    _gejala = list.map((e) => gejala.fromJson(e)).toList();

    list = await _db.rawQuery('SELECT * FROM penyakit order by id');
    _penyakit = list.map((e) => penyakit.fromJson(e)).toList();
  }

  SaveRiwayat(Perhitungan per) async{
    int insert;
    await _db.transaction((txn) async {
      insert = await txn.rawInsert(
          "INSERT Into riwayat (tanggal)"
              " VALUES (?)",
          [per.tgl]);
      per.id = insert;
    });
    per.mylist.forEach((x){
      _db.transaction((txn) async {
        await txn.rawInsert(
            "INSERT Into data_riwayat (id_riwayat, id_gejala, penyakit, nk)"
                " VALUES (?,?,?,?)",
            [insert, x.datgejala.id, per.getHasil().join(","), x.nk]);
      });
    });
  }

  List<penyakit> get getPenyakit => _penyakit;

  List<gejala> get getGejala => _gejala;

  Future<Map<int, Data>> GetLastRiwayat()async {
    Map<int, Data> mxmap = new Map();
    List<Map> list = await _db.rawQuery(
        'SELECT * FROM riwayat order by id desc');
    for (var e in list) {
      List<Map> listx = await _db.rawQuery(
          'SELECT * FROM data_riwayat where id_riwayat=' + riwayat_model.fromJson(e).id.toString());
      if(listx == null)
        return null;
      listx.forEach((x) {
        mxmap[x['id_gejala']] =
            Data(x['nk'], _gejala.firstWhere((e) => e.id == x['id_gejala']));
      });

      return mxmap;
    }
  }

  Future<List<aturan>> GetCF(int id_gejala)async {
    List<aturan> _aturan = new List();
    List<Map> list = await _db.rawQuery(
        'SELECT * FROM aturan where id_gejala=' + id_gejala.toString());
    list.forEach((x) {
      _aturan.add(aturan.fromJson(x));
    });
    return _aturan;
  }

  Future<List<Perhitungan>> PanggilRiwayat() async{
    List<Perhitungan> per = new List();
    List<Map> list = await _db.rawQuery('SELECT * FROM riwayat order by id desc');
    for (var e in list) {
      List<Map> listx = await _db.rawQuery('SELECT * FROM data_riwayat where id_riwayat=' + riwayat_model.fromJson(e).id.toString());
      List<Data> mylist = new List();
      listx.forEach((z) {
        gejala a =_gejala.firstWhere((e) => e.id == z['id_gejala']);
        this.GetCF(a.id).then((g) {
          g.forEach((x){
            if(x.id_penyakit==0){
              a.cf_dm = x.nilai_cf;
            } else if(x.id_penyakit==1){
              a.cf_hp = x.nilai_cf;
            }});
        });
        mylist.add(Data(z['nk'], a));
      });
      var itung = Perhitungan(
          mylist: mylist,
          tgl: riwayat_model.fromJson(e).tanggal
      );
      itung.id = riwayat_model.fromJson(e).id;
      per.add(itung);
    }

    return per;
  }

  HapusRiwayat(int id) async{
    await _db.rawDelete('DELETE FROM riwayat WHERE id=' + id.toString());
    await _db.rawDelete('DELETE FROM data_riwayat WHERE id_riwayat=' + id.toString());
  }
}