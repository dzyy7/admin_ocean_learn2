import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardController extends GetxController {
  RxString name = ''.obs;
  RxString email = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    name.value = prefs.getString('name') ?? 'User';
    email.value = prefs.getString('email') ?? 'user@example.com';
  }

  void changeMenu(int index) {
    selectedIndex.value = index;
  }

  RxInt selectedIndex = 0.obs;
}
