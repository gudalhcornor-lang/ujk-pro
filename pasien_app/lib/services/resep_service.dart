import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.dart';

class ResepService {
  final String baseUrl = "${ApiConfig.baseUrl}/resep-obat";

  // ===================== GET RESEP =====================
  Future<List<dynamic>> getResep() async {
    final response = await http.get(Uri.parse(baseUrl));

    print("GET RESEP STATUS: ${response.statusCode}");
    print("GET RESEP BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Gagal ambil data resep");
    }

    final jsonData = jsonDecode(response.body);
    return jsonData['data'] ?? [];
  }

  // ===================== ADD RESEP =====================
  Future<void> addResep(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(data),
    );

    print("ADD RESEP STATUS: ${response.statusCode}");
    print("ADD RESEP BODY: ${response.body}");

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Gagal tambah resep: ${response.body}");
    }
  }

  // ===================== UPDATE RESEP =====================
  Future<void> updateResep(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(data),
    );

    print("UPDATE RESEP STATUS: ${response.statusCode}");
    print("UPDATE RESEP BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Gagal update resep: ${response.body}");
    }
  }

  // ===================== DELETE RESEP =====================
  Future<void> deleteResep(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/$id"),
      headers: {
        "Accept": "application/json",
      },
    );

    print("DELETE RESEP STATUS: ${response.statusCode}");
    print("DELETE RESEP BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Gagal hapus resep: ${response.body}");
    }
  }
}