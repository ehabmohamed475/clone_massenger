import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:massenger/login_and_signup/Login/login_screen.dart';
import 'package:massenger/screens/splash_screen.dart';
import 'package:massenger/screens/splash_screen2.dart';



void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red[600],
        accentColor: Color(0xFFFEF9EB),
      ),
      home:StreamBuilder(stream:FirebaseAuth.instance.onAuthStateChanged ,builder: (context, usersnapshot) {
        if(usersnapshot.connectionState==ConnectionState.waiting){
          return SplashScreen();
        }if(usersnapshot.hasData){

          return SplashScreen2();

        }
        return LoginScreen();

      },),
    );
  }
}
