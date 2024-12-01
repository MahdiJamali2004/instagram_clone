import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/auth/presentation/components/extensions.dart';
import 'package:instagram_clone/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:instagram_clone/features/post/presentation/component/post_widget.dart';
import 'package:instagram_clone/features/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clone/features/post/presentation/cubit/post_states.dart';
import 'package:instagram_clone/features/profile/presentation/components/follow_button.dart';
import 'package:instagram_clone/features/profile/presentation/components/followers_followings_posts_tile.dart';
import 'package:instagram_clone/features/profile/presentation/cubit/profileuser_cubit.dart';
import 'package:instagram_clone/features/profile/presentation/cubit/profileuser_states.dart';
import 'package:instagram_clone/features/profile/presentation/pages/followes_following_page.dart';
import 'package:instagram_clone/gen/fonts.gen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileuserCubit profileCubit = context.read<ProfileuserCubit>();
  late final AuthCubit authCubit = context.read<AuthCubit>();
  String? authenticatedUserId;
  int? postCount;

  String getUrlFromImgPath({required String imgpath}) {
    return Supabase.instance.client.storage
        .from('insta_bucket')
        .getPublicUrl(imgpath);
  }

  Future<void> getAuthenticatedUserId() async {
    authenticatedUserId = await authCubit.getCurrentUserId();
    setState(() {});
  }

  @override
  void initState() {
    getAuthenticatedUserId();
    profileCubit.getProfilebyUserId(widget.userId);
    // authCubit.getCurrentUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileuserCubit, ProfileuserStates>(
      listener: (context, state) {
        if (state is ProfileUserErrorState) {
          context.showCustomSnackBar(state.error);
        }
      },
      builder: (context, state) {
        if (state is ProfileLoadedState) {
          final profileUser = state.profileuser;
          final isFollowing =
              profileUser.followers.contains(authenticatedUserId);
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Profile',
                style: TextStyle(fontFamily: FontFamily.oswald),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //picture & followers following posts list
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      profileUser.profilePicPath == null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              child: Center(
                                  child: Icon(
                                Icons.person,
                                size: 90,
                                color: Theme.of(context).colorScheme.primary,
                              )))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                imageUrl: getUrlFromImgPath(
                                    imgpath: profileUser.profilePicPath!),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                      //follower,followings,posts
                      Expanded(
                        child: FollowersFollowingsPostsTile(
                            onFollowingsClick: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FollowesFollowingPage(
                                      followers: profileUser.followers,
                                      followings: profileUser.followings),
                                ),
                              );
                              setState(() {});
                            },
                            postCount: postCount ?? 0,
                            followersCount: profileUser.followers.length,
                            followingsCount: profileUser.followings.length),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //username
                      Text(
                        profileUser.username,
                        style: const TextStyle(
                            fontFamily: FontFamily.oswald,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      //email
                      Text(
                        profileUser.email,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: FontFamily.oswald,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      //bio
                      Text(
                        profileUser.bio,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            fontFamily: FontFamily.oswald,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //follow message buttons
                      authenticatedUserId == widget.userId
                          ? SizedBox()
                          : Row(
                              children: [
                                Expanded(
                                  child: FollowButton(
                                    onTap: () {
                                      profileCubit.toggleFollow(
                                          follower: authenticatedUserId!,
                                          following: profileUser.userId);
                                    },
                                    text: isFollowing ? 'UnFollow' : 'Follow',
                                    isFollowing: isFollowing,
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                    child: FollowButton(
                                  onTap: () {
                                    context.showCustomSnackBar(
                                        'Not Implemented yet');
                                  },
                                  text: 'Message',
                                  isFollowing: true,
                                )),
                              ],
                            )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //posts
                BlocBuilder<PostCubit, PostStates>(
                  builder: (context, state) {
                    if (state is PostLoadedState) {
                      final posts = state.posts
                          .where(
                            (post) => post.userId == widget.userId,
                          )
                          .toList();
                      postCount = posts.length;
                      return Expanded(
                        child: ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: PostWidget(
                                  post: posts[index],
                                  currentUserId: widget.userId),
                            );
                          },
                        ),
                      );
                    } else {
                      return const Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          );
        } else if (state is ProfileUserErrorState) {
          return Scaffold(
            body: Center(
              child: Text('error ${state.error}'),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
