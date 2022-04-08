import 'package:driving_license_test/controllers/categories.dart';
import 'package:driving_license_test/models/category_model.dart';
import 'package:driving_license_test/views/test/test_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizSelection extends StatelessWidget {
  final cateControl = CategoryController();

  @override
  Widget build(BuildContext context) {
    cateControl.loadCategories();
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Obx(
            () => cateControl.busy.value
                ? Center(child: CircularProgressIndicator())
                : Container(
                    height: Get.height * .7,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        CategoryModel mod = cateControl.categories[index];
                        return Card(
                          child: ListTile(
                            onTap: () async {
                              Get.put(mod);
                              Get.to(TestView());
                            },
                            title: Text(
                              mod.category.toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                            trailing: Icon(
                              Icons.navigate_next,
                              color: Colors.blue,
                            ),
                          ),
                        );
                      },
                      itemCount: cateControl.categories.length,
                    ),
                  ),
          ),
          Text(
            'Ad here',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
