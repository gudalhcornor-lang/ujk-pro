class Pasien {
  final int id;
  final String noRm;
  final String namaPasien;
  final String jenisKelamin;
  final int umur;
  final String alamat;
  final String noHp;
  final String diagnosis;
  final String tanggalLahir;

  Pasien({
    required this.id,
    required this.noRm,
    required this.namaPasien,
    required this.jenisKelamin,
    required this.umur,
    required this.alamat,
    required this.noHp,
    required this.diagnosis,
    required this.tanggalLahir,
  });

  factory Pasien.fromJson(Map<String, dynamic> json) {
    return Pasien(
      id: json['id'],
      noRm: json['no_rm'] ?? '',
      namaPasien: json['nama_pasien'] ?? '',
      jenisKelamin: json['jenis_kelamin'] ?? 'L',
      umur: json['umur'] ?? 0,
      alamat: json['alamat'] ?? '',
      noHp: json['no_hp'] ?? '',
      diagnosis: json['diagnosis'] ?? '',
      tanggalLahir: json['tanggal_lahir'] ?? '',
    );
  }
}
