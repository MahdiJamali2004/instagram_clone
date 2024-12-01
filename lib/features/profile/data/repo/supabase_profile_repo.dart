import 'dart:io';

import 'package:instagram_clone/features/profile/domain/entities/profile_user.dart';
import 'package:instagram_clone/features/profile/domain/repo/profile_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProfileRepo implements ProfileRepo {
  final profileUserTabel = Supabase.instance.client.from('ProfileUser');
  @override
  Future<void> createUserProfile(ProfileUser profileUser) async {
    final result = await profileUserTabel.insert(profileUser.toMap());
    print('result is $result');
  }

  @override
  Future<void> updateProfileUser(
      {required String? profilePicPath,
      required String bio,
      required File? file,
      required String userId}) async {
    await profileUserTabel.update(
        {'profilePicPath': profilePicPath, 'bio': bio}).eq('userId', userId);
    if (profilePicPath != null && file != null) {
      final resul = await Supabase.instance.client.storage
          .from('insta_bucket')
          .upload(profilePicPath, file);

      print('saved $resul');
    }
  }

  @override
  Future<ProfileUser?> getProfileUser(String userId) async {
    final response = await profileUserTabel.select().eq('userId', userId);
    if (response.isEmpty) {
      return null;
    }
    return ProfileUser.fromMap(response.first);
  }

  @override
  Future<void> toggleFollow(
      {required String follower, required String following}) async {
    final followerProfile = await getProfileUser(follower);
    final followingProfile = await getProfileUser(following);
    if (followingProfile == null || followerProfile == null) {
      throw Exception('Please check your interntet');
    }

    // if (followingProfile.followers.contains(follower)) {
    // } else {
    // }

    if (followerProfile.followings.contains(following)) {
      followerProfile.followings.remove(following);
      followingProfile.followers.remove(follower);
    } else {
      followerProfile.followings.add(following);
      followingProfile.followers.add(follower);
    }

    await profileUserTabel.update({'followers': followingProfile.followers}).eq(
        'userId', following);

    await profileUserTabel.update(
        {'followings': followerProfile.followings}).eq('userId', follower);

    // await profileUserTabel.update({
    //   'followings': Supabase.instance.client.rpc('array_append', params: {
    //     'array': 'followings',
    //     'element': following
    //   }).eq('userId', follower)
    // }).whenComplete(
    //   () async {
    //     await profileUserTabel.update({
    //       'followers': Supabase.instance.client.rpc('array_append', params: {
    //         'array': 'followers',
    //         'element': follower
    //       }).eq('userId', following)
    //     });
    //   },
    // );
  }
}
