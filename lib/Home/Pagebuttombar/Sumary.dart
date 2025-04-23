import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tax_app/Share_data/Share-data.dart';
import 'package:flutter_tax_app/userdatamodel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Sumary extends StatefulWidget {
  const Sumary({super.key});

  @override
  State<Sumary> createState() => _SumaryState();
}

class _SumaryState extends State<Sumary> {
  IncomeModel? incomeModel;
  int paytax = 0;

  List<Widget>? _pages;
  num totalAmount = 0;
  num totaltax = 0;
  num totaltaxwithhold = 0;

  @override
  void initState() {
    super.initState();
    final formatter = NumberFormat('#,###');
    incomeModel = Provider.of<IncomeModel>(context, listen: false);

    _loaddatauser();
  }

  Future<void> _loaddatauser() async {
    await _loadincome();
    await _loadtax();
    // await calculateTax();
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

        setState(() {
          dataincome = data;
          if (dataincome.isNotEmpty) {
            _dataincome = dataincome[0];

            print('datauser ${_dataincome!}');

            for (var item in dataincome) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Boxsumary(
                      'จ่ายภาษีเพิ่ม ', ' ${incomeModel?.paytax.toString()}'),
                  Boxcontenter(
                    titleincome: "รายได้",
                    income: incomeModel?.total_amount.toString() ?? "0",
                    titletax: "ภาษีหัก ณ ที่จ่าย",
                    taxwithhold:
                        incomeModel?.total_tax_withhold.toString() ?? "0",
                  ),
                  Boxcontenter1(
                    titleincome: "ภาษี",
                    income: incomeModel?.total_tax.toString() ?? "0",
                    titletax: "ภาที่ต้องจ่าย",
                    taxwithhold: incomeModel?.paytax.toString() ?? "0",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget Boxsumary(String title, String value) {
  return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 0, 0),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 4),
          )
        ],
      ),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Text(
          value,
          style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFFceff6a)),
        ),

        Divider(height: 20), // ขีดเส้น

        Text(
          title,
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ]));
}

Widget Boxcontenter(
    {required String titleincome,
    required String income,
    required String titletax,
    required String taxwithhold}) {
  return Container(
    padding: EdgeInsets.all(30),
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 255, 255, 255),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: const Color.fromARGB(55, 0, 0, 0),
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 6,
          offset: const Offset(0, 4),
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(titleincome,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("฿$income", style: TextStyle(fontSize: 16)),
          ],
        ),
        Divider(
          height: 24,
        ),

        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(titletax,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("฿$taxwithhold", style: TextStyle(fontSize: 16)),
          ],
        ),
        Divider(height: 24), // ขีดเส้น
        SizedBox(height: 12),
      ],
    ),
  );
}

Widget Boxcontenter1(
    {required String titleincome,
    required String income,
    required String titletax,
    required String taxwithhold}) {
  return Container(
    padding: EdgeInsets.all(30),
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 255, 255, 255),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: const Color.fromARGB(55, 0, 0, 0),
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 6,
          offset: const Offset(0, 4),
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(titleincome,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("฿$income", style: TextStyle(fontSize: 16)),
          ],
        ),
        Divider(
          height: 24,
        ),

        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(titletax,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("฿$taxwithhold", style: TextStyle(fontSize: 16)),
          ],
        ),
        Divider(height: 24), // ขีดเส้น
        SizedBox(height: 12),
      ],
    ),
  );
}
