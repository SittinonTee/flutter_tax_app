import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tax_app/userdatamodel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tax_app/Home/Home.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tax_app/Share_data/Share-data.dart';
import 'package:flutter_tax_app/Signup/Signup.dart';

// import 'package:flutter_tax_app/userdatamodel.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;

  final formKey = GlobalKey<FormState>();
  String Username = '';
  String Password = '';
  String User_id = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await ShareDataUserid.checkLogin();
    print(isLoggedIn);

    if (isLoggedIn) {
      // String? userId = await dShareDataUseri.getUserId();
      // String? username = await ShareDataUserid.getUsername();

      // print(await ShareDataUserid.getUserId());
      // print(await ShareDataUserid.getUsername());

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => MyApp()),
      );
    } else {
    }
  }

  Future<void> _login() async {
    bool success = await ShareDataUserid.login(Username, Password);
    // final userModels = Provider.of<UserModel>(context, listen: false);
    // print(userModels.userId);
    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('เข้าสู่ระบบล้มเหลว')),
      );
    }
  }

  // final List<dynamic> _users = [];

  // Future<void> _fetchUsers() async {
  //   final response = await http.get(Uri.parse('VERCEL_URL/users'));
  //   setState(() {
  //     _users = json.decode(response.body);
  //   });
  // }

  // Future<bool> login(String username, String password) async {
  //   final url = Uri.parse('http://localhost:3000/login');

  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       'username': username,
  //       'password': password,
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     print('✅ Login success: $data');

  //     var user = data['user'];
  //     String? userId = user['user_id'].toString();
  //     String? username = user['username'];
  //     String? gmail = user['gmail'];

  //     print('User ID: $userId');
  //     print('Username: $username');
  //     print('Gmail: $gmail');

  //     final usermodel = Provider.of<UserModel>(context, listen: false);
  //     usermodel.setUser(userId, username);
  //     // final UserModel = Provider.of<UserModel>(context, listen: false);
  //     // UserModel.setUser(userId, username);
  //     // User_id = userId;
  //     // Username = username!;

  //     return true;
  //   } else {
  //     final error = jsonDecode(response.body);
  //     print('❌ Login failed: ${error['message']}');
  //     return false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                color: const Color.fromARGB(255, 255, 255, 255),
                    child: Image.asset(
                      'assets/images/tax2.jpeg',
                      width: 500,
                      fit: BoxFit.cover,
                    ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Username Field
                    // Container(
                    //   height: 50,
                    //   width: double.infinity,
                    // decoration: BoxDecoration(
                    //   color: Colors.black,
                    //   borderRadius: BorderRadius.circular(50),
                    // ),

                    TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          labelText: "Username",
                          labelStyle: TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 230, 230, 230),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none,
                          ),
                          errorStyle: TextStyle(
                            color: const Color.fromARGB(
                                255, 252, 3, 3), 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "กรอกชื่อด้วย";
                          }
                          return null;
                        },
                        onSaved: (value) => {Username = value!}),

                    const SizedBox(height: 40),

                    TextFormField(
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 230, 230, 230),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none,
                        ),
                        errorStyle: TextStyle(
                          color: const Color.fromARGB(
                              255, 255, 0, 0), 
                          fontWeight: FontWeight.bold,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "กรอกmailด้วย";
                        }
                        return null;
                      },
                      onSaved: (value) => {Password = value!},
                    ),

                    const SizedBox(height: 30),

                    // Login Button
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          _login();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 50,
                        ),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.black87),
                        children: [
                          TextSpan(
                            text: "   Signup",
                            style: TextStyle(
                              color:
                                  Color.fromARGB(255, 8, 156, 241),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                           
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpPage()),
                                );
                              },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
