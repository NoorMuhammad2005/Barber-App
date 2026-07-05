import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  // LOGIN
  Future<AuthResponse> login(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // SIGNUP
  Future<AuthResponse> signup(
      String email, String password, String name) async {
    final res = await _client.auth.signUp(
      email: email,
      password: password,
    );

    final user = res.user;

    if (user != null) {
      await _client.from('Profiles').insert({
        'id': user.id,
        'name': name,
        'email': email,
        'phone': '',
        'role': 'customer',
      });
    }

    return res;
  }

  // GET PROFILE (🔥 FIXED)
  Future<UserModel?> getProfile(String userId) async {
    final res = await _client
        .from('Profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (res == null) return null;

    return UserModel(
      id: res['id'],
      name: res['name'] ?? '',
      email: res['email'] ?? '',
      phone: res['phone'] ?? '',
      avatarUrl: res['avatar_url'],
    );
  }
}           