import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:massenger/screens/home_screen.dart';
class SplashScreen2 extends StatefulWidget {




  @override
  _SplashScreen2State createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
var user;



  prepare()async{
    var email= await FirebaseAuth.instance.currentUser.email;
    await Firestore.instance.collection("users").document(email).get().then((userdata) {
      if(userdata.exists) {
        setState(() {
          user=userdata;

        });

      }else{
         Future.delayed(const Duration(seconds: 3), () {
          prepare();
         });

      }


    });


  }

  @override
  void initState() {
    prepare();
    super.initState();




  }
@override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

      return user!=null ? HomeScreen(user["email"],user["user_image"],user["user_name"]):Scaffold(
          backgroundColor: Theme
              .of(context)
              .primaryColor,
          body: Container(color: Colors.white,
            child: Center(
              child: Text(
                'Loading...', style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          )

      );

  }
}
