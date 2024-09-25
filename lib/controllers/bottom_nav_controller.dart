import 'package:flutter/material.dart';
import '../routes/page_index.dart';

class BottomNavController extends GetxController {
  static BottomNavController get to => Get.find<BottomNavController>();
  bool hasFocus = false;
  int selectedIndex = 0;
  List<Widget> screens = [
    HomeScreen(),
    TransactionScreen(),
    const ProfileSettingScreen(),
  ];

  Widget get currentScreen => screens[selectedIndex];

  void changeScreen(int index) {
    selectedIndex = index;
    update();
  }
}
