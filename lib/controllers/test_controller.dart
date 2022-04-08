import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driving_license_test/models/question_model.dart';
import 'package:driving_license_test/controllers/quiz_abstract.dart';
import 'package:driving_license_test/models/category_model.dart';
import 'package:driving_license_test/models/record.dart';
import 'package:driving_license_test/models/test_model.dart';
import 'package:driving_license_test/views/quiz/mcqs.dart';
import 'package:driving_license_test/views/test/results.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String testCollection = "Tests";
const String recordCollection = "Records";

class TestController extends GetxController {
  RxList<TestModel> tests = <TestModel>[].obs;
  RxList<Widget> questions = <Widget>[].obs;
  QuizCallbacks callbacks;
  Rx<PageController> pageController = PageController().obs;
  RxInt rightAnswer = 0.obs;
  RxBool busy = false.obs;

  void addRightAnswer() async {
    rightAnswer.value = rightAnswer.value++;
    update();
  }

  TestController({this.callbacks});

  void loadTests(CategoryModel category) async {
    busy.toggle();
    var data = await FirebaseFirestore.instance
        .collection(testCollection)
        .where("category", isEqualTo: category.category)
        .where('version', isEqualTo: category.version)
        .get();

    tests.clear();
    data.docs.forEach((element) {
      TestModel test = TestModel.fromJson(element.data());
      test.id = element.id;
      tests.add(test);
    });
    busy.toggle();
    update();
  }

  void publishRecord(List<QuestionModel> questions, List<dynamic> attempts,
      score, TestModel test) async {
    final prf = await SharedPreferences.getInstance();
    String data = prf.getString(recordCollection);
    List<dynamic> list = [];
    if (data != null) {
      list = jsonDecode(data);
    }
    RecordModel record = RecordModel(
        attempts: attempts.length,
        questions: questions.length,
        score: score,
        version: test.version,
        testCategory: test.category,
        testTitle: test.title);
    list.add(record);
    prf.setString(recordCollection, jsonEncode(list));
  }

  Future<List<Widget>> loadRecords() async {
    final prf = await SharedPreferences.getInstance();
    String data = prf.getString(recordCollection);
    List<dynamic> list = [];
    if (data != null) {
      list = jsonDecode(data);
    }

    List<Widget> res = [];
    if (list.isEmpty) {
      res.add(Text("No record found!"));
      return res;
    }

    print("LOOP");
    list.forEach((element) {
      RecordModel record = RecordModel.fromJson(element);
      if (record.passingMarks == null) record.passingMarks = 20;
      res.add(
        Card(
          child: ListTile(
            title: Text(record.testTitle + " of " + record.testCategory),
            leading: Text(
              "${record.score}/${record.questions}",
              textAlign: TextAlign.center,
            ),
            subtitle: Text("Passing marks ${record.passingMarks}"),
            trailing: Icon(
              record.score >= record.passingMarks
                  ? FontAwesomeIcons.smileBeam
                  : FontAwesomeIcons.sadTear,
              color: record.score >= record.passingMarks
                  ? Colors.green
                  : Colors.red,
              size: 50,
            ),
          ),
        ),
      );
    });

    print(res.length);
    return res;
  }

  bool isPassed(TestModel test, int score) {
    print("${test.passingMarks}");
    print("$score");
    print("Result ${score >= int.tryParse(test.passingMarks)}");
    if (score == 0) return false;

    return score >= int.tryParse(test.passingMarks);
  }

  void loadQuestions(TestModel testModel) async {
    testModel.questions.forEach((element) {
      addQuestionToView(element as QuestionModel);
    });
    update();
  }

  void addQuestionToView(QuestionModel questionModel) async {
    questions.add(QuestionView(questionModel, callbacks));
    update();
  }

  void addTest(TestModel tes) async {
    tests.add(tes);
    update();
  }

  void loadCarTests() async {}

  void loadBikeTests() async {
    tests.clear();
    TestModel test = TestModel(
        version: "USA", title: "Test 1", category: "Bike", questions: []);
    List<QuestionModel> questions = [];
    bikeQuestions.forEach((element) {
      print(element);
      questions.add(QuestionModel.fromJson(element));
    });
    test.questions = questions;
    tests.add(test);
    TestModel t2 = TestModel();
    t2.version = "USA";
    t2.category = "Bike";
    t2.title = "Test 2";
    questions.clear();
    bikeTest2.forEach((element) {
      questions.add(QuestionModel.fromJson(element));
    });
    tests.add(t2);
    update();
  }
}

