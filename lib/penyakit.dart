class penyakit{
  int id;
  String nama, pengertian, penyebab, solusi, obat_herbal;

  penyakit(this.id, this.nama, this.pengertian, this.penyebab, this.solusi, this.obat_herbal);

  penyakit.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    nama = jsonMap['nama'];
    pengertian = jsonMap['pengertian'];
    penyebab = jsonMap['penyebab'];
    solusi = jsonMap['solusi'];
    obat_herbal = jsonMap['obat_herbal'];
  }

  Map<String, dynamic> toJson() => {
    'id' : id,
    'nama': nama,
    'pengertian': pengertian,
    'penyebab': penyebab,
    'solusi': solusi,
    'obat_herbal' : obat_herbal,
  };
}