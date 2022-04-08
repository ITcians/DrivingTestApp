import 'package:driving_license_test/controllers/quiz_control.dart';
import 'package:driving_license_test/models/question_model.dart';
import 'package:driving_license_test/controllers/quiz_abstract.dart';
import 'package:driving_license_test/views/resource/pop_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class QuestionView extends StatelessWidget {
  final QuestionModel question;
  final QuizCallbacks selection;

  QuestionView(this.question, this.selection);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          if (question.image != null)
            Image.network(
              question.image,
              width: Get.width,
            ),
          Text(
            "Q: " + question.question.toString(),
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Divider(),
          SizedBox(
            height: Get.height * .5,
            width: Get.width,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return RadioListTile(
                    value: index,
                    groupValue: question.question,
                    title: Text(question.options[index].toString()),
                    selectedTileColor: Colors.blue,
                    onChanged: (val) {
                      QuizController quiz = Get.find();
                      print(
                          "ANSER IS $val of ${question.question} correct is ${question.correct}");
                      quiz.addAttempt(index);
                      if (index == question.correct) {
                        //right answer
                        PopUp().celebirate(
                          context,
                          Icon(
                            FontAwesomeIcons.smileWink,
                            color: Colors.green,
                            size: 60,
                          ),
                          Text("You answer is right!"),
                        );
                        quiz.addRightAnswer();
                        selection.onAnswerSelect(true);
                      } else {
                        PopUp().celebirate(
                          context,
                          Icon(
                            FontAwesomeIcons.sadTear,
                            color: Colors.red,
                            size: 60,
                          ),
                          SizedBox(
                            height: Get.height * .3,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 7,
                                ),
                                Text("You answer is wrong!"),
                                SizedBox(
                                  height: 16,
                                ),
                                Flexible(
                                  child: Text(question.explanation.toString()),
                                  fit: FlexFit.loose,
                                ),
                              ],
                            ),
                          ),
                        );
                        selection.onAnswerSelect(false);
                      }
                    });
              },
              itemCount: question.options.length,
            ),
          ),
        ],
      ),
    );
  }

  void validateAns(String ans) async {
    if (ans == question.correct)
      selection.onAnswerSelect(true);
    else
      selection.onAnswerSelect(false);
  }
}
