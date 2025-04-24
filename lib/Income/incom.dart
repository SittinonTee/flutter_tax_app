import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tax_app/Home/Home.dart';
import 'package:flutter_tax_app/Income/input/inputincome.dart';
import 'package:http/http.dart' as http;

class incomepage extends StatefulWidget {
  const incomepage({super.key});

  // final String user_id;
  // final String username;

  @override
  State<incomepage> createState() => _incomepageState();
}

List<Map<String, dynamic>> incomeItems = [
  {"title": "เงินเดือน", "value": "งานประจำปี", "icon": Icons.work},
  {"title": "โบนัส", "value": "งานประจำปี", "icon": Icons.card_giftcard},
  {"title": "ขายของออนไลน์", "value": "รายได้เสริม", "icon": Icons.store},
  {
    "title": "ขายอาหารเครื่องดื่ม",
    "value": "รายได้เสริม",
    "icon": Icons.food_bank
  },
  {"title": "อาชีพอิสระ", "value": "รายได้เสริม", "icon": Icons.token},
  {"title": "เงินปันผล", "value": "ดอกเบี้ย", "icon": Icons.money}
];
final Map<String, List<String>> incomeData = {
  "งานประจำปี": ["เงินเดือนและโบนัส"],
  "รายได้เสริม": ["ขายของออนไลน์", "รับจ้างออกแบบ"],
  "ดอกเบี้ย": ["บัญชีออมทรัพย์", "กองทุนรวม"],
  // "ค่าจ้างทั่วไป": ["คอมมิชชั่น", "เบี้ยประกัน"],
};

// int dd = 0;

// List<Map<String, dynamic>> deductions = [];

class _incomepageState extends State<incomepage> {
  @override
  void initState() {
    super.initState();
    // fetchDeductions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.black, width: 1),),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey,
            height: 1.0,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyApp(),
                ),
              );
            },
            child: const Text(
              'Home',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          )
        ],
        centerTitle: false,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          children: [
            // const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                width: double.infinity,
                color: const Color.fromARGB(255, 255, 255, 255),
                padding: const EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "รายได้",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "รายได้ต่อปีของคุณ",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255)),
              child: Column(
                children: List.generate(
                  (incomeItems.length / 2).ceil(),
                  (index) {
                    final first = incomeItems[index * 2];
                    final second = (index * 2 + 1 < incomeItems.length)
                        ? incomeItems[index * 2 + 1]
                        : null;
                    return Row(
                      children: [
                        Expanded(
                          child: Incomecrad(
                              first["title"], first["value"], first["icon"]),
                        ),
                        if (second != null)
                          Expanded(
                            child: Incomecrad(second["title"], second["value"],
                                second["icon"]),
                          )
                        else
                          const Expanded(child: SizedBox()),
                      ],
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              // margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255)),
              child: Column(
                children: incomeData.entries.map((entry) {
                  final type = entry.key;
                  final dataList = entry.value;
                  return incomecrad2(context, type, dataList);
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget Incomecrad(String title, String value, IconData icon) {
    return Container(
        decoration: BoxDecoration(
            // border: Border.all(color: Colors.black, width: 2),
            // boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
            borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(10),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Inputincome(type: title, data: value),
              ),
            );
          },
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                height: 100,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 69, 69, 69),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(1),
                    width: 2,
                  ),
                ),
                alignment: Alignment.topLeft,
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFceff6a),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget incomecrad2(BuildContext context, String type, List<String> dataList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: const Color.fromARGB(199, 146, 146, 146),
          padding: const EdgeInsets.all(10),
          child: Text(
            type,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        ...dataList.map((data) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Inputincome(type: type, data: data),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              color: const Color.fromARGB(255, 255, 255, 255),
              padding: const EdgeInsets.fromLTRB(30, 5, 5, 5),
              alignment: Alignment.centerLeft,
              child: Text(
                data,
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          );
        }),
        const SizedBox(height: 10),
      ],
    );
  }
}
