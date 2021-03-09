import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'list_users_search_and_friends.dart';

class prepare_friends extends StatelessWidget {
  String MyEmail;

  prepare_friends(this.MyEmail);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream:Firestore.instance.collection('users').where("friends",arrayContains: MyEmail).snapshots() ,builder: (context, friends_snapshot) {
      if(friends_snapshot.connectionState==ConnectionState.waiting){
        return Expanded(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Container()),
            ],
          ),
        );

      }else {
        var friends_data=friends_snapshot.data.documents;

        if(friends_data.length==0 ){
                  return Expanded(
                    child: Container(color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(child:Text(" There are no friends yet.",style: TextStyle(
                                color: Colors.grey,
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),) ,),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: Container(padding: EdgeInsets.only(top: 10),
                    color: Colors.white,
                    child: ListView.builder(
                      itemCount: friends_data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return list_users_search_and_friends(
                            true,
                            friends_data[index]['active'],
                            friends_data[index]['user_image'],
                            friends_data[index]['user_name'],
                            friends_data[index]['email'],
                            MyEmail

                        );

                      },
                    ),
                  ),
                );

      }

    },
    );
  }
}
