class KatalogModels {
  final int id;
  final String nama;
  final int idKat;
  final int tahun;
  final int harga;
  final int kapasitasMesin;
  final int jumlahKursi;
  final String warna;
  final String gambar;
  final String bahanBakar;
  final String transmisi;

  const KatalogModels({
    required this.id,
    required this.nama,
    required this.idKat,
    required this.tahun,
    required this.harga,
    required this.kapasitasMesin,
    required this.jumlahKursi,
    required this.warna,
    required this.gambar,
    required this.bahanBakar,
    required this.transmisi,
  });
  factory KatalogModels.fromJson(Map<String, dynamic> json) {
    return KatalogModels(
      id: json['id'],
      nama: json['nama'] ?? '',
      idKat: json['idKat'] ?? 0,
      tahun: json['tahun'] ?? 0,
      harga: json['harga'] ?? 0,
      kapasitasMesin: json['kapasitasMesin'] ?? 0,
      jumlahKursi: json['jumlahKursi'] ?? 0,
      warna: json['warna'] ?? '',
      gambar: json['gambar'] ?? '',
      bahanBakar: json['bahanBakar'] ?? '',
      transmisi: json['transmisi'] ?? '',
    );
  }
}
