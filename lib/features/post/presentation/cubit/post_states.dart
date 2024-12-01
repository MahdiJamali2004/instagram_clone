import 'package:instagram_clone/features/post/domain/entities/post.dart';

abstract class PostStates {}

class PostInitialState extends PostStates {}

class PostLoadingState extends PostStates {}

class PostLoadedState extends PostStates {
  final List<Post> posts;
  PostLoadedState({required this.posts});
}

class PostErrorState extends PostStates {
  final String message;
  PostErrorState({required this.message});
}
