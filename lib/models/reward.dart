// lib/models/reward.dart
class Reward {
  final String type; // 'message', 'login', 'referral', 'staking'
  final int amount;
  final DateTime timestamp;
  final bool isClaimed;

  Reward({
    required this.type,
    required this.amount,
    required this.timestamp,
    this.isClaimed = false,
  });

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      type: json['type'],
      amount: json['amount'],
      timestamp: DateTime.parse(json['timestamp']),
      isClaimed: json['isClaimed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
      'isClaimed': isClaimed,
    };
  }
}
