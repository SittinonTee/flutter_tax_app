import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tax_app/Login/Login.dart';
import 'package:flutter_tax_app/Share_data/Share-data.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Profiledetail extends StatefulWidget {
  const Profiledetail({super.key});

  @override
  State<Profiledetail> createState() => _ProfiledetailState();
}

class _ProfiledetailState extends State<Profiledetail> {
// late String user_id;

  Map<String, dynamic>? _datauser;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadDataUser();
    print("dddddddddkdfs,kfnslekfwlefslefnslefnslkefn");
  }

  Future<void> _loadDataUser() async {
    String? userId = await ShareDataUserid.getUserId();

    try {
      final url =
          Uri.parse('http://localhost:3000/users/${int.parse(userId!)}');

      final res = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        _datauser = data[0];

        // print(_datauser);
        // print(_datauser?['username']);
        setState(() {
          isLoading = false;
        });
      } else {
        print('Error: ${res.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return CircularProgressIndicator();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'ชื่อผู้ใช้งาน',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _datauser?['username'] ?? '',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'อีเมล',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _datauser?['gmail'] ?? '',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'เบอร์โทร',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _datauser?['phone'] ?? '',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'อายุ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _datauser?['age']?.toString() ?? '',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const Spacer(),
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await ShareDataUserid.logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'ออกจากระบบ',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
