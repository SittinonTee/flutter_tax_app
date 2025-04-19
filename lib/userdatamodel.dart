import 'package:flutter/foundation.dart';

class UserModel extends ChangeNotifier {
  String? _userId;
  String? _username;
  Map<String, dynamic>? _userData;

  String? get userId => _userId;
  String? get username => _username;
  Map<String, dynamic>? get userData => _userData;

  void setUser(String? id, String? name) {
    _userId = id;
    _username = name;
    notifyListeners(); // แจ้งเตือนผู้ฟังเมื่อมีการเปลี่ยนแปลง
  }

  void setUserData(Map<String, dynamic>? data) {
    _userData = data;
    notifyListeners();
  }
}
