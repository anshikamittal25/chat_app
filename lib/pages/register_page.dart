import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/pages/home_page/my_home_page.dart';
import 'package:instagram_clone/services/my_auth_class.dart';
import 'package:email_validator/email_validator.dart';
import 'package:instagram_clone/services/my_db_class.dart';
import 'package:instagram_clone/services/shared_pref.dart';
import 'package:instagram_clone/services/upload_img_firebase.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> _formKey;
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  File userImage;
  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController _usernameController;
  TextEditingController _nameController;
  TextEditingController _bioController;
  bool isObscure;
  bool isLoading;
  int maxLines=5;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();
    _nameController = TextEditingController();
    _bioController = TextEditingController();
    isObscure = true;
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          validator: (s) {
                            if (s.isEmpty) {
                              return 'Please enter Email Id';
                            } else if (!EmailValidator.validate(s)) {
                              return 'Invalid email.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: 'Email',
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
                        child: TextFormField(
                          controller: _passwordController,
                          validator: (s) {
                            if (s.isEmpty) {
                              return 'Please enter Password';
                            }
                            return null;
                          },
                          obscureText: isObscure,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: 'Password',
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey)),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: IconButton(
                                icon: SvgPicture.asset(
                                  (isObscure)
                                      ? ('assets/icons/eye-off-outline.svg')
                                      : ('assets/icons/eye-outline.svg'),
                                ),
                                onPressed: () {
                                  setState(() {
                                    isObscure = !isObscure;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
                        child: TextFormField(
                          controller: _usernameController,
                          validator: (s) {
                            if (s.isEmpty) {
                              return 'Please enter an username';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: 'Username',
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey)),
                          ),
                        ),
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
                          height: MediaQuery.of(context).size.height / 20*maxLines,
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
                            color: isLoading ? Colors.grey : Colors.blue,
                            child: Text(
                              isLoading ? 'Registering' : 'Register',
                              style: TextStyle(
                                  color: (isLoading)
                                      ? Colors.black
                                      : Colors.white),
                            ),
                            onPressed: () async {
                              if (isLoading) {
                                return;
                              }
                              await register(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Container(
                height: 1,
                color: Colors.grey,
                width: MediaQuery.of(context).size.width,
              ),
              SizedBox(
                height: 13,
              ),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account? '),
                      Text(
                        'Log in',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                height: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userImageSelect() {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.width / 3,
          width: MediaQuery.of(context).size.width / 3,
          alignment:
              (userImage == null) ? Alignment(0.0, 0.0) : Alignment.center,
          child: (userImage == null)
              ? SizedBox(
                  height: MediaQuery.of(context).size.width / 3,
                  width: MediaQuery.of(context).size.width / 3,
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.black,
                    size: MediaQuery.of(context).size.width / 5,
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: FileImage(
                          userImage,
                        ),
                      )),
                ),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 1, color: Colors.black),
              ),
        ),
        Positioned(
          right: 0.0,
          bottom: 0.0,
          child: Container(
            child: IconButton(
              icon: Icon(
                (userImage == null) ? Icons.add : Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                _selectImage();
              },
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
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
        userImage = croppedPic;
        print(userImage.path);
      });
    } else {
      setState(() {
        userImage = null;
      });
    }
  }

  register(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      String s = await MyAuthClass.registerEmail(
          context, _emailController.text, _passwordController.text);
      if (s == 'The password provided is too weak.' ||
          s == 'The account already exists for that email.') {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(s),
        ));
      } else if (s != null) {
        setState(() {
          isLoading = true;
        });
        String url=await uploadImage(userImage);
        await MyDBClass.addUserInfo(_usernameController.text, _nameController.text,
            _bioController.text,url);
        //addBoolToSF('isUserSignedIn', true);
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Successfully registered'),
        ));
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                //builder: (context) => VerifyEmail(email: _emailController.text,),
                builder: (context) => MyHomePage()),
            (route) => false);
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Some error occurred.'),
        ));
      }
    }
  }
}
