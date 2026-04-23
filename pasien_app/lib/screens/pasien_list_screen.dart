import 'package:flutter/material.dart';
import '../services/pasien_service.dart';
import '../models/pasien.dart';
import 'pasien_form_screen.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';

class PasienListScreen extends StatefulWidget {
  const PasienListScreen({super.key});

  @override
  State<PasienListScreen> createState() => _PasienListScreenState();
}

class _PasienListScreenState extends State<PasienListScreen> {
  String keyword = "";
  String filterJk = "ALL";

  void refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Pasien"),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
              (_) => false,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
          )
        ],
      ),

      body: Column(
        children: [
          /// ================= HEADER =================
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: FutureBuilder<List<Pasien>>(
              future: PasienService().getPasien(),
              builder: (_, snapshot) {
                final total = snapshot.data?.length ?? 0;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Manajemen Data Pasien",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Total Pasien: $total",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                );
              },
            ),
          ),

          /// ================= SEARCH & FILTER =================
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "Cari Nama / No RM",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onChanged: (v) =>
                      setState(() => keyword = v.toLowerCase()),
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  initialValue: filterJk,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.people),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: "ALL", child: Text("Semua")),
                    DropdownMenuItem(
                        value: "L", child: Text("Laki-laki")),
                    DropdownMenuItem(
                        value: "P", child: Text("Perempuan")),
                  ],
                  onChanged: (v) =>
                      setState(() => filterJk = v!),
                ),
              ],
            ),
          ),

          /// ================= LIST PASIEN =================
          Expanded(
            child: FutureBuilder<List<Pasien>>(
              future: PasienService().getPasien(),
              builder: (_, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                final data = snapshot.data!
                    .where((p) =>
                        (p.namaPasien
                                .toLowerCase()
                                .contains(keyword) ||
                            p.noRm.contains(keyword)) &&
                        (filterJk == "ALL" ||
                            p.jenisKelamin == filterJk))
                    .toList();

                if (data.isEmpty) {
                  return const Center(
                    child: Text("Data pasien tidak ditemukan"),
                  );
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: data.length,
                  itemBuilder: (_, i) {
                    final p = data[i];

                    return Card(
                      margin:
                          const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        borderRadius:
                            BorderRadius.circular(16),
                        onTap: () => _showDetailPasien(p),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                Colors.blue.shade100,
                            child: Icon(
                              Icons.person,
                              color:
                                  Colors.blue.shade700,
                            ),
                          ),
                          title: Text(
                            p.namaPasien,
                            style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold),
                          ),
                          subtitle: Text(
                            "RM: ${p.noRm}\n${p.jenisKelamin == 'L' ? 'Laki-laki' : 'Perempuan'}",
                          ),
                          isThreeLine: true,
                          trailing: PopupMenuButton(
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                  value: "edit",
                                  child: Text("Edit")),
                              PopupMenuItem(
                                  value: "hapus",
                                  child: Text("Hapus")),
                            ],
                            onSelected:
                                (value) async {
                              if (value ==
                                  "edit") {
                                final result =
                                    await Navigator
                                        .push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        PasienFormScreen(
                                            pasien:
                                                p),
                                  ),
                                );
                                if (result ==
                                    true) {
                                  refresh();
                                }
                              } else {
                                await PasienService()
                                    .deletePasien(
                                        p.id);
                                refresh();
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// ================= DETAIL PASIEN =================
  void _showDetailPasien(Pasien p) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Detail Pasien",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                          fontWeight:
                              FontWeight.bold),
                ),
              ),
              const Divider(height: 24),
              _row("No RM", p.noRm),
              _row("Nama", p.namaPasien),
              _row(
                "Jenis Kelamin",
                p.jenisKelamin == 'L'
                    ? 'Laki-laki'
                    : 'Perempuan',
              ),
              _row("Umur", "${p.umur} Tahun"),
              _row("Alamat", p.alamat),
              _row("No HP", p.noHp),
              _row("Tanggal Lahir",
                  p.tanggalLahir),
              _row("Diagnosis", p.diagnosis),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pop(context),
                  child: const Text("Tutup"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: const TextStyle(
                  fontWeight:
                      FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
