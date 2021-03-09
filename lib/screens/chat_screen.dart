import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:massenger/widgets/input_chat.dart';
import 'package:massenger/widgets/type_a_message.dart';


class ChatScreen extends StatefulWidget {
  var user_email,my_email;

  ChatScreen({this.user_email,this.my_email});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver{
  var doc_chat;
  bool typing=false;
  bool isEmojiVisible = false;

  void setEmjiVisible(emoj){
    setState(() {
      isEmojiVisible=emoj;
    });

  }



  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.paused:offline(false);typing_function();
      break;
      case AppLifecycleState.inactive:offline(false);typing_function();
      break;
      case AppLifecycleState.detached:offline(false);typing_function();
      break;
      case AppLifecycleState.resumed:offline(true);
      break;

    }
  }



  void typing_function()async{
    var my_email=widget.my_email.toString();
    my_email=my_email.replaceAll('.com', '');
    await Firestore.instance.collection('chat').where("chat_emails",arrayContains:widget.my_email ).getDocuments().then((value) {
      var docs=value.documents;
      for(int i=0;i<docs.length;i++){
        // print(widget.user_email);

        if(docs[i]["chat_emails"].contains(widget.user_email)){
          //print(docs[i].documentID);
          Firestore.instance.collection("chat").document(docs[i].documentID).updateData({
            my_email:false,
          } );
        }



      }

    });}
  void offline(bool active)async{
    await Firestore.instance.collection('users').document( widget.my_email).updateData({
      "active":active,
    });
  }

  @override
  void initState() {
offline(true);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    typing_function();
    super.dispose();
  }




Widget add_seen(doc_chat,doc_id){
    FirebaseFirestore.instance.collection('chat').document(doc_chat).collection("msg").document(doc_id).updateData({
    "seen":true,
  });
    return Container();


}







  _buildMessage(message,creeate_at,isLiked, bool isMe,doc_id,doc_chat,seen) {
    final Container msg = Container(child:Stack(
        children: [
        Container(margin: isMe ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: MediaQuery.of(context).size.width * 0.25,)
          : EdgeInsets.only(top: 8.0, bottom: 8.0,),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(color: isMe ? Theme.of(context).accentColor : Color(0xFFFFEFEE),
        borderRadius: isMe ? BorderRadius.only(topLeft: Radius.circular(15.0), bottomLeft: Radius.circular(15.0),)
            : BorderRadius.only(topRight: Radius.circular(15.0), bottomRight: Radius.circular(15.0),),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(creeate_at, style: TextStyle(color: Colors.blueGrey, fontSize: 16.0, fontWeight: FontWeight.w600,),),
          SizedBox(height: 8.0),
          Text(message, style: TextStyle(color: Colors.blueGrey, fontSize: 16.0, fontWeight: FontWeight.w600,),),
        ],
      ),
    ),


         if(isMe==true) isLiked ? Positioned(right:(MediaQuery.of(context).size.width * 0.72) ,
             top: 5,
             child: Icon(Icons.favorite,color: Theme.of(context).primaryColor,size: 22,)):Container(),



          if(isMe==true) seen ? Positioned(right:15 ,
              bottom: 15,
              child: Icon(Icons.check,color: Colors.green,size: 18,)):Container(),
          if(isMe==true) seen ? Positioned(right:21 ,
              bottom: 15,
              child: Icon(Icons.check,color: Colors.green,size: 18,)):Container(),



        ]));
    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
        if(seen==false) add_seen(doc_chat,doc_id),
        IconButton(icon: isLiked ? Icon(Icons.favorite) : Icon(Icons.favorite_border), iconSize: 30.0,
          color: isLiked ? Theme.of(context).primaryColor : Colors.blueGrey,
          onPressed: () async{
            await FirebaseFirestore.instance.collection('chat').document(doc_chat).collection("msg").document(doc_id).updateData({
              "is_liked":!isLiked,
            });
          },
        )
      ],
    );
  }


  /*
@override
  void initState() {
  fetch_doc_id_chat();
  super.initState();
  }
  String documentID;
  void fetch_doc_id_chat()async{
    var documentID;
    var doc_ref =await Firestore.instance.collection('chat').where("chat_emails",arrayContains: widget.my_email).getDocuments();
   await doc_ref.documents.forEach((result) {
      setState(() {
        documentID=result.documentID;

      });
    });
   // print(documentID);
  }

   */
  @override
  Widget build(BuildContext context) {
return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: StreamBuilder(stream:Firestore.instance.collection('users').document(widget.user_email).snapshots() ,
          builder: (context, usersnapshot) {
            if (usersnapshot.connectionState == ConnectionState.waiting) {
              return Container();
            } else {
              var user_data = usersnapshot.data;
              return Row(mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Stack(children: [
                    CircleAvatar(radius: 25.0,
                      backgroundImage: NetworkImage(
                          user_data["user_image"]), //AssetImage("assets/images/steven.jpg"),
                    ),

                    if(user_data["active"] == true) Positioned(
                      bottom: 0, right: 9,
                      child: Container(width: 10, height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.green,
                          border: Border.all(color: Colors.white,
                            width: 1,),),
                      ),)

                  ],
                  ),
                  SizedBox(width: 10.0),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(user_data["user_name"], style: TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold,),),
                      SizedBox(height: 5.0),


                      type_a_message(widget.my_email,widget.user_email),







                    ],
                  ),


                ],
              );



          }

          }
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: WillPopScope(onWillPop: (){
        if(isEmojiVisible){
          setState(() {
            isEmojiVisible=false;
          });
        }else{
          Navigator.pop(context);
        }
        return Future.value(false);
      },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    child: FutureBuilder(future:Future.value(Firestore.instance.collection('chat').where("chat_emails",arrayContains:widget.my_email ).getDocuments())
                      ,builder: (context, doc_chat_snapshot) {
                      if(doc_chat_snapshot.connectionState==ConnectionState.waiting){
                            return Center(child: Container());

                          }
                      //.documents[0].documentID;

                      doc_chat_snapshot.data.documents.forEach((value) {
                        if (value["chat_emails"].contains(widget.user_email)) {
                          doc_chat=value.documentID;
                        }
                        //print(doc_chat);
                      });

                      //print(doc_chat);
                      return  StreamBuilder(
                        stream:Firestore.instance.collection("chat").document(doc_chat).collection('msg').orderBy('creeate_at',descending:true ).snapshots(),

                        builder: (context, chatsnapshot) {

                          if(chatsnapshot.connectionState==ConnectionState.waiting){
                            return Center(child: Container());

                          }
                          var chat=chatsnapshot.data.documents;
                          return ListView.builder(
                            reverse: true,
                            padding: EdgeInsets.only(top: 15.0),
                            itemCount: chat.length,
                            itemBuilder: (BuildContext context, int index) {
                              //final Message message = messages[index];
                               bool isMe = chat[index]["send by"]== widget.my_email;
                               //print(chat[0]["creeate_at"].toString()+chat[0]["is_liked"]+isMe);
                              var create_at=DateFormat('HH:mm a').format(chat[index]["creeate_at"].toDate());

                               return _buildMessage(
                                  chat[index]["msg"],
                                  create_at.toString(),
                                  chat[index]["is_liked"],
                                   isMe,
                                 chat[index].documentID,
                                 doc_chat,
                                 chat[index]["seen"]

                               );
                            },
                          );
                        }
                      );

                    },
                    ),
                  ),
                ),
              ),



              input_chat(widget.my_email,widget.user_email,setEmjiVisible,isEmojiVisible),



            ],
          ),
        ),
      ),
    );
  }
}
