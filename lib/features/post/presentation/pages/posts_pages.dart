import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/auth/presentation/components/extensions.dart';
import 'package:instagram_clone/features/post/presentation/component/post_widget.dart';
import 'package:instagram_clone/features/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clone/features/post/presentation/cubit/post_states.dart';
import 'package:instagram_clone/features/post/presentation/pages/create_post_page.dart';
import 'package:instagram_clone/gen/fonts.gen.dart';

class PostsPages extends StatefulWidget {
  final String currentUserId;
  const PostsPages({super.key, required this.currentUserId});

  @override
  State<PostsPages> createState() => _PostsPagesState();
}

class _PostsPagesState extends State<PostsPages> {
  late final postCubit = context.read<PostCubit>();
  @override
  void initState() {
    postCubit.getAllPosts(userId: widget.currentUserId);
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
          final posts = state.posts;
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Posts',
                style: TextStyle(fontFamily: FontFamily.oswald),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreatePostPage(
                              currentUserId: widget.currentUserId),
                        ));
                  },
                  icon: const Icon(
                    Icons.post_add,
                  ),
                )
              ],
            ),
            body: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostWidget(
                    post: post, currentUserId: widget.currentUserId);
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
    );
  }
}
