import 'package:flutter/material.dart';
import '../services/pasien_service.dart';
import '../models/pasien.dart';
import 'dashboard_screen.dart';

class PasienFormScreen extends StatefulWidget {
  final Pasien? pasien;
  const PasienFormScreen({super.key, this.pasien});

  @override
  State<PasienFormScreen> createState() => _PasienFormScreenState();
}

class _PasienFormScreenState extends State<PasienFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final noRm = TextEditingController();
  final nama = TextEditingController();
  final umur = TextEditingController();
  final alamat = TextEditingController();
  final noHp = TextEditingController();
  final diagnosis = TextEditingController();
  final tanggalLahir = TextEditingController();

  String jk = 'L';

  @override
  void initState() {
    super.initState();
    if (widget.pasien != null) {
      final p = widget.pasien!;
      noRm.text = p.noRm;
      nama.text = p.namaPasien;
      jk = p.jenisKelamin;
      umur.text = p.umur.toString();
      alamat.text = p.alamat;
      noHp.text = p.noHp;
      diagnosis.text = p.diagnosis;
      tanggalLahir.text = p.tanggalLahir;
    }
  }

  @override
  void dispose() {
    noRm.dispose();
    nama.dispose();
    umur.dispose();
    alamat.dispose();
    noHp.dispose();
    diagnosis.dispose();
    tanggalLahir.dispose();
    super.dispose();
  }

  Widget section(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pasien == null ? "Tambah Pasien" : "Edit Pasien"),
        centerTitle: true,

        /// 🏠 HOME hanya saat TAMBAH PASIEN
        leading: widget.pasien == null
            ? IconButton(
                icon: const Icon(Icons.home),
                tooltip: "Kembali ke Dashboard",
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DashboardScreen(),
                    ),
                    (route) => false,
                  );
                },
              )
            : null,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              section("Identitas Pasien"),

              TextFormField(
                controller: noRm,
                enabled: widget.pasien == null,
                decoration: const InputDecoration(
                  labelText: "No Rekam Medis",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "No RM wajib diisi" : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: nama,
                decoration: const InputDecoration(
                  labelText: "Nama Pasien",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.length < 3 ? "Minimal 3 karakter" : null,
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: jk,
                decoration: const InputDecoration(
                  labelText: "Jenis Kelamin",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'L', child: Text("Laki-laki")),
                  DropdownMenuItem(value: 'P', child: Text("Perempuan")),
                ],
                onChanged: (v) => setState(() => jk = v!),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: umur,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Umur",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: tanggalLahir,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Tanggal Lahir",
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    tanggalLahir.text =
                        date.toIso8601String().split('T').first;
                  }
                },
              ),

              section("Kontak Pasien"),

              TextFormField(
                controller: alamat,
                decoration: const InputDecoration(
                  labelText: "Alamat",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: noHp,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "No HP",
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return null;
                  if (!RegExp(r'^[0-9]{10,13}$').hasMatch(v)) {
                    return "No HP tidak valid";
                  }
                  return null;
                },
              ),

              section("Informasi Medis"),

              TextFormField(
                controller: diagnosis,
                decoration: const InputDecoration(
                  labelText: "Diagnosis",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    final data = {
                      "no_rm": noRm.text,
                      "nama_pasien": nama.text,
                      "jenis_kelamin": jk,
                      "umur": int.tryParse(umur.text) ?? 0,
                      "alamat": alamat.text,
                      "no_hp": noHp.text,
                      "tanggal_lahir": tanggalLahir.text,
                      "diagnosis": diagnosis.text,
                    };

                    if (widget.pasien == null) {
                      await PasienService().addPasien(data);
                    } else {
                      await PasienService()
                          .updatePasien(widget.pasien!.id, data);
                    }

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Data pasien berhasil disimpan"),
                        ),
                      );
                      Navigator.pop(context, true);
                    }
                  },
                  child: Text(widget.pasien == null ? "Simpan" : "Update"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
