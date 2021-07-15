class aturan{
  int id_penyakit, id_gejala;
  double nilai_cf;

  aturan(this.id_penyakit, this.id_gejala, this.nilai_cf);

  aturan.fromJson(Map<String, dynamic> jsonMap) {
    id_penyakit = jsonMap['id_penyakit'];
    id_gejala = jsonMap['id_gejala'];
    nilai_cf = jsonMap['nilai_cf'];
  }

  Map<String, dynamic> toJson() => {
    'id_penyakit' : id_penyakit,
    'id_gejala': id_gejala,
    'nilai_cf': nilai_cf,
  };
}