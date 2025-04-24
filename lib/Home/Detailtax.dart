import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tax_app/%C2%A0Tax/Tax.dart';
import 'package:flutter_tax_app/Home/Home.dart';
import 'package:flutter_tax_app/Share_data/Share-data.dart';
import 'package:flutter_tax_app/userdatamodel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Income/incom.dart';
import 'package:flutter_tax_app/Login/Login.dart';

class Detailertax extends StatefulWidget {
  const Detailertax({super.key});

  @override
  State<Detailertax> createState() => _DetailertaxState();
}

class _DetailertaxState extends State<Detailertax> {
  List<dynamic> datatax = [];
  Map<String, dynamic>? _datatax;
  num totalAmount = 0;
  num totaltax = 0;
  // num totaltaxwithhold = 0;
  IncomeModel? incomeModel;
  List<Map<String, dynamic>> taxData = [];

  @override
  void initState() {
    super.initState();
    final formatter = NumberFormat('#,###');
    incomeModel = Provider.of<IncomeModel>(context, listen: false);

    taxData = List<Map<String, dynamic>>.from(incomeModel?.incomeData ?? []);

    _loadtax();
  }

  Future<void> deleteItem(int index, String tax_id) async {
    String? userId = await ShareDataUserid.getUserId();
    try {
      final url = Uri.parse('http://localhost:3000/deletetax/${userId!}');

      final res = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'tax_id': tax_id,
        }),
      );

      if (res.statusCode == 200) {
        await _loadtax();
        final deletedItem = taxData[index];
        final taxToRemove = num.parse(deletedItem['tax']?.toString() ?? '0');

        setState(() {
          taxData.removeAt(index);
          totaltax -= taxToRemove;

          incomeModel?.settax(totaltax.toInt());
          // incomeModel?.setincome(totalAmount.toInt());
          // // incomeModel?.settax_withhold(totaltaxwithhold.toInt());
          // incomeModel?.setincomeData(taxData);
        });
      }
    } catch (e) {
      print('Error: $e');
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

        setState(() {
          datatax = data;
          print(datatax);
          if (datatax.isNotEmpty) {
            _datatax = datatax[0];
            totaltax = 0;
            for (var item in datatax) {
              totaltax += item['tax']!;
            }

            incomeModel?.settax(totaltax as int?);
            incomeModel?.settaxData(datatax);
            taxData = List<Map<String, dynamic>>.from(datatax);
          }
        });
      } else {
        print('Error: ${res.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  void showEditDialog(BuildContext context, String currentTitle,
      String currentTax, String tax_id) {
    // final incomeController = TextEditingController(text: currentTax);
    final taxController = TextEditingController(text: currentTax);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(currentTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taxController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  labelText: "ลดหย่อน",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.grey[800],
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.remove_circle_outline),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "ยกเลิก",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // final newIncome = incomeController.text;
                final newTax = taxController.text;

                // print(newTax + newIncome + 'ddd ' + tax_id);
                updatetaxData(newTax, tax_id);

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFceff6a),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("บันทึก"),
            ),
          ],
        );
      },
    );
  }

  Future<void> updatetaxData(String tax, String tax_id) async {
    final url =
        Uri.parse('http://localhost:3000/updatetax/${int.parse(tax_id)}');

    try {
      final res = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'tax': tax,
        }),
      );

      if (res.statusCode == 200) {
        print("Income updated successfully");
        await _loadtax();
      } else {
        print("Failed to update income: ${res.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyApp(),
              ),
            );
          },
        ),
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            "Tax",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: false,
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Boxbalance("ลดหย่อนไปแล้ว", totaltax.toString() ?? "0"),
                  taxData.isEmpty
                      ? Center(
                          child: Center(
                          child: Container(
                            child: Text("ไม่มีข้อมูล"),
                          ),
                        ))
                      : Expanded(
                          child: ListView.builder(
                            itemCount: taxData.length,
                            itemBuilder: (context, index) {
                              final item = taxData[index];
                              return paymentCard(
                                title: item['type_value']?.toString() ??
                                    'ไม่มีชื่อ',
                                tax: '฿${item['tax'] ?? 0}',
                                onDelete: () {
                                  if (item['tax_id'] != null) {
                                    deleteItem(
                                        index, item['tax_id'].toString());
                                  } else {
                                    print("tax_id is null");
                                  }
                                },
                                onEdit: () {
                                  showEditDialog(
                                      context,
                                      item['type_value']?.toString() ??
                                          'แก้ไขข้อมูล',
                                      '${item['tax'] ?? 0}',
                                      item['tax_id'].toString());
                                },
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            btnincome(context, 'ลดหย่อน ก้อนใหม่'),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget Boxbalance(String title, String value) {
    return Container(
        padding: EdgeInsets.all(50),
        margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
        // margin: EdgeInsets.all(15),
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
            title,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255)),
          ),
          Divider(height: 24),
          Text(
            "฿$value",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFceff6a)),
          ),
        ]));
  }

  Widget paymentCard({
    required String title,
    required String tax,
    required VoidCallback onDelete,
    required VoidCallback onEdit,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(20),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              InkWell(
                onTap: onEdit,
                child: Icon(
                  Icons.edit,
                  size: 18,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            tax,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("ภาษี", style: TextStyle(fontSize: 14)),
              Text(tax, style: TextStyle(fontSize: 14)),
            ],
          ),
          Divider(height: 24),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceAround, // Changed to spaceAround for better spacing
              children: [
                InkWell(
                  onTap: onDelete,
                  child: Text(
                    "Delete",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget btnincome(BuildContext context, String title) {
    return Center(
      child: SizedBox(
          width: double.infinity,
          child: Container(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Taxpage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFceff6a),
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Colors.black, width: 2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, color: Color.fromARGB(255, 0, 0, 0)),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
