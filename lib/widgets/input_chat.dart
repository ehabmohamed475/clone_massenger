import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class input_chat extends StatefulWidget {
  var my_email,user_email;
Function setEmjiVisible;
  bool isEmojiVisible;
  input_chat(this.my_email,this.user_email,this.setEmjiVisible,this.isEmojiVisible);

  @override
  _input_chatState createState() => _input_chatState();
}

class _input_chatState extends State<input_chat> {
  var InputChat_controller=TextEditingController();
 bool check_controller=false,typing=false;
FocusNode focusNode =FocusNode();



@override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(() {
      if(focusNode.hasFocus){
        widget.setEmjiVisible(false);

      }
    });
  }
  
  
  
  
  


 void typing_function()async{
   var my_email=widget.my_email.toString();
   my_email=my_email.replaceAll('.com', '');
  await Firestore.instance.collection('chat').where("chat_emails",arrayContains:widget.my_email ).getDocuments().then((value) {
     var docs=value.documents;
     for(int i=0;i<docs.length;i++){

if(docs[i]["chat_emails"].contains(widget.user_email)){
   Firestore.instance.collection("chat").document(docs[i].documentID).updateData({
         my_email:typing,
       } );
     }



   }

  });



 }


Widget emojiselect(){
  return EmojiPicker( rows: 3, columns: 7,
      onEmojiSelected: (emoji,category){
    setState(() {
      InputChat_controller.text = InputChat_controller.text + emoji.emoji;

    });

  });
}



  @override
  Widget build(BuildContext context) {

      return Container(color: Colors.white,
        child: Column(mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                height: 70.0,
                color: Colors.white,
                child:  Row(
                      children: <Widget>[

                        Expanded(
                          child: Container(height: 55,
                            child: TextField(focusNode:focusNode ,
                              key: ValueKey("msg"),textAlign:TextAlign.left ,expands: true,maxLines: null,minLines: null,
                              style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.black),
                              controller: InputChat_controller,
                              cursorColor: Colors.grey,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                                  focusColor: Colors.grey,hoverColor: Colors.grey,prefixIcon:Icon(Icons.add,color: Colors.grey,),
                                focusedBorder:OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.grey,width: 2),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                border: OutlineInputBorder( borderSide: BorderSide(color: Colors.grey),borderRadius: BorderRadius.circular(30),),
                                hintText: 'Type a message... ',hintStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.grey)
                              ),
                                onChanged: (value){
                              setState(() {
                                var x=value.trim();
                                if(x.length >=1){
                                  check_controller = true;
                                  if(typing==false){
                                    typing=true;
                                    typing_function();

                                  }

                                }else{
                                  check_controller = false;
                                  if(typing==true){
                                    typing=false;
                                    typing_function();

                                  }

                                }

                              });


                                },
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.insert_emoticon,
                          size: 24.5,
                          color: Colors.blue,),
                          onPressed: () {
                            focusNode.unfocus();
                            focusNode.canRequestFocus=false;
                            widget.setEmjiVisible(!widget.isEmojiVisible);

                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.send),
                          iconSize: 27.0,
                          color:Colors.blue,
                          onPressed: check_controller==true?()async{
var doc_chat;

                            await Firestore.instance.collection('chat').where("chat_emails",arrayContains:widget.my_email ).getDocuments().then((value) {
                              var docs=value.documents;
                              for(int i=0;i<docs.length;i++){

                                if(docs[i]["chat_emails"].contains(widget.user_email)){
                                  doc_chat=docs[i].documentID;
                                }
                              }

                            });


                           await Firestore.instance.collection("chat").document(doc_chat).collection('msg').doc().setData({
                              "creeate_at":DateTime.now(),
                             "is_liked":false,
                             "msg":InputChat_controller.text,
                             "seen":false,
                             "send by":widget.my_email,
                           });
                           setState(() {
                             InputChat_controller.clear();
                             check_controller=false;

                           });
                           await Firestore.instance.collection("chat").document(doc_chat).updateData({
                             "creeate_at":DateTime.now(),
                           });
                           setState(() {
                             typing=false;
                             typing_function();
                           });



                        }:null,
                        ),
                      ],
                    ),

              ),
            if(widget.isEmojiVisible)emojiselect(),

          ],
        ),
      );


  }
}
