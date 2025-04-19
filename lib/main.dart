import 'package:flutter/material.dart';
import 'package:flutter_tax_app/Login/Login.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_tax_app/test.dart';
// import 'userdatamodel.dart';
import 'package:flutter_tax_app/userdatamodel.dart';

// class UserProvider extends ChangeNotifier {
//   String? userId;
//   String? username;
//   Map<String, dynamic>? userData;

//   void setUser(String? id, String? name) {
//     userId = id;
//     username = name;
//     notifyListeners();
//   }

//   void setUserData(Map<String, dynamic> data) {
//     userData = data;
//     notifyListeners();
//   }
// }

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Login(),
      ),
    ),
  );
}
