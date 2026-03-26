// lib/services/mesh_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class MeshService {
  Future<void> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse('https://your-netlify-site.netlify.app/.netlify/functions/mesh-handshake'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'deviceId': 'flutter_device_1',
        'deviceType': 'flutter',
        'message': message,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to send message: ${response.body}');
    }
  }

  Future<List<String>> getPeers() async {
    // Simulate fetching nearby peers
    return ['Peer1', 'Peer2', 'Peer3'];
  }
}
