class Post{

  String id;
  String uid;
  String username;
  String userPic;
  List urls;
  int likes;
  String description;
  String time;
  int timeStamp;
  String date;
  String category;

  Post({this.id,this.uid,this.urls,this.likes,this.description,this.time,this.date,this.category,this.username,this.timeStamp,this.userPic});

  factory Post.fromJson(Map<String,dynamic> json,String id){
    return Post(
      id:id,
      urls: json['urls'],
      uid: json['uid'],
      likes: json['likes'],
      description: json['description'],
      date: json['date'],
      time: json['time'],
      timeStamp: json['timeStamp'],
      category: json['category'],
      username: json['username'],
      userPic: json['userPic'],
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'urls': urls,
      'uid': uid,
      'likes': likes,
      'description': description,
      'date': date,
      'time': time,
      'timeStamp': timeStamp,
      'category': category,
      'username': username,
      'userPic': userPic,
    };
  }

}