import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/auth/presentation/components/extensions.dart';
import 'package:instagram_clone/features/home/presentation/component/home_drawer.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';
import 'package:instagram_clone/features/post/presentation/component/post_widget.dart';
import 'package:instagram_clone/features/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clone/features/post/presentation/cubit/post_states.dart';
import 'package:instagram_clone/features/profile/domain/entities/profile_user.dart';
import 'package:instagram_clone/features/profile/presentation/cubit/profileuser_cubit.dart';
import 'package:instagram_clone/gen/fonts.gen.dart';

class HomePage extends StatefulWidget {
  final String authenticatedUserId;
  const HomePage({super.key, required this.authenticatedUserId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ProfileuserCubit profileCubit = context.read<ProfileuserCubit>();
  late final PostCubit postCubit = context.read<PostCubit>();
  ProfileUser? profileUser;

  @override
  void initState() {
    postCubit.getAllPosts();
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
          final List<Post> posts = state.posts;
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Home',
                style: TextStyle(fontFamily: FontFamily.oswald),
              ),
            ),
            drawer: HomeDrawer(
              currentUserId: widget.authenticatedUserId,
              onNavigateBackFromPostPage: () {
                postCubit.getAllPosts();
              },
            ),
            body: ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: PostWidget(
                      post: post, currentUserId: widget.authenticatedUserId),
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
    );
  }
}
