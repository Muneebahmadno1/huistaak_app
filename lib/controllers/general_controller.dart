import 'package:get/get.dart';

class GeneralController extends GetxController {
  RxInt _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  void onBottomBarTapped(int index) {
    _currentIndex.value = index;
  }
}
