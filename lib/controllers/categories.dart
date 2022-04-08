import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driving_license_test/models/category_model.dart';
import 'package:get/get.dart';

const String categoryCollection = "Categories";
const String version = "USA";

class CategoryController extends GetxController {
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  RxBool busy = true.obs;

  void toggleBusy() {
    busy.toggle();
    update();
  }

  void loadCategories() async {
    busy.value = true;
    var data = await FirebaseFirestore.instance
        .collection(categoryCollection)
        .where("version", isEqualTo: version)
        .get();

    categories.clear();
    data.docs.forEach((element) {
      CategoryModel model = CategoryModel.fromJson(element.data());
      categories.add(model);
    });
    toggleBusy();
    update();
  }
}
