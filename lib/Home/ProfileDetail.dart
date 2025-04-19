import 'package:flutter/material.dart';
import 'package:flutter_tax_app/Login/Login.dart';

class Profiledetail extends StatefulWidget {
  const Profiledetail({super.key});

  @override
  State<Profiledetail> createState() => _ProfiledetailState();
}

class _ProfiledetailState extends State<Profiledetail> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        buildProfileDetail('ชื่อผู้ใช้งาน', 'Buranasak'),
        const SizedBox(height: 20),
        buildProfileDetail('อีเมล', 'Buranasak2303@gmail.com'),
        const SizedBox(height: 20),
        buildProfileDetail('เบอร์โทร', '0982468157'),
      ],
    );
  }
}


Widget buildProfileDetail(String title,String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            value,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
}

Widget buildLogoutbtn(BuildContext context) {

  return Column(
    children: [
      const SizedBox(height: 40),
      Center(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
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
  );

}
