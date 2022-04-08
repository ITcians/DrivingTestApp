import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:driving_license_test/views/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Divider(
              height: 80,
              color: Colors.transparent,
            ),
            Container(
              width: Get.width,
              height: Get.height * .4,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/usa.jpg"))),
            ),
            Divider(
              height: 30,
              color: Colors.transparent,
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: AnimatedTextKit(
                displayFullTextOnTap: false,
                onFinished: () async => Get.offAll(HomeView()),
                repeatForever: false,
                totalRepeatCount: 1,
                animatedTexts: [
                  TypewriterAnimatedText("DMV Ace",
                      textStyle: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 32))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
