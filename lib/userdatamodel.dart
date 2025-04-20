import 'package:flutter/foundation.dart';

class UserModel extends ChangeNotifier {
  String? _userId;
  String? _username;
  // Map<String, dynamic>? _userData;

  String? get userId => _userId;
  String? get username => _username;
  // Map<String, dynamic>? get userData => _userData;

  void setUser(String? id, String? name) {
    _userId = id;
    _username = name;
    notifyListeners(); // แจ้งเตือนผู้ฟังเมื่อมีการเปลี่ยนแปลง
  }

  // void setUserData(Map<String, dynamic>? data) {
  //   _userData = data;
  //   notifyListeners();
  // }
}

class IncomeModel extends ChangeNotifier {
  int? _total_amount;
  List<dynamic>? _incomeData;

  // String? username;
  int? get total_amount => _total_amount;
  List<dynamic>? get incomeData => _incomeData;

  void setincome(int? total_amount) {
    // userId = id;
    // username = name;
    _total_amount = total_amount;
    notifyListeners();
  }

  void setincomeData(List<dynamic>? incomeData) {
    _incomeData = incomeData;
    notifyListeners();
  }
}
