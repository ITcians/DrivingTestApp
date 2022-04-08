import 'package:driving_license_test/views/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Drivers',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          iconTheme: IconThemeData(color: Colors.blue),
          inputDecorationTheme: InputDecorationTheme(
              filled: true,
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))))),
      home: FutureBuilder(
        builder: (context, snapshot) {
          return SplashView();
        },
        future: Firebase.initializeApp(),
      ),
    );
  }
}