List<dynamic> bikeQuestions = [
  {
    "q": "When riding in a group, inexperienced riders should be placed:",
    "options": {
      "a": "behind the leader",
      "b": "in front of the leader",
      "c": "in the middle of the group",
      "d": "in front of the last rider."
    },
    "correct": "a"
  },
  {
    "q": "The safest formation when riding in a group is:",
    "options": {
      "a": "the single-file formation",
      "b": "the staggered formation",
      "c": "in pairs",
      "d": "the L-formation"
    },
    "correct": "b"
  },
  {
    "q": "Always use _____________ to stop.",
    "options": {
      "a": "both brakes at the same time",
      "b": "swerving",
      "c": "the rear brake only",
      "d": "the front brake only"
    },
    "correct": "c"
  },
  {
    "q": "If you must go over an obstacle:",
    "options": {
      "a": "increase your speed before contact",
      "b": "approach it as close to a 90° angle as possible",
      "c": "keep your elbows locked",
      "d": "with your feet skimming the ground"
    },
    "correct": "c"
  },
  {
    "q":
        "Other drivers are most likely to try and share the lane with a motorcycle when:",
    "options": {
      "a": "they want to pass the motorcycle",
      "b": "the motorcycle rider is preparing to turn at an intersection",
      "c": "traffic is heavy",
      "d": "All of the above"
    },
    "correct": "c"
  },
  {
    "q": "You should operate the engine cut-off switch:",
    "options": {
      "a":
          "if your throttle is stuck and twisting it back and forth does not free it.",
      "b": "as soon as your motorcycle starts wobbling",
      "c": "if your rear tire goes flat.",
      "d": "if the front tire goes flat"
    },
    "correct": "d"
  },
  {
    "q": "Wobbling can be caused by:",
    "options": {
      "a": "improperly loading your bike",
      "b": "lower tire pressure",
      "c": "defective wheel alignment",
      "d": "All the other answers are correct."
    },
    "correct": "a"
  },
  {
    "q": "When parking at the roadside, park:",
    "options": {
      "a": "with your front wheel touching the curb",
      "b": "parallel to the curb",
      "c": "on the curb",
      "d": "with your rear wheel touching the curb"
    },
    "correct": "a"
  },
  {
    "q":
        "Riders in a staggered formation should move into a single-file formation when:",
    "options": {
      "a": "All the other answers are correct",
      "b": "riding at nigh",
      "c": "riding in the left position",
      "d": "riding curves"
    },
    "correct": "b"
  },
  {
    "q":
        "Before riding, position yourself comfortably and sit far enough forward so that your arms are",
    "options": {
      "a": "bent at a 120-degree angle",
      "b": "straight",
      "c": "slightly bent when you hold the handgrips",
      "d": "stretched out"
    },
    "correct": "c"
  },
  {
    "q":
        "When you need to cross rail tracks that are parallel to you, how should you cross them?",
    "options": {
      "a": "Edge across the tracks",
      "b": "At an angle of at least 45 degrees",
      "c": "Never cross rail tracks parallel to your lane",
      "d": "At an angle of exactly 90 degrees"
    },
    "correct": "d"
  },
  {
    "q": "Before each motorcycle ride, remember to adjust:",
    "options": {
      "a": "the passenger footrests",
      "b": "your mirrors ",
      "c": "your foot pegs",
      "d": "your saddlebags"
    },
    "correct": "b"
  },
  {
    "q": "You should adjust your side mirrors:",
    "options": {
      "a": "while riding your motorcycle",
      "b": "before mounting your motorcycle",
      "c": "at a designated service center",
      "d": "before starting your motorcycle"
    },
    "correct": "d"
  },
  {
    "q": "The front brake supplies __________ of the potential stopping power",
    "options": {
      "a": "all",
      "b": "about 40%",
      "c": "about 70%",
      "d": "ride in the left lane position."
    },
    "correct": "c"
  },
  {
    "q":
        "When a driver on an entrance ramp is merging into your lane, you should:",
    "options": {
      "a": "increase your speed",
      "b": "change to another lane if one is open",
      "c": "slow down",
      "d": "sound your horn"
    },
    "correct": "c"
  },
  {
    "q": "__________ provides the best eye and face protection:",
    "options": {
      "a": "Certified sunglasses",
      "b": "A face shield",
      "c": "A windshield",
      "d": "Protective apparel"
    },
    "correct": "a"
  },
  {
    "q": "Which of the following should be checked before each ride?",
    "options": {
      "a": "Tires",
      "b": "Brakes",
      "c": "Clutch and throttle",
      "d": "All of the above"
    },
    "correct": "d"
  },
  {
    "q":
        "When parking in a parallel parking space next to a curb, you should park at a ______ angle.",
    "options": {
      "a": "25-degree",
      "b": "90-degree",
      "c": "30-degree",
      "d": "45-degree"
    },
    "correct": "d"
  },
  {
    "q": "You can help keep your balance while riding by:",
    "options": {
      "a": "locking your elbows.",
      "b": "sitting as far back as possible ",
      "c": "keeping your knees against the gas tank",
      "d": "wearing light weight riding gear."
    },
    "correct": "b"
  },
  {
    "q": "To stop quickly, apply:",
    "options": {
      "a": "the rear brake",
      "b": "both brakes at the same time",
      "c": "the front brake",
      "d": "None of the above"
    },
    "correct": "b"
  },
  {
    "q": "Motorcycle passengers must have their own:",
    "options": {
      "a": "helmet",
      "b": "footrests",
      "c": "seat",
      "d": "All of the above"
    },
    "correct": "d"
  },
  {
    "q":
        "When traveling behind a car, ride ______, where the driver is most likely to see you.",
    "options": {
      "a": "in the right part of the lane",
      "b": "in the driver's blind spot",
      "c": "in the left part of the lane",
      "d": "in the center portion of the lane"
    },
    "correct": "a"
  },
  {
    "q": "When riding in a group, inexperienced riders should be placed:",
    "options": {
      "a": "in front of the last rider",
      "b": "in the middle of the group",
      "c": "in front of the leader",
      "d": "behind the leader"
    },
    "correct": "b"
  },
  {
    "q": "You should not ride your motorcycle alongside of cars because:",
    "options": {
      "a": "your bike may skid",
      "b": "the car driver cannot make a turn",
      "c": "you could be in a blind spot ",
      "d": "None of the above"
    },
    "correct": "d"
  },
  {
    "q": "If your motorcycle is not equipped with a windshield:",
    "options": {
      "a": "you can only ride during the day",
      "b": "you must wear safety goggles or a face shield",
      "c": "you do not have to wear eye protection",
      "d": "you are required to wear glasses"
    },
    "correct": "d"
  },
  {
    "q":
        "When passing, ride in the ___________ to increase your line of sight and make you more visible.",
    "options": {
      "a": "right portion of the lane",
      "b": "center portion of the lane",
      "c": "left or right portions",
      "d": "left portion of the lane"
    },
    "correct": "c"
  },
  {
    "q":
        "_______________ is the best way to lessen your chances of being involved in a collision.",
    "options": {
      "a": "Wearing protective clothing",
      "b": "Choosing the right helmet",
      "c": "Using your headlight",
      "d": "Maintaining an adequate space cushion"
    },
    "correct": "c"
  },
  {
    "q": "What is a benefit of riding in the center lane position?",
    "options": {
      "a": "It allows you to go faster",
      "b": "It prevents others from sharing your lane",
      "c": "Your space cushion is maximized",
      "d": "It helps you maintain a constant speed."
    },
    "correct": "d"
  },
  {
    "q":
        "When riding with a passenger you should ride ______ when taking curves.",
    "options": {
      "a": "at normal speed",
      "b": "slower",
      "c": "None of the other answers is correct",
      "d": "faster"
    },
    "correct": "a"
  },
  {
    "q":
        "When changing lanes on a multi-lane road, always remember to check the lane next to you and:",
    "options": {
      "a": "the lane behind you",
      "b": "the rear brake",
      "c": "the lane in front of you",
      "d": "the far lane"
    },
    "correct": "a"
  },
  {
    "q": "What is the safest braking method?",
    "options": {
      "a": "Use the front brake first and then the rear brake",
      "b": "Using only the front brake",
      "c": "Using both brakes at the same time",
      "d": "Using only the rear brake"
    },
    "correct": "b"
  },
  {
    "q": "Which of the following should not be done at night?",
    "options": {
      "a": "Increase your following distance",
      "b": "Increase your speed",
      "c": "Use your high beam",
      "d": "Adjust your lane position when necessary"
    },
    "correct": "c"
  },
  {
    "q": "Before changing lanes on a multi-lane road, you should check",
    "options": {
      "a": "the lane next to you and the far lane",
      "b": "your turn signal",
      "c": "only the far lane",
      "d": "only the lane next to you"
    },
    "correct": "d"
  },
  {
    "q": "Most motorcycle crashes occur:",
    "options": {
      "a": "at lower speeds",
      "b": "on multilane highways",
      "c": "at higher speeds",
      "d": "on hills."
    },
    "correct": "c"
  },
  {
    "q": "When you pass parked cars, which lane position should you ride in?",
    "options": {
      "a": "Left",
      "b": "Right or center",
      "c": "Right",
      "d": "Center"
    },
    "correct": "a"
  },
  {
    "q": "If you accidentally lock the rear brake on a good traction surface:",
    "options": {
      "a": "check the throttle cable",
      "b": "immediately operate the engine cut-off switch",
      "c": "keep it locked until you have stopped",
      "d": "release the rear brake and apply the front brake firmly"
    },
    "correct": "d"
  },
  {
    "q":
        "Why can pulling over to the side of the road be more hazardous to motorcycles than cars?",
    "options": {
      "a": "It is illegal for motorcycles to park on the side of the road",
      "b": "The shoulder is often sandy and may provide less traction",
      "c": "Motorcycles require a curb to park against",
      "d": "It is more difficult for motorcycles to stop quickly"
    },
    "correct": "b"
  },
  {
    "q": "In normal turns, you should:",
    "options": {
      "a": "lean at the same angle as the motorcycle",
      "b": "lean in the opposite direction",
      "c": "remain upright while the motorcycle leans",
      "d": "None of the other answers is correct"
    },
    "correct": "d"
  },
  {
    "q":
        "Riders in a staggered formation should move into a single-file formation when:",
    "options": {
      "a": "riding at night",
      "b": "parking",
      "c": "riding in the left position",
      "d": "riding curves"
    },
    "correct": "a"
  },
  {
    "q": "Before changing lanes:",
    "options": {
      "a": "Look over your shoulder.",
      "b": "Check your mirrors.",
      "c": "Check your blind spots",
      "d": "All of the above"
    },
    "correct": "d"
  },
  {
    "q": "Drivers are most tempted to squeeze by you:",
    "options": {
      "a": "when they want to pass you",
      "b": "in heavy traffic",
      "c": "when you prepare to turn at an intersection",
      "d": "All the other answers are correct."
    },
    "correct": "d"
  },
  {
    "q": "When you carry loads, you should:",
    "options": {
      "a": "fasten the load securely.",
      "b": "All the other answers are correct",
      "c": "stop and check the load every so often",
      "d": "distribute the load evenly"
    },
    "correct": "b"
  },
  {
    "q": "When riding, motorcyclists can increase their safety by:",
    "options": {
      "a": "adjusting their speed",
      "b": "adjusting their lane position",
      "c": "using their horn and signals when appropriate",
      "d": "All of the above"
    },
    "correct": "d"
  },
  {
    "q": "Which of the following is a factor in your blood alcohol level?",
    "options": {
      "a": "The location in which you are drinking",
      "b": "The type of alcohol",
      "c": "The time of day  ",
      "d": "How fast you drink"
    },
    "correct": "b"
  },
  {
    "q": " To increase your visibility to other drivers, you should:",
    "options": {
      "a": "Reduce your following distance",
      "b": "Avoid wearing reflective clothing",
      "c": "Wear reflective clothing",
      "d": "Use your high beam"
    },
    "correct": "a"
  },
  {
    "q": "Why is maintaining a space cushion important?",
    "options": {
      "a": "It gives you space to maneuver",
      "b": "It gives you time to correct your mistakes.",
      "c": "It gives you time to react",
      "d": "All of the above"
    },
    "correct": "d"
  },
  {
    "q": " You should use only the front brake:",
    "options": {
      "a": "on surfaces with poor traction",
      "b": "At all times",
      "c": "when you need to stop quickly.",
      "d": "if your rear tire goes flat"
    },
    "correct": "b"
  },
  {
    "q": "When approaching turns or curves, riders should travel:",
    "options": {
      "a": "in a T-formation",
      "b": "single file",
      "c": "in a staggered formation",
      "d": "in pairs"
    },
    "correct": "d"
  },
  {
    "q": "________ through a turn to stabilize suspension",
    "options": {
      "a": "Decrease your speed",
      "b": "Pull in the clutch",
      "c": "Apply the rear brake",
      "d": "Roll on the throttle"
    },
    "correct": "a"
  },
  {
    "q": "When you are being passed from behind, you should:",
    "options": {
      "a":
          "avoid moving into the portion of the lane farthest from the passing vehicle.",
      "b": "ride on the shoulder of the road",
      "c": "swerve as soon as you can",
      "d": "avoid riding in the center of the lane"
    },
    "correct": "c"
  },
  {
    "q": "Wear ___________ clothing to increase your chances of being seen.",
    "options": {
      "a": "brightly-colored or reflective",
      "b": "comfortable",
      "c": "colorful",
      "d": "leather"
    },
    "correct": "d"
  },
];

