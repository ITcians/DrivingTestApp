
import 'package:driving_license_test/views/models/version.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Hamburger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: Get.width / 2,
      color: Colors.white,
      child: ListView(
        children: [
          Container(
            height: 150,
            color: Colors.blue,
            child: Center(
              child: ListTile(
                title: Text(
                  "USA ACE",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                subtitle: Text(
                  "",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
          
          ListTile(
            leading: Icon(Icons.rate_review),
            title: Text("Rate App"),
            // onTap: () async => Get.offAll(WelcomeView()),
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text("FAQ"),
            // onTap: () async => Get.offAll(WelcomeView()),
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text("Share View"),
            // onTap: () async => Get.offAll(WelcomeView()),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.addressBook),
            title: Text("About Us"),
            // onTap: () async => Get.offAll(WelcomeView()),
          ),
        ],
      ),
    );
  }
}
