import 'dart:convert';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tax_app/Login/Login.dart';
import 'package:flutter_tax_app/Share_data/Share-data.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String username = '';
  String email = '';
  String phone = '';
  String age = '';
  String password = '';
  String confirmPassword = '';
  bool _obscureText = true;
  bool _obscureConfirmText = true;
  bool _isLoading = false;

  // API endpoint for signup

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fieldWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                child: Center(
                  child: Image.asset(
                    'assets/images/logo2.png',
                    width: 350,
                    // fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: Column(
                  children: [
                    SizedBox(
                      width: fieldWidth,
                      child: buildTextField(
                        icon: Icons.person,
                        label: "Username",
                        onSaved: (val) => username = val!,
                        validatorMsg: "กรอกชื่อด้วย",
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: buildTextField(
                        icon: Icons.email,
                        label: "Email",
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (val) => email = val!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "กรอกอีเมลด้วย";
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return "รูปแบบอีเมลไม่ถูกต้อง";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: buildTextField(
                        icon: Icons.phone,
                        label: "Phone",
                        keyboardType: TextInputType.phone,
                        onSaved: (val) => phone = val!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "กรอกเบอร์โทรด้วย";
                          }
                          // Validate phone number format (Thai format)
                          if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                            return "เบอร์โทรต้องเป็นตัวเลข 10 หลัก";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: buildTextField(
                        icon: Icons.cake,
                        label: "Age",
                        keyboardType: TextInputType.number,
                        onSaved: (val) => age = val!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "กรอกอายุก่อน";
                          }
                          if (int.tryParse(value) == null) {
                            return "อายุต้องเป็นตัวเลข";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: buildTextField(
                        icon: Icons.lock,
                        label: "Password",
                        controller: _passwordController,
                        obscureText: _obscureText,
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () =>
                              setState(() => _obscureText = !_obscureText),
                        ),
                        onSaved: (val) => password = val!,
                        validatorMsg: "กรอกรหัสผ่านด้วย",
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: buildTextField(
                        icon: Icons.lock,
                        label: "Confirm Password",
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmText,
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmText
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () => setState(
                              () => _obscureConfirmText = !_obscureConfirmText),
                        ),
                        onSaved: (val) => confirmPassword = val!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "ยืนยันรหัสผ่าน";
                          }
                          if (value != _passwordController.text) {
                            return "รหัสผ่านไม่ตรงกัน";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? CircularProgressIndicator(color: Colors.lightGreen)
                        : ElevatedButton(
                            onPressed: _onSignUpPressed,
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
                              "Sign Up",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "have an account? ",
                        style: TextStyle(color: Colors.black87),
                        children: [
                          TextSpan(
                            text: "   Login",
                            style: TextStyle(
                              color: Color.fromARGB(255, 8, 156, 241),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()),
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

  Future<void> _onSignUpPressed() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      print("object");

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("รหัสผ่านไม่ตรงกัน"),
            backgroundColor: Colors.red,
          ),
        );
        print("object1");
        return;
      }

      final userData = {
        'username': username,
        'email': email,
        'phone': phone,
        'age': age,
        'password': password,
      };

      print("object2");
      bool success = await ShareDataUserid.signup(userData);
      print(success);
      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('สมัครล้มเหลว')),
        );
      }
    }
  }

  Widget buildTextField({
    required IconData icon,
    required String label,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    void Function(String?)? onSaved,
    String? Function(String?)? validator,
    String? validatorMsg,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onSaved: onSaved,
        validator: validator ??
            ((value) => (value == null || value.isEmpty) ? validatorMsg : null),
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: const Color(0xFFE6E6E6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
