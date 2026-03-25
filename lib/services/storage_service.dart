// lib/services/storage_service.dart
Future<void> saveOfflineMessage(String message) async {
  final prefs = await SharedPreferences.getInstance();
  final messages = prefs.getStringList('offlineMessages') ?? [];
  messages.add(message);
  await prefs.setStringList('offlineMessages', messages);
}
