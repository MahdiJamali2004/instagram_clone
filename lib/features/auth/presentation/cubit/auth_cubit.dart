import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/auth/domain/repo/auth_repo.dart';
import 'package:instagram_clone/features/auth/presentation/cubit/auth_state.dart';
import 'package:instagram_clone/features/profile/domain/entities/profile_user.dart';
import 'package:instagram_clone/features/profile/domain/repo/profile_repo.dart';

class AuthCubit extends Cubit<MyAuthState> {
  final AuthRepo authRepo;
  final ProfileRepo profileRepo;
  AuthCubit({required this.authRepo, required this.profileRepo})
      : super(InitialAuthState());

  Future<String?> getCurrentUserId() async {
    final userId = await authRepo.getCurrentUserId();
    print('current user is $userId');
    if (userId == null) {
      print('user UnAuthenticated');
      emit(UnAuthenticated());
    } else {
      print('user Authenticated');
      emit(Authenticated(userId: userId));
    }
    return userId;
  }

  Future<void> logout() async {
    try {
      await authRepo.logout();
      emit(UnAuthenticated());
    } catch (e) {
      emit(AuthErrorState(error: 'error logout : $e'));
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final userId = await authRepo.login(email, password);
      // final String? userId = await authRepo.getCurrentUserId();
      if (userId == null) {
        emit(UnAuthenticated());
      } else {
        emit(Authenticated(userId: userId));
      }
    } catch (e) {
      emit(AuthErrorState(error: 'login error : $e'));
      emit(UnAuthenticated());
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      final userId = await authRepo.register(email, password);
      // final String? userId = authRepo.getCurrentUserId();
      if (userId == null) {
        emit(UnAuthenticated());
      } else {
        await profileRepo.createUserProfile(
          ProfileUser(
              username: name,
              userId: userId,
              bio: '',
              email: email,
              profilePicPath: null,
              followers: [],
              followings: []),
        );
        emit(Authenticated(userId: userId));
      }
    } catch (e) {
      emit(AuthErrorState(error: 'register error : $e'));
      emit(UnAuthenticated());
    }
  }
}
