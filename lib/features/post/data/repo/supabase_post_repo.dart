import 'dart:io';

import 'package:instagram_clone/features/post/domain/entities/comment.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';
import 'package:instagram_clone/features/post/domain/repo/post_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabasePostRepo implements PostRepo {
  final postTable = Supabase.instance.client.from('Posts');

  @override
  Future<void> createPost({required Post post, required File postImage}) async {
    await Supabase.instance.client.storage
        .from('insta_bucket')
        .upload(post.imgPath, postImage)
        .whenComplete(
      () async {
        await postTable.insert(post.toMap());
      },
    );
  }

  @override
  Future<void> deletePost({required int postId}) async {
    await postTable.delete().eq('id', postId);
  }

  @override
  Future<List<Post>> getAllPosts() async {
    final result = await postTable.select();
    final posts = result
        .map(
          (postMap) => Post.fromMap(postMap),
        )
        .toList();
    return posts;
  }

  @override
  Future<List<Post>> getPostByUserId({required String userId}) async {
    final result = await postTable.select().eq('userId', userId);
    final posts = result
        .map(
          (postMap) => Post.fromMap(postMap),
        )
        .toList();
    return posts;
  }

  @override
  Future<void> toggleLike({required String userId, required Post post}) async {
    final updatedLikes = post.likes;
    //removeUserId
    if (post.likes.contains(userId)) {
      updatedLikes.remove(userId);
    }
    //addUserId
    else {
      updatedLikes.add(userId);
    }

    await postTable.update({
      'likes': updatedLikes,
    }).eq('id', post.id!);
  }

  @override
  Future<void> addComment(
      {required Comment comment, required Post post}) async {
    final updatedComments = post.comments;
    updatedComments.add(comment);
    final mapComments = updatedComments
        .map(
          (e) => e.toMap(),
        )
        .toList();
    await postTable.update({'comments': mapComments}).eq('id', post.id!);
  }

  @override
  Future<void> deleteComment(
      {required Comment comment, required Post post}) async {
    final updatedComments = post.comments;
    updatedComments.remove(comment);
    final mapComments = updatedComments
        .map(
          (e) => e.toMap(),
        )
        .toList();
    await postTable.update({'comments': mapComments}).eq('id', post.id!);
  }
}
