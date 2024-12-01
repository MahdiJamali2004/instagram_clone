import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/auth/presentation/components/extensions.dart';
import 'package:instagram_clone/features/auth/presentation/components/my_text_field.dart';
import 'package:instagram_clone/features/post/domain/entities/comment.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';
import 'package:instagram_clone/features/post/presentation/component/comment_widget.dart';
import 'package:instagram_clone/features/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clone/features/post/presentation/cubit/post_states.dart';
import 'package:instagram_clone/features/profile/domain/entities/profile_user.dart';
import 'package:instagram_clone/features/profile/presentation/cubit/profileuser_cubit.dart';
import 'package:instagram_clone/gen/fonts.gen.dart';

class CommentPage extends StatefulWidget {
  final List<Comment> comments;
  final Post post;
  final String currentUserId;
  const CommentPage(
      {super.key,
      required this.comments,
      required this.post,
      required this.currentUserId});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  late final PostCubit postCubit = context.read<PostCubit>();
  late final ProfileuserCubit profileCubit = context.read<ProfileuserCubit>();
  ProfileUser? currentUser;
  final textController = TextEditingController();

  void addComment() {
    if (textController.text.isEmpty) {
      context.showCustomSnackBar('comment can\'t be empty');
      return;
    }
    if (currentUser == null) {
      context.showCustomSnackBar('please check your internet',
          action: SnackBarAction(
              label: 'Try again',
              onPressed: () {
                getProfileUser().whenComplete(
                  () {
                    addComment();
                  },
                );
              }));
    }
    final currentDateTime = DateTime.now();
    final comment = Comment(
        text: textController.text,
        postId: widget.post.id!,
        timestamp: currentDateTime,
        id: currentDateTime.millisecondsSinceEpoch.toString(),
        username: currentUser!.username,
        userId: widget.currentUserId);
    postCubit.addComment(comment: comment, post: widget.post);
    textController.text = '';
    setState(() {});
  }

  Future<void> getProfileUser() async {
    currentUser = await profileCubit.getProfilebyUserId(widget.currentUserId);
  }

  @override
  void initState() {
    getProfileUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostStates>(
      listener: (context, state) {
        if (state is PostErrorState) {
          context.showCustomSnackBar(state.message);
        }
      },
      builder: (context, state) {
        if (state is PostLoadedState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Comments',
                style: TextStyle(fontFamily: FontFamily.oswald),
              ),
            ),
            body: Column(
              children: [
                //comments list
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.comments.length,
                    itemBuilder: (context, index) {
                      return CommentWidget(
                        comment: widget.comments[index],
                        post: widget.post,
                      );
                    },
                  ),
                ),

                //add comment field
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: MyTextField(
                        obscureText: false,
                        controller: textController,
                        hint: 'Comment..',
                      )),
                      IconButton(
                        onPressed: () {
                          addComment();
                          FocusScope.of(context).unfocus();
                        },
                        icon: const Icon(
                          Icons.check,
                        ),
                      )
                    ],
                  ),
                )
              ],
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
    );
  }
}
