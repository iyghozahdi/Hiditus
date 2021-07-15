class gejala{
  int id;
  String nama;
  double cf_dm, cf_hp;

  gejala(this.id, this.nama, this.cf_dm, this.cf_hp);

  gejala.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    nama = jsonMap['nama'];
    cf_dm = 0;
    cf_hp = 0;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nama': nama,
    'cf_dm': cf_dm,
    'cf_hp': cf_hp,
  };
}