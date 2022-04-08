import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt index = 0.obs;

  void changePage(index) async {
    this.index.value = index;
    update();
  }

  
}
