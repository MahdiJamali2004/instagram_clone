class Comment {
  final String id;
  final int postId;
  final String text;
  final String userId;
  final String username;
  final DateTime timestamp;

  Comment(
      {required this.text,
      required this.postId,
      required this.timestamp,
      required this.id,
      required this.username,
      required this.userId});

  // Convert a Comment object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'text': text,
      'userId': userId,
      'username': username,
      'timestamp': timestamp.toIso8601String(), // Convert DateTime to String
    };
  }

  // Create a Comment object from a Map
  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as String,
      postId: map['postId'] as int,
      text: map['text'] as String,
      userId: map['userId'] as String,
      username: map['username'] as String,
      timestamp: DateTime.parse(
          map['timestamp'] as String), // Convert String to DateTime
    );
  }
}
