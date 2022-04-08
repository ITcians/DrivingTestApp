import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:driving_license_test/controllers/categories.dart';
import 'package:driving_license_test/controllers/home_control.dart';
import 'package:driving_license_test/views/home/hamburger.dart';
import 'package:driving_license_test/views/learning/learning.dart';
import 'package:driving_license_test/views/progress/progress.dart';
import 'package:driving_license_test/views/quiz/quiz_selection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class HomeView extends StatelessWidget {
  final List<Widget> screens = [
    QuizSelection(),
    LearnView(),
    ProgressView(),
    Text('More')
  ];
  final controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DMV Test"),
      ),
      drawer: Hamburger(),
      body: Obx(
        () => Container(
          padding: EdgeInsets.all(7),
          child: screens[controller.index.value],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        onTap: (index) async => controller.changePage(index),
        items: [
          Icon(FontAwesomeIcons.questionCircle),
          Icon(FontAwesomeIcons.graduationCap),
          Icon(FontAwesomeIcons.projectDiagram),
          Icon(FontAwesomeIcons.modx),
        ],
      ),
    );
  }
}
