import 'package:driving_license_test/controllers/test_controller.dart';
import 'package:driving_license_test/models/question_model.dart';
import 'package:driving_license_test/models/test_model.dart';
import 'package:driving_license_test/views/home/home.dart';
import 'package:driving_license_test/views/quiz/expaination.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ResultView extends StatelessWidget {
  final score;
  final List<dynamic> attempts;
  final List<QuestionModel> questions;
  ResultView(this.score, this.attempts, this.questions);

  final testController = TestController();

  @override
  Widget build(BuildContext context) {
    final TestModel testModel = Get.find();
    testController.publishRecord(questions, attempts, score, testModel);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Score",
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 16,
              ),
              Text(
                "Test Result For",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
              Text(
                "${testModel.title} of ${testModel.category}",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Your Score is $score / ${testModel.questions.length}",
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 16,
              ),
              if (testController.isPassed(
                  testModel, int.parse(this.score.toString())))
                Column(
                  children: [
                    Icon(FontAwesomeIcons.solidSmile,
                        color: Colors.green, size: 60),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "You made it!",
                      style: TextStyle(color: Colors.green, fontSize: 30),
                    ),
                  ],
                ),
              if (!testController.isPassed(
                  testModel, int.parse(this.score.toString())))
                Column(
                  children: [
                    Icon(FontAwesomeIcons.sadCry, color: Colors.red, size: 60),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "You have failed!",
                      style: TextStyle(color: Colors.red, fontSize: 30),
                    ),
                  ],
                ),
              Divider(),
              FloatingActionButton.extended(
                  heroTag: "explianation",
                  onPressed: () async =>
                      Get.to(ExplanView(questions, attempts)),
                  label: Text("View Explianations")),
              SizedBox(
                height: 16,
              ),
              TextButton(
                  onPressed: () async {},
                  child: Text(
                    "Want to pass the real test? Purchase premium today, 98% success rate",
                    textAlign: TextAlign.center,
                  )),
              SizedBox(
                height: 16,
              ),
              FloatingActionButton.extended(
                  heroTag: "back",
                  onPressed: () async => Get.offAll(HomeView()),
                  label: Text("Back to tests"))
            ],
          ),
        ),
      ),
    );
  }
}
