import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/http_exception.dart';

import 'package:shop/providers/auth.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/Auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

enum AuthMode { SignUp, Login }

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var isLoding = false;
  final _passwordController = TextEditingController();

  void _switchAuthMOde() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Container(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipPath(
                    clipper: DrawClip(),
                    child: Container(
                      height: deviceSize.height / 2.4,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xffff5f6d), Color(0xffffc371)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                  Container(
                      height: deviceSize.height / 2.4,
                      width: double.infinity,
                      child: Image.network(
                          'https://i.postimg.cc/Gt0VM7MY/tinder.png'))
                ],
              ),
              //   if (_authMode == AuthMode.SignUp)
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: deviceSize.width * 0.1),
                child: Text(
                  _authMode == AuthMode.SignUp ? "SIGN UP " : "LOGIN",
                  style: GoogleFonts.mukta(
                      color: Color(0xffff5f6d),
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: deviceSize.width * 0.1, vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                      fillColor: Colors.grey[200],
                      hintText: 'Email Address',
                      filled: true),
                  validator: (val) {
                    if (val.isEmpty || !val.contains("@")) {
                      return "invailed email";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authData['email'] = val;
                    //   print(_authData['email']);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(

                    horizontal: deviceSize.width * 0.1, vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                      fillColor: Colors.grey[200],
                      hintText: 'Password',
                      suffixIcon: Icon(Icons.remove_red_eye),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      filled: true),
                  controller: _passwordController,
                  validator: (val) {
                    if (val.isEmpty || val.length <= 5) {
                      return "invailed password  ";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authData['password'] = val;
                    // print(_authData['password']);
                  },
                ),
              ),
              if (_authMode == AuthMode.SignUp)
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: deviceSize.width * 0.1, vertical: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        fillColor: Colors.grey[200],
                        hintText: 'Confirm Password',
                        suffixIcon: Icon(Icons.remove_red_eye),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        filled: true),
                    //controller: _passwordController,
                    validator: _authMode == AuthMode.SignUp
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'invailed password not match! ';
                            }
                            return null;
                          }
                        : null,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 210),
                child: Text("Forgot Password?",
                    style: GoogleFonts.mukta(
                        color: Colors.grey[500],
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: deviceSize.width * 0.1, vertical: 10),
                child: FlatButton(
                  onPressed: _submit,
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffff5f6d),
                          borderRadius: BorderRadius.circular(8)),
                      height: 50,
                      child: Center(
                          child: Text(
                        _authMode == AuthMode.Login ? 'LOGIN' : 'SIGNUP',
                        style: GoogleFonts.mukta(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Center(
                child: Text(
                  "OR",
                  style: GoogleFonts.mukta(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: deviceSize.width * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    social('https://i.postimg.cc/HxFdTLVG/google-plus.png'),
                    social('https://i.postimg.cc/0y4tWK3q/facebook-2.png'),
                    social('https://i.postimg.cc/GpsXZhwT/twitter-3.png'),
                    social('https://i.postimg.cc/7YYmqNrk/linkedin.png'),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              if (_authMode == AuthMode.Login)
                Center(
                  child: Text(
                    "Don't have an account?",
                    style: GoogleFonts.mukta(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              Expanded(
                child: FlatButton(
                  onPressed: _switchAuthMOde,
                  child: Center(
                    child: Text(
                      _authMode == AuthMode.SignUp ? "LOGIN" : "SIGNUP",
                      style: GoogleFonts.mukta(
                          fontSize: 15,
                          color: Color(0xffff5f6d),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    _formKey.currentState.save();

    setState(() {
      isLoding = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email'], _authData['password']);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData['email'], _authData['password']);
      }
    } on HttpException catch (error) {
      var errorMesage = 'Authentication failed ';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMesage = 'this email adrees is already in use. ';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMesage = 'This is not valid email address.';
      } else if (error.toString().contains('WEAK PASSWORD')) {
        errorMesage = ' This is not valid email address.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMesage = 'Could not find a user whis that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMesage = 'Invalid password.';
      }
      _showErrDailog(errorMesage);
    } catch (error) {
      const errorMsgee =
          'cloud not athenticate you , please try again  later .';
      _showErrDailog(errorMsgee);
    }

    setState(() {
      isLoding = false;
    });
  }

  void _showErrDailog(String errorMsgee) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('ANERROR OCCURRED !'),
              content: Text(errorMsgee),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text('okey'))
              ],
            ));
  }
}

Widget social(String url) {
  return Material(
    borderRadius: BorderRadius.circular(8),
    elevation: 10,
    child: Padding(
      padding: EdgeInsets.all(8),
      child: Image.network(
        url,
        height: 28,
        width: 28,
      ),
    ),
  );
}

class DrawClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width * 0.1, size.height - 50);
    path.lineTo(size.width * 0.9, size.height - 50);
    path.lineTo(size.width, size.height - 100);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
