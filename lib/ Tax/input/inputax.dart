import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tax_app/Home/Home.dart';
import 'package:flutter_tax_app/Income/input/Withholding_tax.dart';
import 'package:flutter_tax_app/Share_data/Share-data.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';

class InputTax extends StatefulWidget {
  // const Inputincome({super.key});

  const InputTax(
      {super.key,
      required this.type,
      required this.data,
      required this.maxAmount});

  final String type;
  final String data;
  final int maxAmount;

  @override
  State<InputTax> createState() => _InputTaxState();
}

class _InputTaxState extends State<InputTax> {
  String displayText = "";
  int tax = 0;
  final formatter = NumberFormat('#,###');

  void onNumberPressed(String number) {
    setState(() {
      String raw = displayText.replaceAll(',', '') + number;
      tax = int.tryParse(raw) ?? 0;

      displayText = formatter.format(tax);
    });
  }

  void onDeletePressed() {
    setState(() {
      String raw = displayText.replaceAll(',', '');

      if (raw.isNotEmpty) {
        raw = raw.substring(0, raw.length - 1);
        tax = int.tryParse(raw) ?? 0;
        displayText = raw.isEmpty ? "" : formatter.format(tax);
      }
    });
  }

  void onACPressed() {
    setState(() {
      displayText = "";
      tax = 0;
    });
  }

  Future<bool> addtax() async {
    String? userId = await ShareDataUserid.getUserId();
    try {
      final url = Uri.parse('http://localhost:3000/addtax');

      // final userModel = Provider.of<UserModel>(context, listen: false);

      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': int.parse(userId!),
          'tax': tax,
          'tax_type': widget.type,
          'type_value': widget.data,
        }),
      );

      if (res.statusCode == 200) {
        print(res.body);

        print('✅ Add tax success');
        return true;
      } else {
        print('❌ Failed to add income: ${res.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.type;
    final data = widget.data;
    int maxAmount = widget.maxAmount;
    print('$type $data  $maxAmount');

    final formatter = NumberFormat('#,###');
    String formattedAmount = formatter.format(maxAmount);

    print("จำนวนเงินต้องไม่เกิน $formattedAmount บาท");

    //  int income = 0;
    // int tax = 0;

    // int s = income;

    return Scaffold(
        appBar: AppBar(
          title: Text(type),
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
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(),
                  ),
                );
              },
              child: const Text(
                'Home',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  width: double.infinity,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(50),
                          child: Column(
                            children: [
                              Text(
                                "จำนวนเงิน",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "฿$displayText",
                                style: TextStyle(
                                  fontSize: 36,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "ต่อปี",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Container(
                                child: Text(
                                  "จำนวนเงินต้องไม่เกิน $formattedAmount บาท",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color:
                                          const Color.fromARGB(255, 255, 0, 0)),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 170, 222, 112),
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: Colors.black, width: 2)),
                                child: Center(
                                    child: InkWell(
                                  onTap: displayText.isEmpty
                                      ? null
                                      : () async {
                                          if (tax > maxAmount) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  backgroundColor: Colors.white,
                                                  title: Text(
                                                    "⚠️ คำเตือน",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Colors.redAccent,
                                                    ),
                                                  ),
                                                  content: Text(
                                                    "จำนวนต้องไม่เกิน $formattedAmount บาท",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[800],
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        foregroundColor:
                                                            Colors.white,
                                                        backgroundColor:
                                                            Colors.redAccent,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20,
                                                                vertical: 10),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                      ),
                                                      child: Text("ตกลง"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            bool success = await addtax();
                                            if (success) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => MyApp(),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                  child: Text(
                                    "Next",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.8,
                          ),
                          itemCount: 12,
                          itemBuilder: (context, index) {
                            if (index < 9) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                onPressed: () =>
                                    onNumberPressed((index + 1).toString()),
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                              );
                            } else if (index == 9) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                onPressed: onACPressed,
                                child: Text(
                                  "AC",
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                              );
                            } else if (index == 10) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                onPressed: () => onNumberPressed("0"),
                                child: Text(
                                  "0",
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                              );
                            } else if (index == 11) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 61, 170, 212),
                                ),
                                onPressed: onDeletePressed,
                                child: Icon(Icons.backspace,
                                    size: 30,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              );
                            }
                            return null;
                          },
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
}
