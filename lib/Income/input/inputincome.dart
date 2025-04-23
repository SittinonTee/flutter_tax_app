import 'package:flutter/material.dart';
import 'package:flutter_tax_app/Home/Home.dart';
import 'package:flutter_tax_app/Income/input/Withholding_tax.dart';

class Inputincome extends StatefulWidget {
  // const Inputincome({super.key});

  const Inputincome({super.key, required this.type, required this.data});

  final String type;
  final String data;

  @override
  State<Inputincome> createState() => _InputincomeState();
}

class _InputincomeState extends State<Inputincome> {
  String displayText = "";
  int income = 0;

  void onNumberPressed(String number) {
    setState(() {
      displayText += number;
    });
  }

  void onDeletePressed() {
    setState(() {
      if (displayText.isNotEmpty) {
        displayText = displayText.substring(0, displayText.length - 1);
      }
    });
  }

  void onACPressed() {
    setState(() {
      displayText = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.type;
    final data = widget.data;
    //  int income = 0;
    // int tax = 0;

    int s = income;

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
              onPressed: () {
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
                              Text(displayText),
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
                              onTap: displayText.isEmpty
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Withholding_tax(
                                              type: type,
                                              data: data,
                                              income: int.parse(displayText)),
                                        ),
                                      );
                                    },
                              child: Text(
                                "Next",
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
