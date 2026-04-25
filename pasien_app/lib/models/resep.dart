class Resep {
  final int? id;
  final int pasienId;
  final String tanggalResep;
  final String namaDokter;
  final String? catatan;
  final List<DetailResep> detail;

  Resep({
    this.id,
    required this.pasienId,
    required this.tanggalResep,
    required this.namaDokter,
    this.catatan,
    required this.detail,
  });

  /// 🔄 FROM JSON (API → Flutter)
  factory Resep.fromJson(Map<String, dynamic> json) {
    return Resep(
      id: json['id'],
      pasienId: json['pasien_id'],
      tanggalResep: json['tanggal_resep'],
      namaDokter: json['nama_dokter'],
      catatan: json['catatan'],
      detail: json['detail'] != null
          ? List<DetailResep>.from(
              json['detail'].map((x) => DetailResep.fromJson(x)),
            )
          : [],
    );
  }

  /// 🔼 TO JSON (Flutter → API)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "pasien_id": pasienId,
      "tanggal_resep": tanggalResep,
      "nama_dokter": namaDokter,
      "catatan": catatan,
      "detail": detail.map((e) => e.toJson()).toList(),
    };
  }
}

class DetailResep {
  final int? id;
  final String namaObat;
  final String dosis;
  final int jumlah;
  final String aturanPakai;

  DetailResep({
    this.id,
    required this.namaObat,
    required this.dosis,
    required this.jumlah,
    required this.aturanPakai,
  });

  factory DetailResep.fromJson(Map<String, dynamic> json) {
    return DetailResep(
      id: json['id'],
      namaObat: json['nama_obat'],
      dosis: json['dosis'],
      jumlah: json['jumlah'],
      aturanPakai: json['aturan_pakai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nama_obat": namaObat,
      "dosis": dosis,
      "jumlah": jumlah,
      "aturan_pakai": aturanPakai,
    };
  }
}