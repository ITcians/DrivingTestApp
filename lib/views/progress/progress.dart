import 'package:driving_license_test/controllers/test_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgressView extends StatelessWidget {
  final testController = TestController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          width: Get.width,
          padding: const EdgeInsets.all(16),
          child: FutureBuilder(
            builder: (context, snap) {
              print(snap.hasData);
              
              if (snap.hasData) {
                return ListView(
                  children: snap.data,
                );
              } else
                return Text("No data found!");
            },
            future: testController.loadRecords(),
          )),
    );
  }
}
