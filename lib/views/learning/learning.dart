import 'package:driving_license_test/views/home/detail_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LearnView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              SizedBox(
                height: 16,
              ),
              Text(
                "Want to pass the real test with first attempt?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 16,
              ),
              Card(
                child: ListTile(
                  title: Text("Purchase cheatsheet of 20 tests of 3 states."),
                  subtitle: Text("Some description here ..."),
                  trailing: TextButton(
                    onPressed: () async {},
                    child: Text("\$0.99"),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("Purchase cheatsheet of 80 tests of 3 states."),
                  subtitle: Text("Some description here ..."),
                  trailing: TextButton(
                    onPressed: () async {},
                    child: Text("\$2.99"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
