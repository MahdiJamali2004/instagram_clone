import 'dart:io';

import 'package:instagram_clone/features/post/domain/entities/comment.dart';
import 'package:instagram_clone/features/post/domain/entities/post.dart';

abstract class PostRepo {
  Future<void> createPost({required Post post, required File postImage});
  Future<void> deletePost({required int postId});
  Future<List<Post>> getAllPosts();
  Future<List<Post>> getPostByUserId({required String userId});
  Future<void> toggleLike({required String userId, required Post post});
  Future<void> addComment({required Comment comment, required Post post});
  Future<void> deleteComment({required Comment comment, required Post post});
}
