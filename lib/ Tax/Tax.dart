import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tax_app/%C2%A0Tax/input/inputax.dart';
import 'package:flutter_tax_app/Home/Home.dart';
import 'package:flutter_tax_app/Income/input/inputincome.dart';
import 'package:http/http.dart' as http;

class Taxpage extends StatefulWidget {
  const Taxpage({super.key});

  // final String user_id;
  // final String username;

  @override
  State<Taxpage> createState() => TaxpageState();
}

List<Map<String, dynamic>> taxItems = [
  {"title": "ประกันสังคม", "value": 9000, "icon": Icons.work, "type": "ประกัน"},
  {
    "title": "Esay-E-receipt",
    "value": 50000,
    "icon": Icons.card_giftcard,
    "type": "อื่นๆ"
  },
  {
    "title": "เบี้ยประกันขีวิตบำนาญ",
    "value": 200000,
    "icon": Icons.attach_money,
    "type": "ประกัน"
  },
  {
    "title": "ประกันขีวิตทั่วไป",
    "value": 100000,
    "icon": Icons.attach_money,
    "type": "ประกัน"
  },
  {
    "title": "บริจาก",
    "value": 9000,
    "icon": Icons.attach_money,
    "type": "บริจาก"
  },
  {
    "title": "ดอกเบี้ยบ้าน",
    "value": 100000,
    "icon": Icons.store,
    "type": "อื่นๆ"
  },
];

class TaxpageState extends State<Taxpage> {
  List<Map<String, dynamic>> taxdataList = [];
  Map<String, List<Map<String, dynamic>>> groupedtaxdata = {};

  @override
  void initState() {
    super.initState();
    fetchdataTax();
  }

  Map<String, List<Map<String, dynamic>>> groupedtaxdataByCategory(
      List<Map<String, dynamic>> data) {
    Map<String, List<Map<String, dynamic>>> result = {};

    for (var item in data) {
      String category = item['category'];

      if (!result.containsKey(category)) {
        result[category] = [];
      }

      result[category]!.add({
        'name': item['name'],
        'maxAmount': item['maxAmount'],
      });
    }
    return result;
  }

  Future<void> fetchdataTax() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/getdataTaxdetails'),
      );

      if (response.statusCode == 200) {
        List jsonResponse = jsonDecode(response.body);

        setState(() {
          taxdataList = [];

          for (var item in jsonResponse) {
            taxdataList.add({
              'name': item['name'],
              'maxAmount': item['max_amount'],
              'category': item['category'],
            });
          }

          groupedtaxdata = groupedtaxdataByCategory(taxdataList);
        });

        // for (var d in taxdataList) {
        //   print(
        //       '  data: ${d['name']}, type: ${d['category']}, price: ${d['maxAmount']}');
        // }
      } else {
        throw Exception('Failed to load datatax');
      }
    } catch (e) {
      print('Error fetching datatax: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                  context, MaterialPageRoute(builder: (context) => MyApp()));
            },
            child: const Text(
              'Home',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          children: [
            // const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: double.infinity,
                color: const Color.fromARGB(255, 104, 26, 26),
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
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "รายได้ต่อปีของคุณ",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration:
                  BoxDecoration(color: const Color.fromARGB(255, 41, 59, 222)),
              child: Column(
                children: List.generate(
                  (taxItems.length / 2).ceil(),
                  (index) {
                    final first = taxItems[index * 2];
                    final second = (index * 2 + 1 < taxItems.length)
                        ? taxItems[index * 2 + 1]
                        : null;
                    return Row(
                      children: [
                        Expanded(
                          child: Taxcrad(first["title"], first["value"],
                              first["icon"], first["type"]),
                        ),
                        if (second != null)
                          Expanded(
                            child: Taxcrad(second["title"], second["value"],
                                second["icon"], second["type"]),
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
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.amberAccent),
                child: groupedtaxdata.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Column(
                          children: groupedtaxdata.entries.map((entry) {
                            final type = entry.key;
                            final dataList = entry.value;
                            return Taxcrad2(context, type, dataList);
                          }).toList(),
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget Taxcrad(
    String title,
    int value,
    IconData icon,
    String type,
  ) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              InputTax(type: type, data: title, maxAmount: value),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
            // border: Border.all(color: Colors.black, width: 2),
            // boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
            borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(10),
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
                  color: const Color.fromARGB(255, 171, 255, 119),
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
      ),
    );
  }

  Widget Taxcrad2(
      BuildContext context, String type, List<Map<String, dynamic>> dataList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // หัวข้อ type (category)
        Container(
          height: 30,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Text(
            type,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),

        // ลูปข้อมูลแต่ละรายการของ category นี้
        ...dataList.map((data) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InputTax(
                      type: type,
                      data: data['name'],
                      maxAmount: data['maxAmount']),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: 30,
              color: CupertinoColors.systemIndigo,
              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
              alignment: Alignment.centerLeft,
              child: Text(
                data['name'],
                // "${data['name']} (สูงสุด ${data['maxAmount']} บาท)",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }),

        const SizedBox(height: 10),
      ],
    );
  }
}
