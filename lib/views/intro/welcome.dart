import 'package:driving_license_test/controllers/welcome.dart';
import 'package:driving_license_test/views/home/home.dart';
import 'package:driving_license_test/views/models/version.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class WelcomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "DMV ACE",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [usaView()],
        ),
      ),
    );
  }

  Widget usaView() {
    WelcomeController c = WelcomeController();
    c.changeVersion("USA");
    return choice(c);
  }

  Widget choice(WelcomeController c) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Tests are based on something which is something- '
            'to come up with something to get something with a greater reward of something',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 16,
          ),
          InkWell(
            onTap: () async {
              c.changeType("Driver");
              c.saveChanges();
              VersionModel version = c.loadVersion();
              Get.put(version);
              Get.offAll(HomeView());
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      FontAwesomeIcons.key,
                      color: Colors.blue,
                      size: 50,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Driver Test",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          InkWell(
            onTap: () async {
              c.changeType("Learner");
              c.saveChanges();
              Get.put(c.loadVersion());
              Get.offAll(HomeView());
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      FontAwesomeIcons.graduationCap,
                      color: Colors.blue,
                      size: 50,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Learner Test",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text('ads here'),
        ],
      );
}
