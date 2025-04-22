import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tax_app/Home/Boxcontent.dart';
import 'package:flutter_tax_app/Home/Pagebuttombar/Add.dart';
import 'package:flutter_tax_app/Home/Pagebuttombar/NotificationsPage.dart';
import 'package:flutter_tax_app/Home/Pagebuttombar/ProfileDetail.dart';
import 'package:flutter_tax_app/Home/Pagebuttombar/sumary.dart';
import 'package:flutter_tax_app/Home/TopBar.dart';
import 'package:flutter_tax_app/Login/Login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tax_app/userdatamodel.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tax_app/Share_data/Share-data.dart';

// void main() {
//   runApp(const MyApp());
// }
//----------------------------------------------------------------------------------------------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Kanit',
      ),
      home: HomePage(),
    );
  }
}

//----------------------------------------------------------------------------------------------------------------------------------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
//l;sdf;lsdfk;lsdkfkpoek;sl,df;sld,f;ls,e/.s,d/.f,el,s;d,f;se,

class _HomePageState extends State<HomePage> {
  IncomeModel? incomeModel;
  List<Widget>? _pages;
  num totalAmount = 0;

  @override
  void initState() {
    super.initState();

    incomeModel = Provider.of<IncomeModel>(context, listen: false);
    _loadDataUser();
  }

  List<dynamic> datauser = [];
  Map<String, dynamic>? _datauser;

  Future<void> _loadDataUser() async {
    String? userId = await ShareDataUserid.getUserId();

    try {
      final url = Uri.parse('http://localhost:3000/getdata/${userId!}');

      final res = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        // แปลงข้อมูลที่ได้รับจาก API เป็น List<Map<String, dynamic>>

        // final data = List<Map<String, dynamic>>.from(jsonDecode(res.body));
        final data = jsonDecode(res.body);
        print('✅ Get data success: $data');

        setState(() {
          datauser = data;
          if (datauser.isNotEmpty) {
            _datauser = datauser[0];
            // print('datauser ${datauser}');
            print('datauser ${_datauser!}');
            // print(_datauser?['amount']);

            for (var item in datauser) {
              print('oooo ${item['amount']}');
              totalAmount += item['amount']!;
            }

            incomeModel?.setincome(totalAmount as int?);
            incomeModel?.setincomeData(datauser);

            // print('asdasdasdasdasd     ${incomeModel?.incomeData}');
          }
        });
      } else {
        print('❌ Error: ${res.statusCode}');
      }
    } catch (e) {
      print('❌ Exception: $e');
    }
  }

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    _pages = [
      Homepage(),
      const Sumary(),
      const Add(),
      const NotificationsPage(), //
      const Profiledetail(),
    ];

    // if (_datauser == null) {
    //   // แสดงหน้าโหลดหากข้อมูลยังไม่พร้อม
    //   return Scaffold(
    //     backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    //     body: SafeArea(
    //       child: Column(
    //         children: [
    //           Topbar(),
    //           Expanded(
    //             child: Center(
    //               child: CircularProgressIndicator(),
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   );
    // }

    // โค้ด UI ปกติ
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          children: [
            const Topbar(),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: IndexedStack(
                  index: _selectedIndex,
                  children: _pages!,
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  //wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
  Widget Homepage() {
    return Column(
      children: [
        BalanceCard(), // ส่วน BalanceCard
        SizedBox(
          height: 60,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: const Text(
                "รายการ", // ข้อความ "รายการ"
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Boxcontent(
            // user_id: userModel.userId!,
            // username: userModel.username!), // ส่วน Boxcontent
            )
      ],
    );
  }

  //wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwBalanceCardwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
  Widget BalanceCard() {
    // print('ddsd ${dd}');
    return Container(
      width: double.infinity,
      height: 380,
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // ✅ กลางแนวตั้ง
          crossAxisAlignment: CrossAxisAlignment.center, // ✅ กลางแนวนอน
          children: [
            const Text(
              'ภาษีที่ต้องจ่าย',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "9999999999",
              style: TextStyle(
                color: Color(0xFFceff6a),
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'คุณมีโอกาสทำเพิ่มอีก ฿ 0',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: 0.5,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey[800],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFFceff6a)),
                  ),
                ),
                const Text(
                  '50%',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Text(
                'ได้สิทธิ์ลดหย่อนไปแล้ว',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

  //wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
  Widget buildBottomNavigationBar() {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 0),
          _buildNavItem(Icons.show_chart, 1),
          _buildAddButton(),
          _buildNavItem(Icons.notifications, 3),
          _buildNavItem(Icons.more_horiz, 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return IconButton(
      icon: Icon(
        icon,
        size: 30,
        color: _selectedIndex == index ? const Color(0xFFceff6a) : Colors.white,
      ),
      onPressed: () {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFceff6a),
        borderRadius: BorderRadius.circular(25),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.add,
          color: Colors.black,
          size: 30,
        ),
        onPressed: () {
          setState(() {
            _selectedIndex = 2; // ตั้งค่าให้เป็นหน้า AddPage
          });
        },
      ),
    );
  }
}

//----------------------------------------------------------------------------------------------------------------------------------------------
