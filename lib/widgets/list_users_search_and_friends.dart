import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:massenger/screens/chat_screen.dart';

class list_users_search_and_friends extends StatelessWidget {
  bool friend_or_not,active;
  var user_image,user_name,email,my_email;
  list_users_search_and_friends(this.friend_or_not,this.active,this.user_image,this.user_name,this.email,this.my_email);
  @override
  Widget build(BuildContext context) {

            return Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0,left: 1),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration: BoxDecoration(
                color:  friend_or_not== false ? Color(0xFFFFEFEE) : Colors.white,
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
                        CircleAvatar(
                          radius: 35.0,
                          backgroundImage: NetworkImage(user_image),//AssetImage("assets/images/steven.jpg"),
                        ),

                       if(active==true) Positioned(bottom: 0,right: 9,
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
                          Text(user_name,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.41,
                            child: Text(email,
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),



                      Column(
                        children: <Widget>[
                          SizedBox(height: 5.0),
                          Container(
                            width: 70.0,
                            height: 35.0,
                            decoration: BoxDecoration(
                              color: Colors.red,//Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            alignment: Alignment.center,
                            child: FlatButton(onPressed: ()async{
                              if(friend_or_not==false){
                                var unique=DateTime.now().toString();
                                await FirebaseFirestore.instance.collection('chat').document(unique).collection("msg").document().setData({
                                  'send by':my_email,
                                  'creeate_at':DateTime.now(),
                                  'msg':"Hi, my friend, I added you to Messenger",
                                  'seen':false,
                                  "is_liked":false,
                                });

                              var  my_email_sup=my_email.replaceAll('.com', '');
                                var  email_sup=email.replaceAll('.com', '');

                                await FirebaseFirestore.instance.collection('chat').document(unique).setData({
                                  'chat_emails':[my_email,email],
                                  'creeate_at':DateTime.now(),
                                  my_email_sup:false,
                                  email_sup:false,

                                });
                                await FirebaseFirestore.instance.collection('users').document(my_email).updateData({
                                  'friends':FieldValue.arrayUnion([email]),
                                });
                                await FirebaseFirestore.instance.collection('users').document(email).updateData({
                                  'friends':FieldValue.arrayUnion([my_email]),
                                });
                                Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(
                                  user_email: email,my_email:my_email
                                ),
                                ),
                                );
                              }else{

                                Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(
                                  user_email: email,my_email:my_email
                                ),
                                ),
                                );

                              }

                            },
                              child: Text(
                                friend_or_not==false ?'ADD':'OPEN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),

                ],
              ),
            );









  }
}
