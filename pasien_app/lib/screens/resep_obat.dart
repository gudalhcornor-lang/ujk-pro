import 'package:flutter/material.dart';
import '../services/resep_service.dart';
import '../models/resep.dart';
import 'dashboard_screen.dart';

class ResepObatForm extends StatefulWidget {
  final Resep? resep;

  const ResepObatForm({super.key, this.resep});

  @override
  State<ResepObatForm> createState() => _ResepObatFormState();
}

class _ResepObatFormState extends State<ResepObatForm> {
  final _formKey = GlobalKey<FormState>();

  final pasienId = TextEditingController();
  final dokter = TextEditingController();
  final catatan = TextEditingController();

  List<Map<String, dynamic>> detailObat = [];

  @override
  void initState() {
    super.initState();

    // ================= EDIT MODE =================
    if (widget.resep != null) {
      final r = widget.resep!;

      pasienId.text = r.pasienId.toString();
      dokter.text = r.namaDokter;
      catatan.text = r.catatan ?? '';

      detailObat = r.detail
          .map((e) => {
                "nama_obat": e.namaObat,
                "dosis": e.dosis,
                "jumlah": e.jumlah,
                "aturan_pakai": e.aturanPakai,
              })
          .toList();
    }

    if (detailObat.isEmpty) {
      tambahObat();
    }
  }

  void tambahObat() {
    setState(() {
      detailObat.add({
        "nama_obat": "",
        "dosis": "",
        "jumlah": 0,
        "aturan_pakai": ""
      });
    });
  }

  void hapusObat(int index) {
    setState(() {
      detailObat.removeAt(index);
    });
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

  Widget obatCard(int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Nama Obat",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => detailObat[index]['nama_obat'] = v,
            ),
            const SizedBox(height: 10),

            TextFormField(
              decoration: const InputDecoration(
                labelText: "Dosis",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => detailObat[index]['dosis'] = v,
            ),
            const SizedBox(height: 10),

            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Jumlah",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) =>
                  detailObat[index]['jumlah'] = int.tryParse(v) ?? 0,
            ),
            const SizedBox(height: 10),

            TextFormField(
              decoration: const InputDecoration(
                labelText: "Aturan Pakai",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => detailObat[index]['aturan_pakai'] = v,
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () => hapusObat(index),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Hapus Obat"),
            )
          ],
        ),
      ),
    );
  }

  Future<void> simpan() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      "pasien_id": int.tryParse(pasienId.text) ?? 0,
      "tanggal_resep": DateTime.now().toString().split(' ')[0],
      "nama_dokter": dokter.text,
      "catatan": catatan.text,
      "detail": detailObat
    };

    if (widget.resep == null) {
      await ResepService().addResep(data);
    } else {
      await ResepService().updateResep(widget.resep!.id!, data);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Resep berhasil disimpan")),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.resep == null ? "Tambah Resep" : "Edit Resep"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              section("Data Resep"),

              TextFormField(
                controller: pasienId,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Pasien ID",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Wajib diisi" : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: dokter,
                decoration: const InputDecoration(
                  labelText: "Nama Dokter",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Wajib diisi" : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: catatan,
                decoration: const InputDecoration(
                  labelText: "Catatan",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),

              section("Detail Obat"),

              Column(
                children: List.generate(
                  detailObat.length,
                  (index) => obatCard(index),
                ),
              ),

              const SizedBox(height: 10),

              ElevatedButton.icon(
                onPressed: tambahObat,
                icon: const Icon(Icons.add),
                label: const Text("Tambah Obat"),
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: simpan,
                  child: Text(
                    widget.resep == null ? "Simpan Resep" : "Update Resep",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}