import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String loginUrl = 'https://sos.mohimen.ly/api/login';
  final String registerUrl = 'https://sos.mohimen.ly/api/register';

  // Existing login function
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setInt('user_id', data['user_id']);
      await prefs.setString('user', data['user']);
      await prefs.setString('email', data['email']);

      return {'status': true, 'message': 'Login successful', 'data': data};
    } else {
      return {'status': false, 'message': 'Invalid login credentials'};
    }
  }

  // New register function
  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse(registerUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setInt('user_id', data['user_id']);
      await prefs.setString('user', data['user']);
      await prefs.setString('email', data['email']);

      return {
        'status': true,
        'message': 'Registration successful',
        'data': data
      };
    } else {
      return {'status': false, 'message': 'Registration failed'};
    }
  }
}
