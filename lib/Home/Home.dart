import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tax_app/Home/Boxcontent.dart';
import 'package:flutter_tax_app/Login/Login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tax_app/userdatamodel.dart';
import 'package:provider/provider.dart';

// void main() {
//   runApp(const MyApp());
// }
//----------------------------------------------------------------------------------------------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // final String? user_id;
  // final String? username;

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
  const HomePage({super.key, this.user_id, this.username});

  final String? user_id;
  final String? username;

  @override
  State<HomePage> createState() => _HomePageState();
}
//l;sdf;lsdfk;lsdkfkpoek;sl,df;sld,f;ls,e/.s,d/.f,el,s;d,f;se,

class _HomePageState extends State<HomePage> {
  late UserModel userModel;
  IncomeModel? incomeModel;
  List<Widget>? _pages;
  num totalAmount = 0;

  @override
  void initState() {
    super.initState();

    userModel = Provider.of<UserModel>(context, listen: false);
    incomeModel = Provider.of<IncomeModel>(context, listen: false);
    _loadDataUser();
  }

  // String dd = 'dddddd';

  List<dynamic> datauser = [];
  Map<String, dynamic>? _datauser;

  Future<void> _loadDataUser() async {
    try {
      final url =
          Uri.parse('http://localhost:3000/getdata/${userModel.userId}');

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
            print('datauser ${datauser!}');
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

  // int amount = 0;

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    _pages = [
      Homepage(),
      const ChartPage(),
      const AddPage(),
      const NotificationsPage(),
      const ProfilePage(),
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
            Topbar(),
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
  Widget Topbar() {
    return Padding(
      // padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 50,
            width: 180,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${userModel.userId},${userModel.username!}',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(Icons.person, size: 40, color: Colors.white),
          ),
        ],
      ),
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
            user_id: userModel.userId!,
            username: userModel.username!), // ส่วน Boxcontent
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
  // Widget Boxcontent({required String user_id, required String username}) {

  // }

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
// class Homepage extends StatefulWidget {
//   const Homepage({super.key});

//   @override
//   State<Homepage> createState() => _HomepageState();
// }

// class _HomepageState extends State<Homepage> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const BalanceCard(), // ส่วน BalanceCard
//         SizedBox(
//           height: 60,
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: Container(
//               padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
//               child: const Text(
//                 "รายการ", // ข้อความ "รายการ"
//                 style: TextStyle(
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         const Boxcontent(), // ส่วน Boxcontent
//       ],
//     );
//   }
// }

//----------------------------------------------------------------------------------------------------------------------------------------------
class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Chart Page",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

//----------------------------------------------------------------------------------------------------------------------------------------------
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Notifications Page",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

//----------------------------------------------------------------------------------------------------------------------------------------------
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20), //padding เนื้อหา

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // จัดเนื้อหาแบบแนวนอน
          children: [
            const SizedBox(height: 20), // กล่องให้ห่างจากข้างบน 20
            const Text(
              'ชื่อผู้ใช้งาน',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10), // กล่องให้ห่างจากข้างบน 10
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                //ใช้ปรับแต่ง Container
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Buranasak',
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
                //ใช้ปรับแต่ง Container
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Buranasak2303@gmail.com',
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
                //ใช้ปรับแต่ง Container
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '0982468157',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const Spacer(),
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
        ),
      ),
    );
  }
}

//----------------------------------------------------------------------------------------------------------------------------------------------
class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_circle, size: 100, color: Color(0xFFceff6a)),
          const SizedBox(height: 20),
          const Text(
            "Add New Content",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              // ทำงานเมื่อกดปุ่ม
            },
            child: const Text(
              "เพิ่มรายการ",
              style: TextStyle(fontSize: 18, color: Color(0xFFceff6a)),
            ),
          ),
        ],
      ),
    );
  }
}
//----------------------------------------------------------------------------------------------------------------------------------------------
