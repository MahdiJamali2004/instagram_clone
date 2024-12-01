class ProfileUser {
  final int? id;
  final String userId;
  final String username;
  final String bio;
  final String email;
  final String? profilePicPath; // path like profilePic/filename
  final List<String> followers;
  final List<String> followings;

  ProfileUser(
      {this.id,
      required this.username,
      required this.bio,
      required this.userId,
      required this.email,
      required this.profilePicPath,
      required this.followers,
      required this.followings});

  // Method to convert a map to a ProfileUser instance
  factory ProfileUser.fromMap(Map<String, dynamic> map) {
    return ProfileUser(
      id: map['id'] as int,
      bio: map['bio'] as String,
      userId: map['userId'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      profilePicPath: map['profilePicPath'] as String?,
      followers: List<String>.from(map['followers'] as List<dynamic>),
      followings: List<String>.from(map['followings'] as List<dynamic>),
    );
  }

  // Method to convert a ProfileUser instance to a map
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'bio': bio,
      'userId': userId,
      'email': email,
      'profilePicPath': profilePicPath,
      'followers': followers,
      'followings': followings,
    };
  }

  ProfileUser copyWith({
    int? id,
    String? userId,
    String? username,
    String? bio,
    String? email,
    String? profilePicPath,
    List<String>? followers,
    List<String>? followings,
  }) {
    return ProfileUser(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      email: email ?? this.email,
      profilePicPath: profilePicPath ?? this.profilePicPath,
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
    );
  }
}
