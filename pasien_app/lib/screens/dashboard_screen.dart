import 'dart:async';
import 'package:flutter/material.dart';
import '../services/pasien_service.dart';
import '../models/pasien.dart';
import 'pasien_form_screen.dart';
import 'pasien_list_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  /// STREAM PASIEN (REFRESH OTOMATIS)
  Stream<List<Pasien>> _pasienStream() async* {
    while (true) {
      final data = await PasienService().getPasien();
      yield data;
      await Future.delayed(const Duration(seconds: 2)); // interval realtime
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
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

      body: StreamBuilder<List<Pasien>>(
        stream: _pasienStream(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          final total = data.length;
          final laki = data.where((e) => e.jenisKelamin == 'L').length;
          final perempuan = data.where((e) => e.jenisKelamin == 'P').length;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [

              /// ================= HEADER =================
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.blueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Selamat Datang 👋",
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Sistem Manajemen Pasien",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// ================= TOTAL PASIEN (REALTIME) =================
              _statCard(
                title: "Total Pasien",
                value: total,
                icon: Icons.groups,
                color: Colors.blue,
                fullWidth: true,
              ),

              const SizedBox(height: 16),

              /// ================= LAKI & PEREMPUAN =================
              Row(
                children: [
                  _statCard(
                    title: "Laki-laki",
                    value: laki,
                    icon: Icons.male,
                    color: Colors.teal,
                  ),
                  const SizedBox(width: 12),
                  _statCard(
                    title: "Perempuan",
                    value: perempuan,
                    icon: Icons.female,
                    color: Colors.pink,
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// ================= MENU =================
              const Text(
                "Menu Utama",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              _menuCard(
                context,
                title: "Data Pasien",
                subtitle: "Lihat & kelola data pasien",
                icon: Icons.list_alt,
                color: Colors.deepPurple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PasienListScreen(),
                    ),
                  );
                },
              ),

              _menuCard(
                context,
                title: "Tambah Pasien",
                subtitle: "Input data pasien baru",
                icon: Icons.person_add,
                color: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PasienFormScreen(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  /// ================= STAT CARD =================
  static Widget _statCard({
    required String title,
    required int value,
    required IconData icon,
    required Color color,
    bool fullWidth = false,
  }) {
    final card = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: fullWidth
          ? Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: color.withOpacity(0.15),
                    child: Icon(icon, color: color),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    "$value",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            )
          : Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.15),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$value",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      title,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
    );

    return fullWidth ? card : Expanded(child: card);
  }

  /// ================= MENU CARD =================
  static Widget _menuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
