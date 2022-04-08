import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MoreView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("MORE DETAILS"),
          Text("Ads"),
        ],
      ),
    ),
    );
  }
}
