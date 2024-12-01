import 'dart:io';

import 'package:instagram_clone/features/profile/domain/entities/profile_user.dart';

abstract class ProfileRepo {
  Future<void> createUserProfile(ProfileUser profileUser);
  Future<void> updateProfileUser(
      {required String? profilePicPath,
      required String bio,
      required File? file,
      required String userId});
  Future<ProfileUser?> getProfileUser(String userId);
  Future<void> toggleFollow(
      {required String follower, required String following});
}