List<dynamic> bikeTest2 = [
  {
    "q": "If a tire goes flat while riding, and you must brake, you should:",
    "options": {
      "a": "apply both brakes evenly",
      "b": "gradually apply the brake of the tire that is not flat",
      "c": "rise slightly off the seat.",
      "d": "apply the brake of the flat tire."
    },
    "correct": "a"
  },
  {
    "q": "If the rear tire goes flat while riding:",
    "options": {
      "a": "apply the rear brake first",
      "b": "apply the rear brake firmly.",
      "c": "gradually apply the front brake",
      "d": "apply both brakes at the same time."
    },
    "correct": "d"
  },
  {
    "q": "When you are preparing to slow down, you should check:",
    "options": {
      "a": "the gauges on your motorcycle",
      "b": "to make sure your bike is in neutral before you stop",
      "c": "to your left and right",
      "d": "if there is traffic behind you"
    },
    "correct": "c"
  },
  {
    "q": "Why is maintaining a space cushion important?",
    "options": {
      "a": "Why is maintaining a space cushion important?",
      "b": "It gives you time to react",
      "c": "It gives you time to correct your mistakes",
      "d": "All of the above"
    },
    "correct": "b"
  },
  {
    "q": "The front brake is operated by ________________ .",
    "options": {
      "a": "the left hand lever",
      "b": "the right foot pedal",
      "c": "the right hand lever",
      "d": "the left foot pedal"
    },
    "correct": "a"
  },
  {
    "q": "Motorcycle passengers must have their own:",
    "options": {
      "a": "All the other answers are correct",
      "b": "seat.",
      "c": "footpegs",
      "d": "helmet"
    },
    "correct": "d"
  },
  {
    "q": "The best way to prevent and overcome fatigue while riding is to:",
    "options": {
      "a": "get used to riding more than eight hours a day.",
      "b": "drink coffee at least every two hours",
      "c": "take frequent rest breaks.",
      "d": "avoid using windshields"
    },
    "correct": "c"
  },
  {
    "q": "When parking at the roadside, park:",
    "options": {
      "a": "with your front wheel touching the curb",
      "b": "with your rear wheel touching the curb",
      "c": "parallel to the curb.",
      "d": "on the curb"
    },
    "correct": "b"
  },
  {
    "q":
        "When changing lanes on a multi-lane road, always remember to check the lane next to you and:",
    "options": {
      "a": "the lane behind you.",
      "b": "the rear brake",
      "c": "the far lane.",
      "d": "the lane in front of you"
    },
    "correct": "b"
  },
  {
    "q": "When making turns, ______ before entering the turn.",
    "options": {
      "a": "use the front brake",
      "b": "lean with the motorcycle",
      "c": "avoid changing gears",
      "d": "change gears"
    },
    "correct": "c"
  },
  {
    "q": "You ride safely on slippery surfaces by:",
    "options": {
      "a": "holding in the clutch",
      "b": "maintaining or increasing your speed",
      "c": "avoiding sudden moves.",
      "d": "leaning back."
    },
    "correct": "d"
  },
  {
    "q": "The __________ provides most of your motorcycle's stopping power.",
    "options": {
      "a": "clutch",
      "b": "chain",
      "c": "rear brake",
      "d": "front brake"
    },
    "correct": "a"
  },
  {
    "q": "When riding at night you should:",
    "options": {
      "a": "increase the following distance",
      "b": "decrease your following distance",
      "c": "use your low beam",
      "d": "increase your speed"
    },
    "correct": "a"
  },
  {
    "q":
        "Which of the following roads are the most hazardous for a motorcycle to ride on?",
    "options": {
      "a": "Newly paved roads",
      "b": "Gravel roads",
      "c": "Rural roads",
      "d": "Multilane highways"
    },
    "correct": "a"
  },
  {
    "q": "When you are riding at night, it is best to:",
    "options": {
      "a": "wear a tinted face shield",
      "b": "stay close behind the car in front of you.",
      "c": "not use your headlight",
      "d": "ride slower than you do during the day"
    },
    "correct": "d"
  },
  {
    "q": "To know what is going on behind you:",
    "options": {
      "a": "check your side mirrors frequently",
      "b": "pull off the road and check",
      "c": "decrease your speed and  scan the environment ahead of you",
      "d": "slow down and look around."
    },
    "correct": "d"
  },
  {
    "q":
        "When preparing to enter the roadway from the roadside, you should position your motorcycle:",
    "options": {
      "a": "at an angle",
      "b": "with the rear wheel locked",
      "c": "parallel to the roadside",
      "d": "with your rear wheel touching the curb"
    },
    "correct": "d"
  },
  {
    "q": "If the front tire goes flat while riding:",
    "options": {
      "a":
          "hold the handlegrips firmly, ease off the throttle, and keep a straight course.",
      "b":
          "make sure the tire pressure, shock spring preload and dampers are at the recommended settings for the weight",
      "c": "twist the throttle back and forth several times",
      "d": "avoid using the rear brake"
    },
    "correct": "a"
  },
  {
    "q": "When riding your motorcycle, you should use both brakes:",
    "options": {
      "a": "every time you make turns",
      "b": "at uncontrolled intersections",
      "c": "every time you stop",
      "d": "in emergency situations"
    },
    "correct": "c"
  },
  {
    "q": "Drivers often fail to see a motorcycle headed toward them. Why?",
    "options": {
      "a": "It is hard to judge how far away a motorcycle is",
      "b": "All the other answers are correct.",
      "c": "Motorcycles are hard to see",
      "d": "It is difficult to judge a motorcycle's speed."
    },
    "correct": "a"
  },
  {
    "q": "Surfaces that provide poor traction include:",
    "options": {
      "a": "multi-lane roads",
      "b": "roads in residential areas.",
      "c": "pavement after it starts to rain",
      "d": "exit lanes."
    },
    "correct": "b"
  },
  {
    "q":
        "When you are being passed from behind, which lane position should you ride in?",
    "options": {"a": "Left", "b": "Any", "c": "Center", "d": "Right"},
    "correct": "a"
  },
  {
    "q": "Wearing a face shield while riding:",
    "options": {
      "a": "is prohibited at night",
      "b": "is less effective than wearing glasses",
      "c": "is the best form of face and eye protection",
      "d": "is a legal requirement for riders under the age of 21 "
    },
    "correct": "c"
  },
  {
    "q": "When you check your tires, what are you checking for?",
    "options": {
      "a": "Tire pressure",
      "b": "Tread wear",
      "c": "Cuts and scrapes",
      "d": "All of the above"
    },
    "correct": "d"
  },
  {
    "q": "A motorcycle passenger should:",
    "options": {
      "a": "lean in the opposite direction of the motorcycle",
      "b": "keep both feet on the pegs, even when the motorcycle is stopped.",
      "c": "hang on to the rider's arms.",
      "d": "avoid using footpegs."
    },
    "correct": "a"
  },
  {
    "q": "The best way to carry cargo on a motorcycle is to:",
    "options": {
      "a": "distribute the load evenly",
      "b": "keep the load low.",
      "c": "fasten the load securely with elastic cords",
      "d": "All of the above"
    },
    "correct": "d"
  },
  {
    "q": "When packing your motorcycle, you should pack heavier items:",
    "options": {
      "a": "in the front of the tank bag.",
      "b": "on the sissy bar",
      "c": "in a backpack",
      "d": "on a luggage rack behind you"
    },
    "correct": "c"
  },
  {
    "q": "Motorcycle riders should apply both the front and rear brakes:",
    "options": {
      "a": "every time they stop.",
      "b": "when preparing to turn at an intersection",
      "c": "Never.",
      "d": "only in school zones."
    },
    "correct": "d"
  }
];
