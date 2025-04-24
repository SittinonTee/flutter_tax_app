import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ShareDataUserid {
  static const String key_userId = 'user_id';
  static const String key_username = 'username';
  static const String key_isLogin = 'isLogin';

  static Future<bool> login(String username, String password) async {
    final url = Uri.parse('http://localhost:3000/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(' Login successกกกกกก: $data');

      var user = data['user'];
      String userId = user['user_id'].toString();
      String username = user['username'];

      // print('User ID: $userId');
      // print('Username: $username');

      // อย่าลบ

      // final usermodel = Provider.of<UserModel>(context, listen: false);
      // usermodel.setUser(userId, username);

      // final UserModel = Provider.of<UserModel>(context, listen: false);
      // UserModel.setUser(userId, username);
      // User_id = userId;
      // Username = username!;

      await saveUserData(userId, username);

      final prefs = await SharedPreferences.getInstance();
      print(
          'hhhhhhh  isLogin=${prefs.getBool(key_isLogin)}, username=${prefs.getString(key_username)}');

      return true;
    } else {
      final error = jsonDecode(response.body);
      print('Login failed: ${error['message']}');
      return false;
    }
  }

  static Future<void> saveUserData(String userId, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key_userId, userId);
    await prefs.setString(key_username, username);
    await prefs.setBool(key_isLogin, true);
  }

  static Future<bool> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    print(key_userId + ' ' + key_username + ' ' + key_isLogin);
    return prefs.getBool(key_isLogin) ?? false;
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key_userId);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key_username);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key_userId);
    await prefs.remove(key_username);
    await prefs.setBool(key_isLogin, false);
  }

  static Future<bool> signup(Map<String, dynamic> data) async {
    final url = Uri.parse('http://localhost:3000/signup');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(' Login successกกกกกก: $data');

      return true;
    } else {
      final error = jsonDecode(response.body);
      print('Login failed: ${error['message']}');
      return false;
    }
  }
}
