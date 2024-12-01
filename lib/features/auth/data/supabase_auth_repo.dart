import 'package:instagram_clone/features/auth/domain/repo/auth_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthRepo implements AuthRepo {
  final supabaseClient = Supabase.instance.client;

  @override
  Future<String?> getCurrentUserId() async {
    final userId = supabaseClient.auth.currentUser?.id;
    return userId;
  }

  @override
  Future<String?> register(String email, String password) async {
    final response =
        await supabaseClient.auth.signUp(email: email, password: password);
    return response.user?.id;
  }

  @override
  Future<String?> login(String email, String password) async {
    final response = await supabaseClient.auth
        .signInWithPassword(email: email, password: password);
    return response.user?.id;
  }

  @override
  Future<void> logout() async {
    await supabaseClient.auth.signOut();
  }
}
