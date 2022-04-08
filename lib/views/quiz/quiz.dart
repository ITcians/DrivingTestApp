import 'package:driving_license_test/controllers/quiz_abstract.dart';
import 'package:driving_license_test/controllers/quiz_control.dart';
import 'package:driving_license_test/controllers/test_controller.dart';
import 'package:driving_license_test/models/test_model.dart';
import 'package:driving_license_test/views/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class QuizScreen extends StatelessWidget implements QuizCallbacks {
  QuizScreen();
QuizController quiz;
  @override
  Widget build(BuildContext context) {
    final quizControl = QuizController(this);
    this.quiz=quizControl;

    quizControl.createQuestions();
    Get.put(quizControl);
    quizControl.qView.shuffle();

    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Are you sure to exit?"),
                  content: Text("You will loose progress"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("No")),
                    TextButton(
                        onPressed: () => Get.offAll(HomeView()),
                        child: Text("Yes")),
                  ],
                ));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() => Text(
              "${quizControl.attempts.length}/${quizControl.testModel.value.questions.length}")),
          centerTitle: true,
        ),
        body: Container(
            padding: const EdgeInsets.all(6),
            width: Get.width,
            child: Obx(() => PageView(
                  controller: quizControl.pageController.value,
                  scrollDirection: Axis.vertical,
                  pageSnapping: true,
                  children: quizControl.qView,
                ))),
      ),
    );
  }

  @override
  void onAnswerSelect(bool isRight) {
    
    
    quiz.nextPage();
  }
}
