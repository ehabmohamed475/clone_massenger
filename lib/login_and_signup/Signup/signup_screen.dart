import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:massenger/login_and_signup/Login/login_screen.dart';
import 'package:massenger/login_and_signup/components/already_have_an_account_acheck.dart';

import '../../constants.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
String validate_text="";
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'user_name': '',
    'image': '',
  };
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  final _passwordController = TextEditingController();
  var _pickedImage;




  void createemail()async{
    setState(() {
      _isLoading = true;
    });
    try {

      var authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _authData['email'], password: _authData['password'],);
      final ref =await FirebaseStorage.instance.ref().child("user").child(authResult.user.uid+'.jpg');
      await ref.putFile(File(_authData["image"]));
      final url = await ref.getDownloadURL();
      await Firestore.instance.collection('users').document(authResult.user.email).setData({
        'user_name':_authData['user_name'],
        'email':_authData['email'],
        'user_image':url,
        'password':_authData['password'],
        "active":false,
        'friends':[],

      });



    }catch(e){
      setState(() {
        _isLoading = false;
        validate_text="This Email Is Reserved Try Another E-mail";

      });





    }
  }
  void save() {
    var validate = _formKey.currentState.validate();
    if (!validate) {
      return;
    } else {
      _formKey.currentState.save();
      if (_pickedImage == null) {
        setState(() {
          validate_text="Please Pick A Photo";

        });



      } else {
        createemail();
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(height: size.height,
        width: double.infinity,
        // Here i can use size.width but use double.infinity because both work as a same
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(top: 0, left: 0,
              child: Image.asset(
                "assets/images/main_top.png", width: size.width * 0.35,),
            ),
            Positioned(bottom: 0, right: 0,
              child: Image.asset(
                "assets/images/login_bottom.png", width: size.width * 0.25,),
            ),
            Form(key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    SizedBox(height: size.height * 0.03),

                    Stack(children: [

                      _pickedImage == null ? CircleAvatar(
                        radius: 60, backgroundColor: kPrimaryLightColor,)
                          : CircleAvatar(radius: 60,
                        backgroundColor: kPrimaryLightColor,
                        backgroundImage: FileImage(_pickedImage),),

                      Positioned(bottom: 15, right: 40, child: IconButton(
                        icon: Icon(Icons.edit, color:_pickedImage == null ? kPrimaryColor:Colors.white, size: 50,),
                        onPressed: () async {
                          final pickedImageFile = await ImagePicker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 70,maxWidth: 150,
                            );
                          setState(() {
                            _pickedImage = pickedImageFile;
                            _authData['image'] = pickedImageFile.path;
                          });
                        },),)

                    ],),
                    SizedBox(height: size.height * 0.03),


                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.8,

                      decoration: BoxDecoration(color: kPrimaryLightColor,
                        borderRadius: BorderRadius.circular(29),),
                      child: TextFormField(textDirection: TextDirection.ltr,
                        key: ValueKey("user name"),
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          _authData['user_name'] = value;
                        },
                        validator: (value) {
                          if (value
                              .trim()
                              .isEmpty) {
                            return 'The User Name Is Empaty !';
                          } else if (value.trim().length < 2) {
                            return 'Please Write At Lest 7 Character';
                          }
                        },
                        cursorColor: kPrimaryColor,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(icon: Icon(
                          Icons.person, color: kPrimaryColor,),
                          hintText: "User Name",
                          border: InputBorder.none,),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.8,

                      decoration: BoxDecoration(color: kPrimaryLightColor,
                        borderRadius: BorderRadius.circular(29),),
                      child: TextFormField(textDirection: TextDirection.ltr,
                        key: ValueKey("email"),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                        var lower=value.toLowerCase();

                          if (value
                              .trim()
                              .isEmpty) {
                            return 'The E-Mail Is Empaty !';
                          } else if (!value.contains('@gmail') ||
                              !value.contains('.com')) {
                            return 'Invalid email!';
                          } else if (value
                              .trim()
                              .length < 14) {
                            return 'Invalid email!';
                          }else if(lower!=value){
                            return 'Write small letters in email!';

                          }
                        },
                        onSaved: (value) {
                          _authData['email'] = value;
                        },
                        cursorColor: kPrimaryColor,
                        decoration: InputDecoration(icon: Icon(
                          Icons.people, color: kPrimaryColor,),
                          hintText: "Your Email",
                          border: InputBorder.none,),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(color: kPrimaryLightColor,
                        borderRadius: BorderRadius.circular(29),),
                      child: TextFormField(textDirection: TextDirection.ltr,
                        key: ValueKey("password"),
                        controller: _passwordController,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value
                              .trim()
                              .isEmpty) {
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
                        decoration: InputDecoration(hintText: "Password",
                          icon: Icon(Icons.lock, color: kPrimaryColor,),
                          suffixIcon: Icon(
                            Icons.visibility, color: kPrimaryColor,),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: kPrimaryLightColor,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(textDirection: TextDirection.ltr,
                        key: ValueKey("confirm_passwoed"),
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value
                              .trim()
                              .isEmpty) {
                            return 'The Confirm Password Is Empaty !';
                          } else if (value != _passwordController.text) {
                            return 'Passwords do not match!';
                          }
                        },
                        obscureText: true,
                        cursorColor: kPrimaryColor,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          icon: Icon(Icons.lock, color: kPrimaryColor,),
                          suffixIcon: Icon(
                            Icons.visibility,
                            color: kPrimaryColor,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    _isLoading ?
                    CircularProgressIndicator(backgroundColor: Colors.red,) :
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      width: size.width * 0.8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 40),
                          color: Colors.red,
                          onPressed: () {
                            save();
                          },
                          child: Text(
                            "SIGNUP", style: TextStyle(color: Colors.white),),
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
                      login: false,
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginScreen();
                            },
                          ),
                        );
                      },
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
