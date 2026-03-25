import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _baseUrl = 'https://your-netlify-site.netlify.app/.netlify/functions';

  static Future<Map<String, dynamic>> saveUser(String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/save-user'),
      body: jsonEncode({'email': email}),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> mintReward(String email, String action) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/mint-reward'),
      body: jsonEncode({'email': email, 'action': action}),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(response.body);
  }
}
