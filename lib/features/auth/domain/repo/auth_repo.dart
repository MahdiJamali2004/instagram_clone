abstract class AuthRepo {
  Future<String?> register(String email, String password);
  Future<String?> login(String email, String password);
  Future<String?> getCurrentUserId();
  Future<void> logout();
}
