import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiServices {
  final baseUrl = dotenv.maybeGet(
    'API_BASE_URL',
    fallback: 'http://default-url.com',
  );

  Future<Map<String, dynamic>?> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        return {"status": "success"};
      } else {
        final responseData = jsonDecode(response.body);

        if (responseData["message"] == "Email alredy exist") { 
          return {"status": "email_exist"};
        }

        return {"status": "error", "message": responseData["message"] ?? "Unknown error"};
      }
    } catch (e) {
      return {"status": "error", "message": "Failed to connect to server"};
    }
  }


  Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", data["token"]);
      return data;
    }
    return null;
  }

  Future<Map<String, dynamic>?> googleAPI(String email, String name) async {
    print("Mengirim request ke backend: email = $email, name = $name");

    final response = await http.post(
      Uri.parse("$baseUrl/login-google"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "name": name}),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", data["token"]);
      return data;
    }
    return null;
  }
}
