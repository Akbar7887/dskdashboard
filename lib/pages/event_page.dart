
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventPage extends StatelessWidget{


  @override
  Widget build(BuildContext context) {

    return ListView(children: [

      Container(
        height: 50,
        alignment: Alignment.center,
        child: Text(
          "События",
          style: TextStyle(fontSize: 20),
        ),
      ),
      Divider(),

    ],);
  }


}