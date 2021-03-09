import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:massenger/login_and_signup/Signup/signup_screen.dart';
import 'package:massenger/login_and_signup/components/already_have_an_account_acheck.dart';

import '../../constants.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String validate_text="";
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  final _passwordController = TextEditingController();


  void login()async{
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _authData['email'], password: _authData['password']);
    }catch(e){

      setState(() {
        _isLoading = false;
      });
      validate_text="Invalid E-mail";
    }
  }

  void save() {
    var validate = _formKey.currentState.validate();
    if (!validate) {
      return;
    } else {
      _formKey.currentState.save();
        login();
        //Navigator.of(context).pushNamed("/post_screen");
    }
  }







  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(width: double.infinity, height: size.height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(top: 0, left: 0,
              child: Image.asset("assets/images/main_top.png", width: size.width * 0.35,),
            ),
            Positioned(bottom: 0, right: 0,
              child: Image.asset("assets/images/login_bottom.png", width: size.width * 0.4,),
            ),
            Form(key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("LOGIN", style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: size.height * 0.03),
                    SvgPicture.asset("assets/icons/login.svg", height: size.height * 0.35,),
                    SizedBox(height: size.height * 0.03),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(color: kPrimaryLightColor, borderRadius: BorderRadius.circular(29),),
                    child: TextFormField(textDirection: TextDirection.ltr,
                      key: ValueKey("email"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'The E-Mail Is Empaty !';
                        } else if (!value.contains('@gmail') ||
                            !value.contains('.com')) {
                          return 'Invalid email!';
                        } else if (value
                            .trim()
                            .length < 14) {
                          return 'Invalid email!';
                        }
                      },
                      onSaved: (value) {
                        _authData['email'] = value;
                      },

                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(icon: Icon(Icons.person, color: kPrimaryColor,),
                        hintText: "Your Email",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: size.width * 0.8,
                  decoration: BoxDecoration(color: kPrimaryLightColor, borderRadius: BorderRadius.circular(29),),
                  child: TextFormField(textDirection: TextDirection.ltr,
                    key: ValueKey("password"),
                    controller: _passwordController,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'The Password Is Empaty !';
                      } else if (value.length < 7) {
                        return 'Password is too short!';
                      }
                    },
                    onSaved: (value) {
                      _authData['password'] = value;
                    },
                    obscureText: true,
                    cursorColor: kPrimaryColor,
                    decoration: InputDecoration(hintText: "Password", icon: Icon(Icons.lock, color: kPrimaryColor,),
                      suffixIcon: Icon(Icons.visibility, color: kPrimaryColor,),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                    _isLoading ?
                    CircularProgressIndicator(backgroundColor: Colors.red,) :Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: size.width * 0.8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(29),
                      child: FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                        color: Colors.red,
                        onPressed: (){
                          save();
                        },
                        child: Text("LOGIN", style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                    if(validate_text.isNotEmpty)Column(
                      children: [
                        SizedBox(height: size.height * 0.03),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(validate_text, style: TextStyle(color: kPrimaryColor),),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.03),
                    AlreadyHaveAnAccountCheck(
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SignUpScreen();
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),          ],
        ),
      ),
    );
  }
}
