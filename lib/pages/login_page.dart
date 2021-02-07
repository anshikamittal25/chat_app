import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'file:///C:/Users/lenovo/AndroidStudioProjects/instagram_clone/lib/pages/home_page/feed_page.dart';
import 'file:///C:/Users/lenovo/AndroidStudioProjects/instagram_clone/lib/pages/home_page/my_home_page.dart';
import 'package:instagram_clone/pages/register_page.dart';
import 'package:instagram_clone/pages/verify_email.dart';
import 'package:instagram_clone/services/my_auth_class.dart';
import 'package:instagram_clone/services/shared_pref.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey;
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  bool isObscure;
  bool isLoading;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    isObscure = true;
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(
                flex: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Instagram',
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'Pattaya', fontSize: 50),
                ),
              ),
              Form(
                key: _formKey,
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 20,
                          child: TextFormField(
                            controller: _emailController,
                            validator: (s) {
                              if (s.isEmpty) {
                                return 'Please enter Email Id';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              hintText: 'Email',
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 20,
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
                                    color:
                                        (isObscure) ? Colors.grey : Colors.blue,
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
                              (isLoading) ? 'Logging In' : 'Log In',
                              style: TextStyle(color: isLoading ? Colors.black : Colors.white),
                            ),
                            onPressed: () async {
                              if(isLoading){
                                return ;
                              }
                              await login(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(
                flex: 10,
              ),
              Container(
                height: 1,
                color: Colors.grey,
                width: MediaQuery.of(context).size.width,
              ),
              Spacer(
                flex: 1,
              ),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account? '),
                      Text(
                        'Sign up',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
              ),
              Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  login(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading=true;
      });
      String s = await MyAuthClass.signInEmail(
          context, _emailController.text, _passwordController.text);
      //print(s);
      /*if (s == 'unverified') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyEmail(email: _emailController.text,),
          ),
        );
      }
      else*/
      if (s == 'success') {
        addBoolToSF(true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ),
        );
      } else if (s != null) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(s),
        ));
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Some error occurred.'),
      ));
    }
  }
}
