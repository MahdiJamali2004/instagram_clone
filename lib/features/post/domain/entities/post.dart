import 'package:instagram_clone/features/post/domain/entities/comment.dart';

class Post {
  final int? id;
  final String userId;
  final List<String> likes;
  final String imgPath;
  final String description;
  final List<Comment> comments;
  final DateTime? created_at;

  Post(
      {this.id,
      required this.userId,
      required this.description,
      required this.likes,
      required this.imgPath,
      required this.comments,
      this.created_at});

  // Factory constructor to create a Post from a Map
  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      description: map['description'],
      userId: map['userId'],
      likes: List<String>.from(map['likes']),
      imgPath: map['imgPath'],
      comments: (map['comments'] as List<dynamic>)
          .map((commentMap) => Comment.fromMap(commentMap))
          .toList(),
      created_at: DateTime.parse(map['created_at']),
    );
  }

  // Method to convert a Post into a Map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'likes': likes,
      'imgPath': imgPath,
      'description': description,
      'comments': comments.map((comment) => comment.toMap()).toList(),
    };
  }

  Post copyWith({
    String? userId,
    List<String>? likes,
    String? imgPath,
    String? description,
    List<Comment>? comments,
  }) {
    return Post(
      userId: userId ?? this.userId,
      likes: likes ??
          List<String>.from(this.likes), // Ensure a new list is created if null
      imgPath: imgPath ?? this.imgPath,
      description: description ?? this.description,
      comments: comments ??
          List<Comment>.from(this.comments), // Clone comments if null
    );
  }
}
