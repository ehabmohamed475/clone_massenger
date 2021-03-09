import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:massenger/widgets/list_users_search_and_friends.dart';

class prepare_users_search_and_friends extends StatelessWidget {
  String key_search,MyEmail;


  //bool email=false;
  prepare_users_search_and_friends(this.key_search,this.MyEmail);
  @override
  Widget build(BuildContext context) {
    if(key_search.isEmpty){
      return Expanded(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(child:Text("Search to discover new friends",style: TextStyle(
              color: Colors.grey,
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),) ,),
          ],
        ),
      );
    }
    return FutureBuilder(future:Future.value(Firestore.instance.collection('users').document(MyEmail).get()) ,builder: (context, usersnapshot) {
    if(usersnapshot.connectionState==ConnectionState.waiting){
    return Expanded(
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: CircularProgressIndicator()),
        ],
      ),
    );

    }else {
    var user_data=usersnapshot.data;
    //var query=
    return StreamBuilder(stream:key_search.contains("@")? Firestore.instance.collection('users').where("email",isEqualTo: key_search ).snapshots()
        :Firestore.instance.collection('users').where("user_name",isEqualTo: key_search).snapshots(),
        builder: (context, search_snapshot) {
          if(search_snapshot.connectionState==ConnectionState.waiting){
            return Expanded(
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                ],
              ),
            );

          }else {
            var people=search_snapshot.data.documents;
            if(people.length==0 || people[0]['email']== MyEmail){
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(child:Text(" No Such users with this name",style: TextStyle(
                      color: Colors.grey,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),) ,),
                  ],
                ),
              );
            }
            return Expanded(
              child: Container(padding: EdgeInsets.only(top: 10),
                color: Colors.white,
                child: ListView.builder(
                  itemCount: people.length,
                  itemBuilder: (BuildContext context, int index) {
if(people[0]['email']== MyEmail){
  return Container();
}
//print(people[index]['email']);
                  bool friend_or_not= user_data['friends'].isEmpty?false:user_data['friends'].contains(people[index]['email']); //.contains(people[index]['email']);
                    return list_users_search_and_friends(
                        friend_or_not,
                      //user_data['friends'].contains(people[index]['email']),
                      people[index]['active'],
                      people[index]['user_image'],
                      people[index]['user_name'],
                      people[index]['email'],
                      MyEmail

                    );

                  },
                ),
              ),
            );
          }


        }

    );

    }

    },
    );
  }
}
/*

 */