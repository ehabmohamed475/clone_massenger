import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class search_to_add_to_massenger extends StatefulWidget {
  Function change_key_search;
  search_to_add_to_massenger(this.change_key_search);
  @override
  _search_to_add_to_massengerState createState() => _search_to_add_to_massengerState();
}

class _search_to_add_to_massengerState extends State<search_to_add_to_massenger> {
  var search_controller=TextEditingController();

  
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment:MainAxisAlignment.center ,
      children: [
        Container(width: 300,
          child: TextField(//expands:true,minLines: 1,maxLines: 5,
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),
          cursorColor: Colors.grey,
          textCapitalization: TextCapitalization.sentences,
            controller:search_controller,
            onSubmitted:(value) {
            var controler=search_controller.text.trim();
widget.change_key_search(controler);
            },
            decoration: InputDecoration(labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),focusColor: Colors.grey,hoverColor: Colors.grey,prefixIcon:Icon(Icons.search,color: Colors.grey,),
              focusedBorder:OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey,width: 2),
                borderRadius: BorderRadius.circular(30.0),
              ),
              border: OutlineInputBorder( borderSide: BorderSide(color: Colors.grey),borderRadius: BorderRadius.circular(30),),
              hintText: 'Search by E-Mail or User name ',
            ),
          ),
        ),
      ],
    );
  }
}
