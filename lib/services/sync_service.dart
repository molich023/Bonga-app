// lib/services/sync_service.dart
Future<void> syncPendingRewards(String userAddress) async {
  final prefs = await SharedPreferences.getInstance();
  int pending = prefs.getInt('pendingGRO') ?? 0;
  if (pending > 0) {
    await http.post(
      Uri.parse('https://your-netlify-site.netlify.app/.netlify/functions/sync-gro'),
      body: jsonEncode({
        'userAddress': userAddress,
        'pendingRewards': pending,
      }),
    );
    await prefs.setInt('pendingGRO', 0);
  }
}
