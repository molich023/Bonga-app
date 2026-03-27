// lib/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://your-project-ref.supabase.co',
      anonKey: 'your-supabase-anon-key',
    );
  }

  Future<Map<String, dynamic>> submitKYC({
    required String userId,
    required String imageBase64,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'liveness_check',
        body: {
          'user_id': userId,
          'image': imageBase64,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('KYC submission failed: $e');
    }
  }

  Future<bool> checkKYCStatus(String userId) async {
    final response = await _supabase
        .from('kyc_submissions')
        .select()
        .eq('user_id', userId)
        .single();
    return response['status'] == 'approved';
  }

  Future<void> updateUserProfile({
    required String walletAddress,
    String? username,
    String? phoneNumber,
  }) async {
    await _supabase.from('users').upsert({
      'wallet_address': walletAddress,
      'username': username,
      'phone_number': phoneNumber,
    }).eq('wallet_address', walletAddress);
  }

  Future<int> getGROBalance(String walletAddress) async {
    final response = await _supabase
        .from('users')
        .select('gro_balance')
        .eq('wallet_address', walletAddress)
        .single();
    return response['gro_balance'] ?? 0;
  }
}
