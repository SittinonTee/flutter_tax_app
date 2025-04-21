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

        print('✅ Add income success');
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
              onPressed: () {
                Navigator.pushNamed(
                    context, '/home'); // หรือ Navigator.popUntil(...)
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
          width: double.infinity,
          height: double.infinity,
          color: Colors.amberAccent,
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  width: double.infinity,
                  color: Colors.blueAccent,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(50),
                          child: Column(
                            children: [
                              Text(
                                "รายได้",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("(ก่อนถูกหักภาษี)"),
                              Text(displayTax),
                              Text("ต่อปี"),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          color: Colors.deepOrange,
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
                                onPressed: () =>
                                    onNumberPressed((index + 1).toString()),
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(fontSize: 40),
                                ),
                              );
                            } else if (index == 9) {
                              return ElevatedButton(
                                onPressed: onACPressed,
                                child: Text(
                                  "AC",
                                  style: TextStyle(fontSize: 40),
                                ),
                              );
                            } else if (index == 10) {
                              return ElevatedButton(
                                onPressed: () => onNumberPressed("0"),
                                child: Text(
                                  "0",
                                  style: TextStyle(fontSize: 40),
                                ),
                              );
                            } else if (index == 11) {
                              return ElevatedButton(
                                onPressed: onDeletePressed,
                                child: Icon(Icons.backspace, size: 40),
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
