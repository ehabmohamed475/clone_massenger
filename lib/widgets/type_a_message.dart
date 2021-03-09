import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class type_a_message extends StatelessWidget {
  var my_email,user_email;


  type_a_message(this.my_email, this.user_email);
  var doc_chat;
  bool typing;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:Firestore.instance.collection('chat').where("chat_emails",arrayContains:my_email ).snapshots(),
        builder: (context, doc_chat_snapshot) {
      if(doc_chat_snapshot.connectionState==ConnectionState.waiting){
        return  Container();

      }

      doc_chat_snapshot.data.documents.forEach((value) {
        if (value["chat_emails"].contains(user_email)) {
         doc_chat=value.documentID;
         var user_email_sup=user_email.replaceAll('.com', '');
         typing=value[user_email_sup];
        }
      });

            return typing == true ?Container(
              child: Text("type a message...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ):Container(child: StreamBuilder(
                stream: Firestore.instance.collection("users").document(user_email).snapshots(),
                builder: (context, userssnapshot) {
                  if (userssnapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else {
                    var users = userssnapshot.data;


                    return Text(users["active"] == true ? "Active" : "Offline",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    );
                  }
                })

          );


      }
    );
  }
}
