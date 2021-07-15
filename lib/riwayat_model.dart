class riwayat_model{
  int id;
  String tanggal;

  riwayat_model(this.id, this.tanggal);

  riwayat_model.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    tanggal = jsonMap['tanggal'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'tanggal': tanggal,
  };
}