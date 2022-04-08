import 'package:driving_license_test/models/question_model.dart';
import 'package:driving_license_test/models/test_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExplanView extends StatelessWidget {
  final List<QuestionModel> questions;
  final List<dynamic> attempts;
  ExplanView(this.questions, this.attempts);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explainations"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
            itemBuilder: (context, index) {
              QuestionModel q = questions[index];
              return Card(
                child: ListTile(
                  title: Text(
                    "${q.question}",
                  ),
                  subtitle: Text("${q.explanation}"),
                  leading: Icon(
                    attempts[index] == questions[index].correct
                        ? Icons.done
                        : Icons.close,
                    color: attempts[index] == questions[index].correct
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              );
            },
            itemCount: questions.length),
      ),
    );
  }
}
