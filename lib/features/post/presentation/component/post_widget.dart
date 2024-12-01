import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/auth/presentation/components/extensions.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';
import 'package:instagram_clone/features/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clone/features/post/presentation/pages/comment_page.dart';
import 'package:instagram_clone/features/profile/domain/entities/profile_user.dart';
import 'package:instagram_clone/features/profile/presentation/cubit/profileuser_cubit.dart';
import 'package:instagram_clone/features/profile/presentation/cubit/profileuser_states.dart';
import 'package:instagram_clone/features/profile/presentation/pages/profile_page.dart';
import 'package:instagram_clone/gen/fonts.gen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostWidget extends StatefulWidget {
  final Post post;

  final String currentUserId;
  const PostWidget(
      {super.key, required this.post, required this.currentUserId});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late final PostCubit postCubit = context.read<PostCubit>();
  late final ProfileuserCubit profileCubit = context.read<ProfileuserCubit>();
  ProfileUser? profileUser;
  String getUrlFromImgPath({required String imgpath}) {
    return Supabase.instance.client.storage
        .from('insta_bucket')
        .getPublicUrl(imgpath);
  }

  void toggleLikes() {
    postCubit.toggleLikes(userId: widget.currentUserId, post: widget.post);
  }

  String getUrlFromPath(String path) {
    return Supabase.instance.client.storage
        .from('insta_bucket')
        .getPublicUrl(path);
  }

  void deletePost() {
    if (widget.post.userId != widget.currentUserId) return;
    context.customAlertDialog(
      title: 'Delete Post',
      onAccept: () {
        postCubit.deletePost(postId: widget.post.id!);
      },
      onCancel: () => Navigator.pop,
    );
    setState(() {
      //rebuild ui when post deleted
    });
  }

  Future<void> getProfileUser() async {
    profileUser = await profileCubit.getProfilebyUserId(widget.post.userId);
  }

  @override
  void initState() {
    getProfileUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileuserCubit, ProfileuserStates>(
      builder: (context, state) {
        bool isLandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;
        bool isDarkMode =
            MediaQuery.of(context).platformBrightness == Brightness.dark;

        if (state is ProfileLoadedState) {
          // final profileUser = state.profileuser;
          return GestureDetector(
            onLongPress: deletePost,
            child: Column(
              children: [
                //image
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: isLandscape == true ? 1.91 / 1 : 4 / 5,
                      child: Image.network(
                        getUrlFromImgPath(imgpath: widget.post.imgPath),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfilePage(userId: widget.post.userId),
                              ));
                        },
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isDarkMode == true
                                        ? Colors.white
                                        : Colors.black,
                                    width: 3.0,
                                  )),
                              child: profileUser?.profilePicPath == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 60,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) {
                                          return const CircularProgressIndicator();
                                        },
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        imageUrl: getUrlFromPath(
                                            profileUser!.profilePicPath!),
                                      ),
                                    ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              profileUser?.username ?? '',
                              style: const TextStyle(
                                  fontFamily: FontFamily.oswald,
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //likes
                    IconButton(
                      onPressed: () {
                        toggleLikes();
                      },
                      icon: widget.post.likes.contains(widget.currentUserId)
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.favorite_border,
                            ),
                    ),
                    //likes number
                    Text(
                      '${widget.post.likes.length}',
                      style: const TextStyle(
                        fontFamily: FontFamily.oswald,
                      ),
                    ),
                    //comments
                    IconButton(
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentPage(
                                  comments: widget.post.comments,
                                  post: widget.post,
                                  currentUserId: widget.currentUserId),
                            ));
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.comment,
                      ),
                    ),
                    //commments number
                    Text(
                      '${widget.post.comments.length}',
                      style: const TextStyle(
                        fontFamily: FontFamily.oswald,
                      ),
                    ),
                  ],
                ),

                //description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      widget.post.description,
                      style: const TextStyle(fontFamily: FontFamily.oswald),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return AspectRatio(
            aspectRatio: isLandscape == true ? 1.91 / 1 : 4 / 5,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
