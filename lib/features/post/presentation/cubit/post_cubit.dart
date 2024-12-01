import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/post/domain/entities/comment.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';
import 'package:instagram_clone/features/post/domain/repo/post_repo.dart';
import 'package:instagram_clone/features/post/presentation/cubit/post_states.dart';

class PostCubit extends Cubit<PostStates> {
  final PostRepo postRepo;
  PostCubit({required this.postRepo}) : super(PostInitialState());

  Future<void> getAllPosts({String? userId}) async {
    try {
      emit(PostLoadingState());

      final posts = userId == null
          ? await postRepo.getAllPosts()
          : await postRepo.getPostByUserId(userId: userId);
      emit(PostLoadedState(posts: posts));
    } catch (e) {
      emit(PostErrorState(message: 'error loading posts please try again'));
    }
  }

  // Future<void> getPostsByUserId({required String userId}) async {
  //   try {
  //     emit(PostLoadingState());
  //     final posts = await postRepo.getPostByUserId(userId: userId);
  //     emit(PostLoadedState(posts: posts));
  //   } catch (e) {
  //     emit(PostErrorState(message: 'error loading posts please try again'));
  //   }
  // }

  Future<void> createPost({required Post post, required File postImage}) async {
    try {
      emit(PostLoadingState());
      await postRepo.createPost(post: post, postImage: postImage);
      emit(PostLoadedState(posts: []));
    } catch (e) {
      emit(PostErrorState(message: 'error creating post please try again'));
    }
  }

  Future<void> deletePost({required int postId}) async {
    try {
      await postRepo.deletePost(postId: postId);
    } catch (e) {
      emit(PostErrorState(message: 'error deleting post please try again'));
    }
  }

  Future<void> toggleLikes({required String userId, required Post post}) async {
    try {
      await postRepo.toggleLike(userId: userId, post: post);
      await getAllPosts();
    } catch (e) {
      emit(PostErrorState(message: 'Error on liking post please try again'));
    }
  }

  Future<void> addComment(
      {required Comment comment, required Post post}) async {
    try {
      await postRepo.addComment(comment: comment, post: post);
      await postRepo.getAllPosts();
    } catch (e) {
      emit(PostErrorState(message: 'Error creating comment please try again'));
    }
  }

  Future<void> deleteComment(
      {required Comment comment, required Post post}) async {
    try {
      await postRepo.deleteComment(comment: comment, post: post);
      await getAllPosts();
    } catch (e) {
      emit(PostErrorState(message: 'Error removing comment please try again'));
    }
  }
}
