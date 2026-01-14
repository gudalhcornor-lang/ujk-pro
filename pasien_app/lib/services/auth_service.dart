import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api.dart';

class AuthService {

  /// =====================
  /// LOGIN
  /// =====================
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/login"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      print("LOGIN STATUS: ${response.statusCode}");
      print("LOGIN BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final token = data['data']['token'];
        SharedPreferences prefs =
            await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        return true;
      }

      return false;
    } catch (e) {
      print("LOGIN ERROR: $e");
      return false;
    }
  }

  /// =====================
  /// REGISTER
  /// =====================
  Future<bool> register(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/register"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": password, // WAJIB
        }),
      );

      print("REGISTER STATUS: ${response.statusCode}");
      print("REGISTER BODY: ${response.body}");

      // Laravel register biasanya 201
      if (response.statusCode == 201 ||
          response.statusCode == 200) {
        return true;
      }

      return false;
    } catch (e) {
      print("REGISTER ERROR: $e");
      return false;
    }
  }

  /// =====================
  /// LOGOUT
  /// =====================
  Future<void> logout() async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  /// =====================
  /// GET TOKEN
  /// =====================
  Future<String?> getToken() async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// =====================
  /// CHECK LOGIN
  /// =====================
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}
