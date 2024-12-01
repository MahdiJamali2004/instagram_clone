import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/profile/domain/entities/profile_user.dart';
import 'package:instagram_clone/features/profile/domain/repo/profile_repo.dart';
import 'package:instagram_clone/features/profile/presentation/cubit/profileuser_states.dart';

class ProfileuserCubit extends Cubit<ProfileuserStates> {
  final ProfileRepo profileRepo;
  ProfileuserCubit({required this.profileRepo})
      : super(ProfileUserInitialState());

  Future<ProfileUser?> getProfilebyUserId(String userId) async {
    try {
      print('fetching $userId');
      final profileUser = await profileRepo.getProfileUser(userId);
      if (profileUser == null) {
        print('profile user is $profileUser');
        emit(ProfileUserErrorState(error: 'could not find user'));
        return null;
      } else {
        emit(ProfileLoadedState(profileuser: profileUser));
        return profileUser;
      }
    } catch (e) {
      emit(ProfileUserErrorState(error: 'error getting profile user'));
      return null;
    }
  }

  Future<void> updateProfileUser(
      {required String? profilePicPath,
      required String bio,
      required File? file,
      required String userId}) async {
    try {
      emit(ProfileUserLoadingState());
      await profileRepo.updateProfileUser(
          bio: bio, profilePicPath: profilePicPath, file: file, userId: userId);
      final updatedProfile = await profileRepo.getProfileUser(userId);
      if (updatedProfile != null) {
        emit(ProfileLoadedState(profileuser: updatedProfile));
      } else {
        emit(ProfileUserErrorState(error: 'User not found.'));
      }
    } catch (e) {
      emit(ProfileUserErrorState(
          error: 'Error updating profile please try again.'));
    }
  }

  Future<void> toggleFollow(
      {required String follower, required String following}) async {
    try {
      await profileRepo.toggleFollow(follower: follower, following: following);
      await getProfilebyUserId(following);
    } catch (e) {
      emit(ProfileUserErrorState(error: e.toString()));
    }
  }
}
