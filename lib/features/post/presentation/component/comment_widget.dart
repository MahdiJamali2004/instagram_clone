import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/auth/presentation/components/extensions.dart';
import 'package:instagram_clone/features/post/domain/entities/comment.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';
import 'package:instagram_clone/features/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clone/features/profile/presentation/cubit/profileuser_cubit.dart';
import 'package:instagram_clone/features/profile/presentation/cubit/profileuser_states.dart';
import 'package:instagram_clone/features/profile/presentation/pages/profile_page.dart';
import 'package:instagram_clone/gen/fonts.gen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentWidget extends StatefulWidget {
  final Comment comment;
  final Post post;
  const CommentWidget({super.key, required this.comment, required this.post});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  late final PostCubit postCunit = context.read<PostCubit>();
  String getUrlFromPath(String path) {
    return Supabase.instance.client.storage
        .from('insta_bucket')
        .getPublicUrl(path);
  }

  void deleteComment() {
    context.customAlertDialog(
        title: 'Delete Comment',
        onAccept: () {
          postCunit.deleteComment(comment: widget.comment, post: widget.post);
        },
        onCancel: () => Navigator.pop,
        content: const Text(
          'Are you sure you want to delete this comment?',
          style: TextStyle(fontFamily: FontFamily.oswald),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileuserCubit, ProfileuserStates>(
      builder: (context, state) {
        final isDarkMode =
            MediaQuery.of(context).platformBrightness == Brightness.dark;
        if (state is ProfileLoadedState) {
          final profileUser = state.profileuser;
          return Row(
            children: [
              //image
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePage(userId: widget.comment.userId),
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDarkMode == true
                                  ? Colors.white
                                  : Colors.black,
                              width: 3.0,
                            )),
                        child: profileUser.profilePicPath == null
                            ? const Icon(
                                Icons.person,
                                size: 40,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) {
                                    return const CircularProgressIndicator();
                                  },
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  imageUrl: getUrlFromPath(
                                      profileUser.profilePicPath!),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onLongPress: deleteComment,
                      child: Column(
                        children: [
                          Text(
                            profileUser.username,
                            style: const TextStyle(
                                fontFamily: FontFamily.oswald,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            widget.comment.text,
                            style: const TextStyle(
                                fontFamily: FontFamily.oswald,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
