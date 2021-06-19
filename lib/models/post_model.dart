class Post{

  String id;
  String uid;
  List urls;
  int likes;
  String description;
  String time;
  int timeStamp;
  String date;
  String category;

  Post({this.id,this.uid,this.urls,this.likes,this.description,this.time,this.date,this.category,this.timeStamp});

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
    };
  }

}