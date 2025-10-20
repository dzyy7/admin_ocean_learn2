import 'package:get_storage/get_storage.dart';

class UserStorage {
  static final _storage = GetStorage('user_data');
  
  static const String TOKEN_KEY = 'token';
  static const String EMAIL_KEY = 'email';
  static const String NAME_KEY = 'name';
  static const String ROLE_KEY = 'role';

  static Future<void> init() async {
    await GetStorage.init(' ');
  }
  
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
  
  static String? getToken() {
    return _storage.read(TOKEN_KEY);
  }
  
  static String? getEmail() {
    return _storage.read(EMAIL_KEY);
  }
  
  static String? getName() {
    return _storage.read(NAME_KEY);
  }
  
  static String? getRole() {
    return _storage.read(ROLE_KEY);
  }
  
  static bool isLoggedIn() {
    return _storage.hasData(TOKEN_KEY) && _storage.read(TOKEN_KEY) != null;
  }
  
  static Future<void> clearUserData() async {
    await _storage.erase();
  }
  
  static void printStorageData() {
    print('Token: ${getToken()}');
    print('Email: ${getEmail()}');
    print('Name: ${getName()}');
    print('Role: ${getRole()}');
  }
}