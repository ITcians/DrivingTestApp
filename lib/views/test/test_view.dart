import 'package:driving_license_test/controllers/test_controller.dart';
import 'package:driving_license_test/models/category_model.dart';
import 'package:driving_license_test/models/test_model.dart';
import 'package:driving_license_test/views/quiz/quiz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TestView extends StatelessWidget {
  TestView();

  final testControl = TestController();

  @override
  Widget build(BuildContext context) {
    final CategoryModel category = Get.find();
    testControl.loadTests(category);
    return Scaffold(
      appBar: AppBar(
        title: Text("Tests of ${category.category}"),
      ),
      body: Container(
          padding: EdgeInsets.all(16),
          child: Obx(
            () => testControl.busy.value
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      TestModel test = testControl.tests[index];
                      return Card(
                          child: ListTile(
                        title: Text(test.title.toString()),
                        trailing: Icon(
                          Icons.navigate_next,
                          color: Colors.blue,
                        ),
                        subtitle: Text(
                            "Passing marks ${test.passingMarks} out of ${test.questions.length}"),
                        onTap: () async {
                          //QuestionModel q=test.questions[0];

                          Get.put(test);
                          Get.to(QuizScreen());
                        },
                      ));
                    },
                    itemCount: testControl.tests.length,
                  ),
          )),
    );
  }
}
