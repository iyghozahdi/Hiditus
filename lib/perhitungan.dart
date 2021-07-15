import 'koneksi.dart';
import 'gejala.dart';
import 'dart:math';

class Perhitungan {
  int id;
  List<Data> mylist = new List<Data>();
  var penyakit;
  String tgl;

  Perhitungan({this.mylist, this.tgl});

  double _inputList = 0.0;
  double _inputLits = 0.0;
  double max = 0.0;
  double get inputLits => _inputLits;
  double get inputList => _inputList;

  void setSum() {
    _inputList = 0.0;
    _inputLits = 0.0;
    int i = 0;
    mylist.forEach((val) {
      if (i == 0) {
        _inputList = val.datgejala.cf_dm * val.nk;
        _inputLits = val.datgejala.cf_hp * val.nk;
      } else {
        if(_inputList > 0 && val.datgejala.cf_dm * val.nk > 0)
        _inputList = _inputList + ((val.datgejala.cf_dm * val.nk) * (1 - _inputList));
        else if(_inputList < 0 && val.datgejala.cf_dm * val.nk < 0)
        _inputList = _inputList + ((val.datgejala.cf_dm * val.nk) * (1 + _inputList));
        else
        _inputList = (_inputList + (val.datgejala.cf_dm * val.nk)) / (1 - min(_inputList, (val.datgejala.cf_dm * val.nk)));

        if(_inputLits > 0 && val.datgejala.cf_hp * val.nk > 0)
        _inputLits = _inputLits + ((val.datgejala.cf_hp * val.nk) * (1 - _inputLits));
        else if(_inputLits < 0 && val.datgejala.cf_hp * val.nk < 0)
        _inputLits = _inputLits + ((val.datgejala.cf_hp * val.nk) * (1 + _inputLits));
        else
        _inputLits = (_inputLits + (val.datgejala.cf_hp * val.nk)) / (1 - min(_inputLits, (val.datgejala.cf_hp * val.nk)));
      }
      i++;
    });
  }



  List<String> getHasil() {
    var _penyakit = SaveDB.mulai.getPenyakit;
    setSum();
    var dat ;
    if (_inputList > _inputLits) {
      max = _inputList;
      dat = <String>[_penyakit[0].id.toString()];
    } else if (_inputList < _inputLits) {
      max = _inputLits;
      dat = <String>[_penyakit[1].id.toString()];
    } else{
      max = _inputLits;
      dat = <String>[_penyakit[0].id.toString(), _penyakit[1].id.toString()];
    }
    return dat;
  }

}

class Data {
  double nk;
  gejala datgejala;

  Data(this.nk, this.datgejala);
}
