import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:massenger/models/message_model.dart';
import 'package:massenger/screens/chat_screen.dart';

class RecentChats extends StatefulWidget  {
  String MyEmail;
  RecentChats(this.MyEmail);

  @override
  _RecentChatsState createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {



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
    return FutureBuilder(
      future: Firestore.instance.collection('chat').where("chat_emails",arrayContains: widget.MyEmail).orderBy("creeate_at",descending:true ).get() ,
      builder: (context, doc_recentchat_snapshot) {
    if(doc_recentchat_snapshot.connectionState==ConnectionState.waiting){
    return Expanded(
    child: Container(color: Colors.white,
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
      Center(child: Container()),
      ],
      ),
    ),
    );

    }else {
        var doc_recentchat=doc_recentchat_snapshot.data.documents;
        if(doc_recentchat.length ==0){
          return Expanded(
            child: Container(color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(child:Text(" There are no chat yet. ",style: TextStyle(
                      color: Colors.grey,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),) ),
                  ),
                ],
              ),
            ),
          );
        }
        return Expanded(
          child: Container(padding: EdgeInsets.only(top: 5),
              color: Colors.white,
            child: RefreshIndicator(color: Colors.green,onRefresh: ()async{
              await Future.delayed(Duration(seconds: 1));
              setState(() {

              });
            },
              child: ListView.builder(
                itemCount: doc_recentchat.length,
                itemBuilder: (BuildContext context, int index) {
                  String user_email,doc_chat;
                  if(doc_recentchat[index]["chat_emails"][0]== widget.MyEmail){
                    user_email=doc_recentchat[index]["chat_emails"][1];
                  }else{
                    user_email=doc_recentchat[index]["chat_emails"][0];

                  }
                  doc_chat=doc_recentchat[index].documentID;

                  return FutureBuilder(
                    future: Firestore.instance.collection("chat").document(doc_chat).collection('msg').orderBy('creeate_at',descending:true ).limit(1).get(),
                    builder: (context, last_message_snapshot) {
    if(last_message_snapshot.connectionState==ConnectionState.waiting){
    return Container();

    }else {
    var last_message=last_message_snapshot.data.documents;
//print(last_message[3]["msg"]);

//"send by"
//print(last_message[index]["seen"].toString());
                      return StreamBuilder(
                        stream: Firestore.instance.collection("users").document(user_email).snapshots(),
                        builder: (context, userssnapshot) {
    if(userssnapshot.connectionState==ConnectionState.waiting){
    return Container();

    }else {
      var users = userssnapshot.data;



      return GestureDetector(onLongPress: (){


          // set up the buttons
          Widget cancelButton = FlatButton(
              child: Text("Cancel"),
              onPressed:  () {
                Navigator.pop(context);
              },
          );
          Widget continueButton = FlatButton(
              child: Text("Remove"),
              onPressed:  () async{

                await FirebaseFirestore.instance.collection('chat').document(doc_chat).delete();
                await FirebaseFirestore.instance.collection('users').document(widget.MyEmail).updateData({
                  'friends':FieldValue.arrayRemove([user_email]),
                });
                await FirebaseFirestore.instance.collection('users').document(user_email).updateData({
                  'friends':FieldValue.arrayRemove([widget.MyEmail]),
                });
                Navigator.pop(context);

              },
          );

          // set up the AlertDialog
          AlertDialog alert = AlertDialog(
              title: Text("Warning"),
              content: Text("Do you want to remove this chat and delete from friends?"),
              actions: [
                cancelButton,
                continueButton,
              ],
          );

          // show the dialog
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert;
              },
          );

},
                            onTap: () => Navigator.push(context,
                              MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                  user_email:user_email,my_email: widget.MyEmail,
                                ),
                              ),
                            ).then((value) {
                              setState(() {

                              });
                            }),
                            child: Container(
                              margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0,left: 1),
                              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                              decoration: BoxDecoration(
                                color: (last_message[0]["seen"]==false && last_message[0]["send by"]!=widget.MyEmail)? Color(0xFFFFEFEE) : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0),
                                  topLeft: Radius.circular(20.0),
                                  bottomLeft: Radius.circular(20.0),

                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Stack(children: [
                                        CircleAvatar(radius: 35.0, backgroundImage: NetworkImage(users["user_image"]),//AssetImage('assets/images/sophia.jpg'),
                                        ),


                                        if(users["active"])Positioned(bottom: 0,right: 9,
                                          child: Container(width: 13,height: 13,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.green,
                                              border: Border.all(color: Colors.white,
                                                width: 1,
                                              ),),
                                          ),)


                                      ],
                                      ),
                                      SizedBox(width: 10.0),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[

                                          Text(trimText(users["user_name"].toString().length,users["user_name"]),
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5.0),
                                          Container(
                                            width: MediaQuery.of(context).size.width * 0.45,
                                            child: Text(last_message[0]["msg"],
                                              style: TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text((DateFormat('HH:mm a').format(last_message[0]["creeate_at"].toDate())).toString(),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,

                                      ),
                                      SizedBox(height: 5.0),
                                      if(last_message[0]["send by"]!=widget.MyEmail)last_message[0]["seen"]==false ? Container(
                                              width: 40.0,
                                              height: 20.0,
                                              decoration: BoxDecoration(
                                                color: Colors.red,//Theme.of(context).primaryColor,
                                                borderRadius: BorderRadius.circular(30.0),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'NEW',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          : Text(''),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );}
                        }
                      );
                    }
                    }
                  );
                },
              ),
            ),
          ),
        );}
      }
    );
  }
}
