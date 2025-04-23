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
  int? _total_tax;
  int? _total_tax_withhold;
  int? _paytax;
  List<dynamic>? _incomeData;
  List<dynamic>? _taxData;

  // List<dynamic>? _tax_withholdData;

  int? get total_amount => _total_amount;
  List<dynamic>? get incomeData => _incomeData;

  int? get total_tax => _total_tax;
  List<dynamic>? get taxData => _taxData;

  int? get total_tax_withhold => _total_tax_withhold;
  int? get paytax => _paytax;

  void setincome(int? total_amount) {
    _total_amount = total_amount;
    notifyListeners();
  }

  void setincomeData(List<dynamic>? incomeData) {
    _incomeData = incomeData;
    notifyListeners();
  }

  void settax(int? total_tax) {
    _total_tax = total_tax;
    notifyListeners();
  }

  void settaxData(List<dynamic>? taxData) {
    _taxData = taxData;
    notifyListeners();
  }

  void settax_withhold(int? total_tax_withhold) {
    _total_tax_withhold = total_tax_withhold;
    notifyListeners();
  }

  void setpaytax(int? paytax) {
    _paytax = paytax;
    notifyListeners();
  }
}
