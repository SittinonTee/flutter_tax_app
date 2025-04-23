import 'dart:convert';
// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_tax_app/Home/Home.dart';
import 'package:flutter_tax_app/userdatamodel.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tax_app/Share_data/Share-data.dart';

class Withholding_tax extends StatefulWidget {
  Withholding_tax(
      {super.key,
      required this.type,
      required this.data,
      required this.income});

  final String type;
  final String data;
  int income;

  @override
  State<Withholding_tax> createState() => _Withholding_taxState();
}

class _Withholding_taxState extends State<Withholding_tax> {
  // late UserModel userModel;

  @override
  void initState() {
    super.initState();
    print(widget.income);
    // userModel = Provider.of<UserModel>(context, listen: false);
  }

  Future<bool> addincome() async {
    String? userId = await ShareDataUserid.getUserId();
    try {
      final url = Uri.parse('http://localhost:3000/addincome');

      // final userModel = Provider.of<UserModel>(context, listen: false);

      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': int.parse(userId!),
          'amount': widget.income,
          'tax_withhold': int.parse(displayTax),
          'income_type': widget.type,
          'type_value': widget.data,
        }),
      );

      if (res.statusCode == 200) {
        print(res.body);

        print('Add income success');
        await checkypetax();

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

  Future<void> checkypetax() async {
    // print("Get data request started");

    String? userId = await ShareDataUserid.getUserId();

    try {
      final url =
          Uri.parse('http://localhost:3000/checktypetax/${int.parse(userId!)}');

      final res = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        if (data['success']) {
          await addtax();
        }
      } else {
        print(' Error fetching data: ${res.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<bool> addtax() async {
    String? userId = await ShareDataUserid.getUserId();
    try {
      final url = Uri.parse('http://localhost:3000/addtax');
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': int.parse(userId!),
          'tax': 60000,
          'tax_type': "คุณ และ ครอบครัว",
          'type_value': "ค่าลดหย่อนส่วนตัว",
        }),
      );

      if (res.statusCode == 200) {
        print(res.body);

        return true;
      }
      return false;
    } catch (e) {
      print(' Error: $e');
      return false;
    }
  }

  String displayTax = "";

  void onNumberPressed(String number) {
    setState(() {
      displayTax += number;
    });
  }

  void onDeletePressed() {
    setState(() {
      if (displayTax.isNotEmpty) {
        displayTax = displayTax.substring(0, displayTax.length - 1);
      }
    });
  }

  void onACPressed() {
    setState(() {
      displayTax = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.type;
    final data = widget.data;
    int income = widget.income;

    return Scaffold(
        appBar: AppBar(
          title: Text(type),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const ui.Size.fromHeight(1.0),
            child: Container(
              color: Colors.grey,
              height: 1.0,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {{
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyApp(),
                    ),
                  );
                };
              },
              child: const Text(
                'Home',
                style:
                    TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
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
                                "ภาษีหัก ณ ที่จ่าย",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "(ก่อนถูกหักภาษี)",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "฿$displayTax",
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
                          color: const Color.fromARGB(255, 255, 255, 255),
                          margin: EdgeInsets.all(20),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color.fromARGB(255, 170, 222, 112),
                                border:
                                    Border.all(color: Colors.black, width: 2)),
                            child: Center(
                                child: InkWell(
                              onTap: displayTax.isEmpty
                                  ? null
                                  : () async {
                                      bool success = await addincome();
                                      if (success) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MyApp(),
                                          ),
                                        );
                                      }
                                    },
                              child: Text(
                                "Done",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            )),
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
