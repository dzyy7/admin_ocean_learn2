import 'package:admin_ocean_learn2/pages/login/login_controller.dart';
import 'package:admin_ocean_learn2/utils/user_storage.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  RxString name = ''.obs;
  RxString email = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }
  
  void loadUserData() {
    // Try to get from persistent storage first
    String? userName = UserStorage.getName();
    String? userEmail = UserStorage.getEmail();
    
    // If not found in persistent storage, try to get from session memory
    if (userName == null || userName.isEmpty) {
      userName = LoginController.getSessionName();
    }
    
    if (userEmail == null || userEmail.isEmpty) {
      userEmail = LoginController.getSessionEmail();
    }
    
    // Set the values with fallbacks
    name.value = userName ?? 'User';
    email.value = userEmail ?? 'user@example.com';
  }
  
  void changeMenu(int index) {
    selectedIndex.value = index;
  }
  
  RxInt selectedIndex = 0.obs;
}