import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:massenger/screens/chat_screen.dart';

class FavoriteContacts extends StatefulWidget {
  String MyEmail;
Function refresh;

  FavoriteContacts(this.MyEmail,this.refresh);

  @override
  _FavoriteContactsState createState() => _FavoriteContactsState();
}

class _FavoriteContactsState extends State<FavoriteContacts> {
  String trimText(length,String text){
    if(length >7 ){
     // var x=length-8;
    String trimetext= text.substring(0,7);
   var trimetextsplite=trimetext.split(" ");
      return trimetextsplite[0];
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:Firestore.instance.collection('users').where("friends",arrayContains: widget.MyEmail).snapshots(),
      builder: (context, friends_snapshot) {
    if(friends_snapshot.connectionState==ConnectionState.waiting){
    return Container();

    }else {
      var friends_data=friends_snapshot.data.documents;
      //print(friends_data[0]['email']+friends_data[0]['user_image']+friends_data[0]['user_name']);

      if(friends_data.length==0 ){
        return Container();
      }
      bool check_active=false;
      for(int i=0;i<=friends_data.length-1;i++ ){
        if (friends_data[i]["active"] ==true) {
          check_active=true;
          break;
        }
      }


      return check_active==true ?  Padding(
          padding: EdgeInsets.fromLTRB(0,2,0,9),
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[//more_horiz supervised_user_circle
                    Text('Favorite Contacts',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 18.0, fontWeight: FontWeight.bold, letterSpacing: 1.0,),),
/*
                    Container(width: 25,height: 25,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.red,
                        border: Border.all(color: Colors.white,
                          width: 1,
                        ),),
                      child: Center(child: FittedBox(child: Text("4",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.bold),))),)

*/

                    IconButton(icon: Icon(Icons.zoom_in,), iconSize: 25.0, color: Colors.blueGrey,
                      onPressed: () {},
                    ),




                  ],
                ),
              ),
              Container(height: 99.0,
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 10.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: friends_data.length,
                  itemBuilder: (BuildContext context, int index) {
                    if(friends_data[index]['active']==false){
                      return Container();
                    }


                    return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              user_email:friends_data[index]['email'],my_email: widget.MyEmail,
                            ),
                          ),
                        ).then((value) {
                          widget.refresh();
                        }),
                        child: Container(width: 90,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 2, 10, 0),
                            child: Column(
                              children: <Widget>[
                            Stack(children: [
                              CircleAvatar(
                                  radius: 35.0,
                                  backgroundImage:NetworkImage(friends_data[index]['user_image'])
                                     // AssetImage(favorites[index].imageUrl),
                                ),
                            Positioned(bottom: 0,right: 9,
                              child: Container(width: 13,height: 13,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.green,
                                  border: Border.all(color: Colors.white,
                                    width: 1,
                                  ),),
                              ),)
                            ],

                          ),
                                SizedBox(height: 8.0),
                                FittedBox(
                                  child: Text(trimText(friends_data[index]['user_name'].toString().length,friends_data[index]['user_name']),
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 15.0, fontWeight: FontWeight.w600,

                                    ),
                                    overflow: TextOverflow.fade,                              ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );


                  },
                ),
              ),
            ],
          ),
        ):Container();
    }
      }
    );
  }
}
