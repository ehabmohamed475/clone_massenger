import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:massenger/login_and_signup/Login/login_screen.dart';


class AppDrawer extends StatefulWidget {
  Function change_category_selector;

var MyEmail;
var ctx;
  AppDrawer(this.MyEmail,this.ctx,this.change_category_selector);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {








  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0.0,

      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text('Massenger',style: TextStyle(
                fontSize: 28.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),),
              backgroundColor: Theme.of(context).primaryColor,

            ),
            SizedBox(height: 5,),

           /*

            CircleAvatar(radius: 30, backgroundImage:widget.imge_user != null? Image.network(widget.imge_user): AssetImage("img/angry.png"),),
            SizedBox(height: 5,),
            Text(widget.username !=null? widget.username :"Ehab ", style: TextStyle(
              fontWeight: FontWeight.bold,),),
            SizedBox(height: 5,),


            Divider(),
            */

            ListTile(
              leading: Icon(Icons.home,size: 30,),
              title: Text('Home',style:TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),),
              onTap: () {
                widget.change_category_selector(0);
                //widget.change_mode_from_drawer(NavBar.home);
                Navigator.of(context).pop();
              },
            ),

           // Divider(),


            ListTile(
              leading: Icon(Icons.supervised_user_circle,size: 30,),
              title: Text('Friends',style:TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),),
              onTap: () {
                widget.change_category_selector(1);

                //widget.change_mode_from_drawer(NavBar.trend);
                Navigator.of(context).pop();
              },
            ),

            //Divider(),


            ListTile(
              leading: Icon(Icons.person,size: 30,),
              title: Text('Add People',style:TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),),
              onTap: () {
                widget.change_category_selector(2);

                // widget.change_mode_from_drawer(NavBar.watchLater);
                Navigator.of(context).pop();
              },
            ),

//            Divider(),

/*
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Share Information With Us'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),

            Divider(),



 */


  //          Divider(),



            ListTile(
              leading: Icon(Icons.logout,size: 30,),
              title: Text('Log Out',style:TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),),
              onTap: () async{
                await offline();
                await FirebaseAuth.instance.signOut();
               Navigator.push(context,
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(),
                  ),
                );

              },
            ),


          ],
        ),
      ),
    );

  }
  void offline()async{
    WidgetsBinding.instance.removeObserver(widget.ctx);
    await Firestore.instance.collection('users').document( widget.MyEmail).updateData({
      "active":false,
    });
  }
}

/*
Drawer(
                      elevation: 0.0,

                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            AppBar(
                              title: Text('Hello My Friend!',),
                              backgroundColor: Colors.white,

                            ),
                            SizedBox(height: 5,),

                            CircleAvatar(radius: 30, backgroundImage:usersnapshot.data["img_user"] !=null ?Image.network(usersnapshot.data["img_user"])  :AssetImage(
                                "img/angry.png"),),
                            SizedBox(height: 5,),
                            Text("Ehab", style: TextStyle(
                              fontWeight: FontWeight.bold,),),
                            SizedBox(height: 5,),


                            Divider(),

                            ListTile(
                              leading: Icon(Icons.home),
                              title: Text('Home'),
                              onTap: () {
                                change_mode_from_drawer(NavBar.home);
                                Navigator.of(context).pop();
                              },
                            ),

                            Divider(),


                            ListTile(
                              leading: Icon(Icons.trending_up),
                              title: Text('Trend News'),
                              onTap: () {
                                change_mode_from_drawer(NavBar.trend);
                                Navigator.of(context).pop();
                              },
                            ),

                            Divider(),


                            ListTile(
                              leading: Icon(Icons.watch_later),
                              title: Text('Watch Later List'),
                              onTap: () {
                                change_mode_from_drawer(NavBar.watchLater);
                                Navigator.of(context).pop();
                              },
                            ),

                            Divider(),


                            ListTile(
                              leading: Icon(Icons.info_outline),
                              title: Text('Share Information With Us'),
                              onTap: () {
                                Navigator.of(context).pushReplacementNamed('/');
                              },
                            ),

                            Divider(),


                            ListTile(
                              leading: Icon(Icons.inbox_rounded),
                              title: Text('Inbox'),
                              onTap: () {
                                Navigator.of(context).pushReplacementNamed('/');
                              },
                            ),

                            Divider(),


                            ListTile(
                              leading: Icon(Icons.person),
                              title: Text('Complians'),
                              onTap: () {
                                Navigator.of(context).pushReplacementNamed('/');
                              },
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.logout),
                              title: Text('Log Out'),
                              onTap: () {
                                FirebaseAuth.instance.signOut();
                              },
                            ),


                          ],
                        ),
                      ),
                    );
 */