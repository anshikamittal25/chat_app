import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/my_user.dart';
import 'package:instagram_clone/pages/home_page/profile_page.dart';
import 'package:instagram_clone/services/my_db_class.dart';
import 'package:instagram_clone/services/upload_img_firebase.dart';

class EditProfilePage extends StatefulWidget {
  final MyUser user;

  EditProfilePage({Key key, this.user}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  GlobalKey<FormState> _formKey;
  GlobalKey<ScaffoldState> _scaffoldKey;
  File fileImage;
  final ImagePicker _imagePicker = ImagePicker();
  String networkImg;
  TextEditingController _nameController;
  TextEditingController _bioController;
  bool isLoading;
  int maxLines = 5;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    _nameController = TextEditingController();
    _bioController = TextEditingController();
    isLoading = false;
    _nameController.text = widget.user.name;
    _bioController.text = widget.user.bio;
    networkImg = widget.user.userPic;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              Form(
                key: _formKey,
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 20),
                        child: _userImageSelect(),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
                        child: TextFormField(
                          controller: _nameController,
                          validator: (s) {
                            if (s.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: 'Name',
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
                        child: Container(
                          height: MediaQuery.of(context).size.height /
                              20 *
                              maxLines,
                          child: TextFormField(
                            maxLines: maxLines,
                            controller: _bioController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              hintText: 'Enter a short bio',
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 20,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            color: isLoading ? Colors.grey : Colors.pink[900],
                            child: Text(
                              isLoading ? 'Updating' : 'Update',
                              style: TextStyle(
                                  color: (isLoading)
                                      ? Colors.black
                                      : Colors.white),
                            ),
                            onPressed: () async {
                              if (isLoading) {
                                return;
                              }
                              await update(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userImageSelect() {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        (fileImage == null)
            ? CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(networkImg),
              )
            : Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: FileImage(
                        fileImage,
                      ),
                    )),
              ),
        Positioned(
          right: -10.0,
          bottom: -5.0,
          child: Container(
            child: IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                _selectImage();
              },
            ),
            decoration: BoxDecoration(
              color: Colors.pink[900],
              shape: BoxShape.circle,
            ),
          ),
        )
      ],
    );
  }

  Future<void> _selectImage() async {
    var picture = await _imagePicker.getImage(source: ImageSource.gallery);
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
      setState(() {
        fileImage = croppedPic;
        print(fileImage.path);
      });
    } else {
      setState(() {
        fileImage = null;
      });
    }
  }

  update(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      String url = widget.user.userPic;
      if (fileImage != null) {
        url = await uploadImage(fileImage);
      }
      await MyDBClass.updateUserInfo(
          _nameController.text, _bioController.text, url);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Data updated successfully'),
      ));
      Navigator.pop(context);
    }
  }
}
