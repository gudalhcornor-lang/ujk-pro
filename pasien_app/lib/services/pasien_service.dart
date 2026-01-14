import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.dart';
import '../models/pasien.dart';

class PasienService {

  Future<List<Pasien>> getPasien() async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/pasien"),
    );

    final jsonData = jsonDecode(response.body);
    return (jsonData['data'] as List)
        .map((e) => Pasien.fromJson(e))
        .toList();
  }

  Future<void> addPasien(Map<String, dynamic> data) async {
    await http.post(
      Uri.parse("${ApiConfig.baseUrl}/pasien"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  Future<void> updatePasien(int id, Map<String, dynamic> data) async {
    await http.put(
      Uri.parse("${ApiConfig.baseUrl}/pasien/$id"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  Future<void> deletePasien(int id) async {
    await http.delete(
      Uri.parse("${ApiConfig.baseUrl}/pasien/$id"),
    );
  }
}
