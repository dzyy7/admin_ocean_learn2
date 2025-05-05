import 'package:get_storage/get_storage.dart';

class UserStorage {
  static final _storage = GetStorage('user_data');
  
  // Keys
  static const String TOKEN_KEY = 'token';
  static const String EMAIL_KEY = 'email';
  static const String NAME_KEY = 'name';
  static const String ROLE_KEY = 'role';

  // Initialize storage
  static Future<void> init() async {
    await GetStorage.init('user_data');
  }
  
  // Save user data
  static Future<void> saveUserData({
    required String token,
    required String email,
    required String name,
    required String role,
  }) async {
    await _storage.write(TOKEN_KEY, token);
    await _storage.write(EMAIL_KEY, email);
    await _storage.write(NAME_KEY, name);
    await _storage.write(ROLE_KEY, role);
  }
  
  // Get token
  static String? getToken() {
    return _storage.read(TOKEN_KEY);
  }
  
  // Get email
  static String? getEmail() {
    return _storage.read(EMAIL_KEY);
  }
  
  // Get name
  static String? getName() {
    return _storage.read(NAME_KEY);
  }
  
  // Get role
  static String? getRole() {
    return _storage.read(ROLE_KEY);
  }
  
  // Check if user is logged in
  static bool isLoggedIn() {
    return _storage.hasData(TOKEN_KEY) && _storage.read(TOKEN_KEY) != null;
  }
  
  // Clear all user data (logout)
  static Future<void> clearUserData() async {
    await _storage.erase();
  }
  
  // For debugging
  static void printStorageData() {
    print('Token: ${getToken()}');
    print('Email: ${getEmail()}');
    print('Name: ${getName()}');
    print('Role: ${getRole()}');
  }
}