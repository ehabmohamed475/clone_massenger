import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:massenger/widgets/app_drawer.dart';
import 'package:massenger/widgets/category_selector.dart';
import 'package:massenger/widgets/favorite_contacts.dart';
import 'package:massenger/widgets/prepare_friends.dart';
import 'package:massenger/widgets/prepare_users_search_and_friends.dart';
import 'package:massenger/widgets/recent_chats.dart';
import 'package:massenger/widgets/search_to_add_to_massenger.dart';
import 'package:massenger/widgets/list_users_search_and_friends.dart';

class HomeScreen extends StatefulWidget {
  var MyEmail,user_image,MyUserName;

  HomeScreen(this.MyEmail, this.user_image, this.MyUserName);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{

  int recent_message=0;
  int category_selector = 0;
  String key_search="";

@override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.paused:offline(false);
      break;
      case AppLifecycleState.inactive:offline(false);
      break;
      case AppLifecycleState.detached:offline(false);
      break;
      case AppLifecycleState.resumed:offline(true);
      break;

    }
  }

void refresh(){
  setState(() {

  });
}


  void offline(bool active)async{
  //print(widget.MyEmail);
    await Firestore.instance.collection('users').document( widget.MyEmail).updateData({
      "active":active,
    });

  }
@override
  void dispose() {
  WidgetsBinding.instance.removeObserver(this);
  offline(false);
    super.dispose();
  }

  @override
  void initState() {
  offline(true);
prepare();
WidgetsBinding.instance.addObserver(this);
    super.initState();
  }
  void prepare()async{


   await Firestore.instance.collection('chat').where("chat_emails",arrayContains: widget.MyEmail).get().then((value) {
     var doc_recentchat=value.documents;
     //print(doc_recentchat);
     doc_recentchat.forEach((value)async {
      await Firestore.instance.collection("chat").document(value.documentID).collection('msg').orderBy('creeate_at',descending:true ).limit(1).get().then((value2) {
        if(value2.documents[0]["send by"]!=widget.MyEmail && value2.documents[0]["seen"]==false){
          setState(() {
            recent_message++;

          });
        }

      });

     });   });





  }




  void change_key_search(key_Search){
    setState(() {
      key_search = key_Search;
    });

  }

  void change_category_selector(index){
    setState(() {
      category_selector = index;
      key_search="";
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(drawer: AppDrawer(widget.MyEmail,this,change_category_selector),
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          'Chats',
          style: TextStyle(
            fontSize: 28.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          Stack(children: [
             Container(padding: EdgeInsets.all(10)
                ,child: CircleAvatar(backgroundImage: NetworkImage(widget.user_image),radius: 18,)),
            Positioned(left: 3,top: 3,child: Container(width: 19,height: 19,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.red,
    border: Border.all(color: Colors.white,
    width: 1,
    ),),
    child: Center(child: FittedBox(child: Text(recent_message.toString(),style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.bold),))),),),

  ]
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          //CategorySelector
          CategorySelector(category_selector,change_category_selector),




          //active dashboard
          if(category_selector == 0)Container(
            decoration: BoxDecoration(color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),

              ),
            ),
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),

                ),
              ),
              child: Column(
                children: <Widget>[
                  FavoriteContacts(widget.MyEmail,refresh),
                ],
              ),
            ),
          ),




          //RecentChats
          if(category_selector == 0)RecentChats(widget.MyEmail),


          if(category_selector == 1)Expanded(
            child: Container(color: Colors.white,
              child: Column(children: [
                SizedBox(height: 15,),
                //SizedBox(height: 15,),
                prepare_friends(widget.MyEmail),

              ],),
            ),
          ),





          if(category_selector == 2)Expanded(
            child: Container(color: Colors.white,
              child: Column(children: [
                SizedBox(height: 15,),
                search_to_add_to_massenger(change_key_search),
                //SizedBox(height: 15,),

                prepare_users_search_and_friends(key_search,widget.MyEmail),

              ],),
            ),
          )





        ],
      ),
    );
  }
}
/*
 Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  FavoriteContacts(),
                  RecentChats(),
                ],
              ),
            ),
          ),
 */