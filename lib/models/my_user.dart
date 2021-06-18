class MyUser {
  String uid;
  String bio;
  String username;
  String name;
  String userPic;
  String email;

  MyUser(
      {this.username, this.email, this.userPic, this.uid, this.bio, this.name});

  factory MyUser.fromJson(Map<String, dynamic> json, String id) {
    return MyUser(
      uid: id,
      bio: json['bio'],
      username: json['username'],
      name: json['name'],
      email: json['email'],
      userPic: json['userPic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'username': username,
      'userPic': userPic,
      'name': name,
      'email': email,
    };
  }
}
