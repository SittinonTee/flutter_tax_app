import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tax_app/Login/Login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  String username = '';
  String email = '';
  String phone = '';
  String age = '';
  String password = '';
  String confirmPassword = '';
  bool _obscureText = true;
  bool _obscureConfirmText = true;

  @override
  Widget build(BuildContext context) {
    final fieldWidth = MediaQuery.of(context).size.width * 0.8; // 80% ของหน้าจอ

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Header
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                child: Center(
                   child: Image.asset(
                      'assets/images/tax2.jpeg',
                      width: 500,
                      fit: BoxFit.cover,
                    ),
                ),
              ),
            ),

            // ฟิลด์ทั้งหมด
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
                        validatorMsg: "กรอกอีเมลด้วย",
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: buildTextField(
                        icon: Icons.phone,
                        label: "Phone",
                        keyboardType: TextInputType.phone,
                        onSaved: (val) => phone = val!,
                        validatorMsg: "กรอกเบอร์โทรด้วย",
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: buildTextField(
                        icon: Icons.cake,
                        label: "Age",
                        keyboardType: TextInputType.number,
                        onSaved: (val) => age = val!,
                        validatorMsg: "กรอกอายุก่อน",
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: buildTextField(
                        icon: Icons.lock,
                        label: "Password",
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
                        obscureText: _obscureConfirmText,
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmText
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () => setState(
                              () => _obscureConfirmText = !_obscureConfirmText),
                        ),
                        onSaved: (val) => confirmPassword = val!,
                        validatorMsg: "ยืนยันรหัสผ่าน",
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
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
                        style: TextStyle(fontSize: 16, color: Colors.white),
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
                              color:
                                  Color.fromARGB(255, 8, 156, 241), // สีไฮไลต์
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // เปลี่ยนไปหน้าสมัครสมาชิก
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

  void _onSignUpPressed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("รหัสผ่านไม่ตรงกัน"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("สมัครเรียบร้อยแล้ว!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Widget buildTextField({
    required IconData icon,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    required String? Function(String?)? onSaved,
    required String validatorMsg,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        onSaved: onSaved,
        validator: (value) =>
            (value == null || value.isEmpty) ? validatorMsg : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,labelStyle: TextStyle(color: Colors.black),
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
