import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tax_app/Home/Home.dart';
import 'package:flutter_tax_app/Share_data/Share-data.dart';
import 'package:flutter_tax_app/userdatamodel.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../Income/incom.dart';
import 'package:flutter_tax_app/Login/Login.dart';

class Detailer extends StatefulWidget {
  const Detailer({super.key});

  @override
  State<Detailer> createState() => _DetailerState();
}

class _DetailerState extends State<Detailer> {
  List<dynamic> dataincome = [];
  Map<String, dynamic>? _dataincome;
  num totalAmount = 0;
  num totaltax = 0;
  num totaltaxwithhold = 0;
  IncomeModel? incomeModel;
  List<Map<String, dynamic>> incomeData = [];

  @override
  void initState() {
    super.initState();
    incomeModel = Provider.of<IncomeModel>(context, listen: false);

    incomeData = List<Map<String, dynamic>>.from(incomeModel?.incomeData ?? []);
    _loadincome();
  }

  Future<void> deleteItem(int index, String income_id) async {
    String? userId = await ShareDataUserid.getUserId();
    try {
      final url = Uri.parse('http://localhost:3000/deleteincome/${userId!}');

      final res = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'income_id': income_id,
        }),
      );

      if (res.statusCode == 200) {
        final deletedItem = incomeData[index];
        final amountToRemove =
            num.parse(deletedItem['amount']?.toString() ?? '0');
        final taxWithholdToRemove =
            num.parse(deletedItem['tax_withhold']?.toString() ?? '0');
        await _loadincome();

        setState(() {
          incomeData.removeAt(index);

          totalAmount -= amountToRemove;
          totaltaxwithhold -= taxWithholdToRemove;

          incomeModel?.setincome(totalAmount.toInt());
          incomeModel?.settax_withhold(totaltaxwithhold.toInt());
          incomeModel?.setincomeData(incomeData);
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

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
            totalAmount = 0;
            for (var item in dataincome) {
              totalAmount += item['amount']!;
              totaltaxwithhold += item['tax_withhold']!;
            }

            print(dataincome);
            incomeModel?.setincome(totalAmount as int?);
            incomeModel?.setincomeData(dataincome);
            incomeModel?.settax_withhold(totaltaxwithhold as int?);
            incomeData = List<Map<String, dynamic>>.from(dataincome);
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
      String currentIncome, String currentTax, String income_id) {
    final incomeController = TextEditingController(text: currentIncome);
    final taxController = TextEditingController(text: currentTax);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            currentTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: incomeController,
                decoration: InputDecoration(
                  labelText: "Income",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12),
              TextField(
                controller: taxController,
                decoration: InputDecoration(
                  labelText: "ภาษีหัก ณ ที่จ่าย",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.money_off),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                final newIncome = incomeController.text;
                final newTax = taxController.text;

                print('$newTax $newIncome ddd $income_id');
                updateincomeData(newIncome, newTax, income_id);
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

  Future<void> updateincomeData(
      String income, String tax, String income_id) async {
    final url =
        Uri.parse('http://localhost:3000/updateincome/${int.parse(income_id)}');

    try {
      final res = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': income,
          'tax_withhold': tax,
        }),
      );

      if (res.statusCode == 200) {
        print("Income updated successfully");
        await _loadincome();
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
            "Income",
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
                  Boxbalance(
                      "ภาษีที่ต้องจ่ายประจำปี", totalAmount.toString() ?? "0"),
                  incomeData.isEmpty
                      ? Center(
                          child: Center(
                          child: Container(
                            child: Text("ไม่มีข้อมูล"),
                          ),
                        ))
                      : Expanded(
                          child: ListView.builder(
                            itemCount: incomeData.length,
                            itemBuilder: (context, index) {
                              final item = incomeData[index];
                              return paymentCard(
                                title: item['type_value']?.toString() ??
                                    'ไม่มีชื่อ',
                                income: '฿${item['amount'] ?? 0}',
                                tax: '฿${item['tax_withhold'] ?? 0}',
                                onDelete: () {
                                  if (item['income_id'] != null) {
                                    deleteItem(
                                        index, item['income_id'].toString());
                                  } else {
                                    print("income_id is null");
                                  }
                                },
                                onDetail: () {},
                                onEdit: () {
                                  showEditDialog(
                                      context,
                                      item['type_value']?.toString() ??
                                          'แก้ไขข้อมูล',
                                      '${item['amount'] ?? 0}',
                                      '${item['tax_withhold'] ?? 0}',
                                      item['income_id'].toString());
                                },
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            btnincome(context, 'รายได้ ก้อนใหม่'),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget Boxbalance(String title, String value) {
    return Container(
        padding: EdgeInsets.all(50),
        margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
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
            value,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFceff6a)),
          ),
        ]));
  }

  Widget paymentCard({
    required String title,
    required String income,
    required String tax,
    required VoidCallback onDelete,
    required VoidCallback onDetail,
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
            income,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("รายได้", style: TextStyle(fontSize: 14)),
              Text(income, style: TextStyle(fontSize: 14)),
            ],
          ),
          Divider(height: 24),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("ภาษีหัก ณ ที่จ่าย", style: TextStyle(fontSize: 14)),
              Text(tax, style: TextStyle(fontSize: 14)),
            ],
          ),
          Divider(height: 24),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  MaterialPageRoute(builder: (context) => const incomepage()),
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
