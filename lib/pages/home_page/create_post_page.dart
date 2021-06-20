import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/data/data.dart';
import 'package:instagram_clone/pages/home_page/my_home_page.dart';
import 'package:instagram_clone/services/my_auth_class.dart';
import 'package:email_validator/email_validator.dart';
import 'package:instagram_clone/services/my_db_class.dart';
import 'package:instagram_clone/services/shared_pref.dart';
import 'package:instagram_clone/services/upload_img_firebase.dart';
import 'package:instagram_clone/services/upload_video_firebase.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  GlobalKey<FormState> _formKey;
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _desController;

  //type:String(image/video),file:File
  List<Map<String, dynamic>> posts = [];
  List<Map<String, String>> postsUrl = [];

  final ImagePicker _picker = ImagePicker();
  VideoPlayerController _controller;
  bool isObscure;
  bool isLoading;
  String category = "";

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    _desController = TextEditingController();
    isObscure = true;
    isLoading = false;
    print(DateTime.now().toString());
    //MyDBClass.getPostsByUid('F33qLEMjHVZAX0NptrzWTOroznW2');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  (posts.isEmpty)
                      ? Container()
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          height: MediaQuery.of(context).size.width / 3,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                return _userPost(index);
                              }),
                        ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 2, 20, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(
                          flex: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (posts.length == 5) {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text('Can\'t add more than 5 items'),
                              ));
                            } else {
                              selectImage();
                            }
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.width / 5,
                            width: MediaQuery.of(context).size.width / 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo_outlined,
                                  color: Colors.purple[300],
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  'Photo',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border:
                                  Border.all(width: 1, color: Colors.grey[300]),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                        ),
                        /*Spacer(
                          flex: 3,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (posts.length == 5) {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text('Can\'t add more than 5 items'),
                              ));
                            } else {
                              //selectVideo();
                            }
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.width / 5,
                            width: MediaQuery.of(context).size.width / 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.video_library_outlined,
                                  color: Colors.purple[300],
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  'Video',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border:
                                  Border.all(width: 1, color: Colors.grey[300]),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                        ),*/
                        Spacer(
                          flex: 5,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(35.0, 2, 8, 14),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Choose a category:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 10,
                    children: List<Widget>.generate(categories.length, (index) {
                      bool isSelected = category == categories[index];
                      return FilterChip(
                        selectedColor: Theme.of(context).accentColor,
                        selected: isSelected,
                        checkmarkColor: Colors.white,
                        label: Text(categories[index]),
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: (isSelected)
                                ? Colors.white70
                                : Theme.of(context).textTheme.bodyText1.color),
                        onSelected: (bool selected) {
                          if (selected) {
                            setState(() {
                              category = categories[index];
                            });
                          } else {
                            setState(() {
                              category = null;
                            });
                          }
                        },
                      );
                    }),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
                    child: TextFormField(
                      maxLines: null,
                      controller: _desController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(30.0),
                        hintText: 'Description',
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.grey)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 20,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: isLoading ? Colors.grey : Colors.purple,
                        child: Text(
                          isLoading ? 'Uploading' : 'Upload',
                          style: TextStyle(
                              color: (isLoading) ? Colors.black : Colors.white),
                        ),
                        onPressed: () async {
                          if (isLoading) {
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });

                          await upload(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _userPost(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.width / 5,
            width: MediaQuery.of(context).size.width / 5,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: (posts[index]['type'] == "video")
                    ? NetworkImage(
                        'https://www.nicepng.com/png/detail/237-2374440_your-details-twitter-video-play-button.png')
                    : FileImage(
                        posts[index]['file'],
                      ),
              ),
              border: Border.all(width: 1, color: Colors.black),
            ),
          ),
          Positioned(
            right: -8.0,
            top: -20.0,
            child: Container(
              width: 30,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    posts.removeAt(index);
                  });
                },
              ),
              decoration: BoxDecoration(
                color: Colors.purple,
                shape: BoxShape.circle,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> selectVideo() async {
    PickedFile pickedFile = await _picker.getVideo(
        source: ImageSource.gallery, maxDuration: Duration(minutes: 2));
    var _video = File(pickedFile.path);
    /*_videoPlayerController = VideoPlayerController.file(_video)..initialize().then((_) {
      setState(() { });
      _videoPlayerController.play();
      posts.add(_video);
    });*/
    _controller = VideoPlayerController.network(_video.path)
      ..initialize().then((_) {
        setState(() {
          posts.add({'type': 'video', 'file': _video});
        }); //when your thumbnail will show.
      });
  }

  Future<void> selectImage() async {
    var picture = await _picker.getImage(source: ImageSource.gallery);
    if (picture != null) {
      var croppedPic = await ImageCropper.cropImage(
        sourcePath: picture.path,
        aspectRatio: CropAspectRatio(
          ratioX: 1,
          ratioY: 1,
        ),
        compressQuality: 100,
        maxHeight: 1000,
        maxWidth: 1000,
        compressFormat: ImageCompressFormat.png,
      );
      if (croppedPic != null) {
        setState(() {
          posts.add({'type': 'image', 'file': croppedPic});
        });
      }
    }
  }

  upload(BuildContext context) async {
    if (posts.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Please choose some media'),
      ));
      setState(() {
        isLoading = false;
      });
    } else if (category == "") {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Please choose a category'),
      ));
      setState(() {
        isLoading = false;
      });
    } else {
      try {
        //todo: upload me gadbad h,vid late upload hoti h to db me ni jati
        print('posts' + posts.toString());
        var i = posts.length;
        print(i.toString() + ' ' + posts.toString());
        posts.forEach((post) async {
          i--;
          if (post['type'] == 'image') {
            String url = await uploadImage(post['file']);
            if (url == '') throw Exception();
            postsUrl.add({'type': 'image', 'file': url});
            print(postsUrl);
            if (i == 0) {
              await MyDBClass.addPosts(postsUrl, _desController.text, category);
              setState(() {
                posts = [];
                _desController.text = '';
                category = '';
              });
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text('Upload successful'),
              ));
            }
          } else {
            String url = await uploadVideo(post['file']);
            if (url == '') throw Exception();
            postsUrl.add({'type': 'video', 'file': url});
            if (i == 0) {
              await MyDBClass.addPosts(postsUrl, _desController.text, category);
              setState(() {
                posts = [];
                _desController.text = '';
                category = '';
              });
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text('Upload successful'),
              ));
            }
          }
        });
      } on Exception catch (e) {
        print(e);
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Some error occurred'),
        ));
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        print(e);
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Some error occurred'),
        ));
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
