import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final String title;
  final String details;
  final IconData iconData;
  final action;

  DetailCard(this.title, this.details, this.iconData, this.action);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Icon(iconData,size: 120,color: Colors.blue,),
              SizedBox(height: 16,),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              Text(details)
            ],
          )
        ],
      ),
    );
  }
}
