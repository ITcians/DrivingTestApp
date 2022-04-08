import 'package:driving_license_test/controllers/quiz_abstract.dart';
import 'package:driving_license_test/models/question_model.dart';
import 'package:driving_license_test/models/test_model.dart';
import 'package:driving_license_test/views/quiz/mcqs.dart';
import 'package:driving_license_test/views/test/results.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizController extends GetxController {
  RxList<QuestionModel> questions = <QuestionModel>[].obs;
  RxList<Widget> qView = <Widget>[].obs;
  QuizCallbacks callbacks;
  Rx<PageController> pageController = PageController().obs;
  RxInt rightAnswers = 0.obs;
  RxList<dynamic> attempts = <dynamic>[].obs;
  Rx<TestModel> testModel = TestModel().obs;

  QuizController(this.callbacks);

  void addAttempt(option) async {
    attempts.add(option);
    print("ATTEMPT ADDED $option");
    update();
  }

  void createQuestions() async {
    TestModel test = Get.find();
    testModel.value = test;

    test.questions.forEach((element) {
      questions.add(QuestionModel.fromJson(element));
      createWidget(QuestionModel.fromJson(element));
    });
    update();
  }

  void createWidget(QuestionModel q) async {
    qView.add(QuestionView(q, this.callbacks));
    update();
  }

  void addRightAnswer() async {
    rightAnswers.value = rightAnswers.value+1;
    print("RIGHT ANSWER! ${rightAnswers.value}");
    update();
  }

  void nextPage() async {
    if (pageController.value.page + 1 == questions.length) {

      //test over
      Get.put(testModel.value);
      print(rightAnswers.value);
      print(attempts.toString());
      Get.put(rightAnswers.value, tag: 'score');
      Get.to(ResultView(rightAnswers.value, attempts, questions));
      return;
    }
    pageController.value.nextPage(
        duration: Duration(milliseconds: 690), curve: Curves.bounceIn);

    update();
  }
}
