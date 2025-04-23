import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tax_app/Home/BalanceCard.dart';
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
  num totaltax = 0;
  num totaltaxwithhold = 0;

  @override
  void initState() {
    super.initState();

    incomeModel = Provider.of<IncomeModel>(context, listen: false);
    // _loadincome();
    // _loadtax();
    _loaddatauser();
  }

  Future<void> _loaddatauser() async {
    await _loadincome();
    await _loadtax();
    await calculateTax();
  }

  List<dynamic> dataincome = [];
  Map<String, dynamic>? _dataincome;
  List<dynamic> datatax = [];
  Map<String, dynamic>? _datatax;

  Future<void> _loadincome() async {
    String? userId = await ShareDataUserid.getUserId();

    try {
      final url = Uri.parse('http://localhost:3000/getuserincome/${userId!}');

      final res = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        // print(' Get data success: $data');

        setState(() {
          dataincome = data;
          if (dataincome.isNotEmpty) {
            _dataincome = dataincome[0];
            // print('datauser ${datauser}');
            print('datauser ${_dataincome!}');
            // print(_datauser?['amount']);

            for (var item in dataincome) {
              // print('oooo ${item['amount']}');
              totalAmount += item['amount']!;
              totaltaxwithhold += item['tax_withhold']!;
            }

            incomeModel?.setincome(totalAmount as int?);
            incomeModel?.setincomeData(dataincome);
            incomeModel?.settax_withhold(totaltaxwithhold as int?);

            // print('asdasdasdasdasd     ${incomeModel?.incomeData}');
          }
        });
      } else {
        print('Error: ${res.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> _loadtax() async {
    String? userId = await ShareDataUserid.getUserId();

    try {
      final url = Uri.parse('http://localhost:3000/getusertax/${userId!}');

      final res = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        // print('Get data success: $data');

        setState(() {
          datatax = data;
          if (datatax.isNotEmpty) {
            _datatax = datatax[0];

            for (var item in datatax) {
              totaltax += item['tax']!;
            }

            incomeModel?.settax(totaltax as int?);
            incomeModel?.settaxData(datatax);
          }
        });
      } else {
        print('Error: ${res.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  int _selectedIndex = 0;

// cal-----------------------------------------------------------------------

  Future<void> calculateTax() async {

    num totalAmount = incomeModel?.total_amount ?? 0;
    num totalTax = incomeModel?.total_tax ?? 0;
    num totalTaxWithhold = incomeModel?.total_tax_withhold ?? 0;


    num expense = totalAmount * 0.5;
    if (expense > 100000) {
      expense = 100000;
    }

    num x = 60000;

    // คำนวณเงินได้สุทธิก่อนหักลดหย่อนเพิ่มเติม
    num netIncomeBeforeDeduction = totalAmount - expense - x;

    // เงินได้สุทธิหลังหักลดหย่อนปัจจุบัน
    num currentNetIncome =
        netIncomeBeforeDeduction - totalTax - totalTaxWithhold;

    // คำนวณภาษีปัจจุบัน
    double currentTax = calculateTaxByIncome(currentNetIncome);
    incomeModel?.setpaytax(currentTax.toInt());

    // คำนวณเงินได้สุทธิหากใช้สิทธิลดหย่อนเพิ่มเติมทั้งหมด
    // สมมติว่ามีสิทธิลดหย่อนเพิ่มเติมสูงสุดที่ใช้ได้
    num maxDeduction = calculateMaxAvailableDeduction(netIncomeBeforeDeduction);
    num additionalDeduction = maxDeduction - (totalTax + totalTaxWithhold);
    num potentialNetIncome = currentNetIncome - additionalDeduction;

    // คำนวณภาษีที่อาจจ่ายน้อยที่สุด
    double potentialMinTax = calculateTaxByIncome(potentialNetIncome);
    print(potentialMinTax.toInt());
    // incomeModel?.setPotentialMinTax(potentialMinTax.toInt());

    // คำนวณเปอร์เซ็นต์สิทธิลดหย่อนที่ใช้ไปแล้ว
    num totalPossibleDeduction =
        calculateTotalPossibleDeduction(netIncomeBeforeDeduction);
    num usedDeduction = totalTax + totalTaxWithhold;
    double percentageUsed = (usedDeduction / totalPossibleDeduction) * 100;
    print(percentageUsed.toInt());
    // incomeModel?.setDeductionUsedPercentage(percentageUsed.toInt());
  }

// ฟังก์ชันคำนวณภาษีตามขั้นบันได
  double calculateTaxByIncome(num netIncome) {
    double tax = 0;

    if (netIncome <= 150000) {
      tax = 0;
    } else if (netIncome <= 300000) {
      tax = (netIncome - 150000) * 0.05;
    } else if (netIncome <= 500000) {
      tax = (150000 * 0.05) + (netIncome - 300000) * 0.10;
    } else if (netIncome <= 750000) {
      tax = (150000 * 0.05) + (200000 * 0.10) + (netIncome - 500000) * 0.15;
    } else if (netIncome <= 1000000) {
      tax = (150000 * 0.05) +
          (200000 * 0.10) +
          (250000 * 0.15) +
          (netIncome - 750000) * 0.20;
    } else if (netIncome <= 2000000) {
      tax = (150000 * 0.05) +
          (200000 * 0.10) +
          (250000 * 0.15) +
          (250000 * 0.20) +
          (netIncome - 1000000) * 0.25;
    } else if (netIncome <= 5000000) {
      tax = (150000 * 0.05) +
          (200000 * 0.10) +
          (250000 * 0.15) +
          (250000 * 0.20) +
          (1000000 * 0.25) +
          (netIncome - 2000000) * 0.30;
    } else {
      tax = (150000 * 0.05) +
          (200000 * 0.10) +
          (250000 * 0.15) +
          (250000 * 0.20) +
          (1000000 * 0.25) +
          (3000000 * 0.30) +
          (netIncome - 5000000) * 0.35;
    }

    return tax;
  }

// ฟังก์ชันคำนวณสิทธิลดหย่อนสูงสุดที่สามารถใช้ได้
  num calculateMaxAvailableDeduction(num income) {
    // ตัวอย่างการคำนวณสิทธิลดหย่อนต่างๆ
    num deduction = 0;

    // ลดหย่อนกองทุน RMF (สูงสุด 30% ของรายได้ แต่ไม่เกิน 500,000 บาท)
    num maxRmf = min(income * 0.3, 500000);

    // ลดหย่อนกองทุน SSF (สูงสุด 30% ของรายได้ แต่ไม่เกิน 200,000 บาท)
    num maxSsf = min(income * 0.3, 200000);

    // ลดหย่อนประกันชีวิต (สูงสุด 100,000 บาท)
    num insuranceDeduction = 100000;

    // ลดหย่อนบริจาค (สูงสุด 10% ของรายได้หลังหักค่าใช้จ่ายและลดหย่อน)
    num maxDonation = income * 0.1;

    // รวมสิทธิลดหย่อนทั้งหมด
    deduction = maxRmf + maxSsf + insuranceDeduction + maxDonation;

    return deduction;
  }

// ฟังก์ชันคำนวณสิทธิลดหย่อนทั้งหมดที่เป็นไปได้
  num calculateTotalPossibleDeduction(num income) {
    // คล้ายกับฟังก์ชันข้างบน แต่อาจรวมถึงสิทธิลดหย่อนทั้งหมดตามกฎหมาย
    return calculateMaxAvailableDeduction(income);
  }

// ฟังก์ชัน min (หาค่าน้อยที่สุดระหว่าง a และ b)
  num min(num a, num b) {
    return (a < b) ? a : b;
  }

  @override
  Widget build(BuildContext context) {
    _pages = [
      Homepage(),
      const Sumary(),
      const Add(),
      const NotificationsPage(),
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
        BalanceCard(),
        SizedBox(
          height: 60,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: const Text(
                "รายการ",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Boxcontent()
      ],
    );
  }

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
