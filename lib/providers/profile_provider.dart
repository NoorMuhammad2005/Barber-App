import 'package:barbershop_app/services/auth_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import 'auth_provider.dart';

final profileProvider =
    StateNotifierProvider<ProfileNotifier, UserModel?>((ref) {
  final authService = ref.read(authServiceProvider);
  return ProfileNotifier(authService);
});

class ProfileNotifier extends StateNotifier<UserModel?> {
  final AuthService _authService;

  ProfileNotifier(this._authService) : super(null);

  Future<void> loadProfile(String userId) async {
    try {
      final user = await _authService.getProfile(userId);

      if (user != null) {
        state = user; // 👈 direct UserModel store
      }
    } 
    // catch (e) {
    //   state = null;
    // }
    catch (e, stackTrace) {
  print("loadProfile Error: $e");
  print(stackTrace);
  rethrow;
}
  }

  void clear() {
    state = null;
  }
}