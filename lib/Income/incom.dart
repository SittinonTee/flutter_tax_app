import 'package:flutter/material.dart';

class incomepage extends StatefulWidget {
  const incomepage({super.key});

  @override
  State<incomepage> createState() => _incomepageState();
}

class _incomepageState extends State<incomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),
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
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 41, 59, 222)),
                child: Column(children: [
                  Container(
                      // padding: const EdgeInsets.all(10.0),
                      child: Row(
                    children: [
                      Expanded(
                          child: Incomecrad(
                              "ddd", "ddd", Icons.account_balance_wallet)),
                      Expanded(
                          child: Incomecrad(
                              "ddd", "ddd", Icons.account_balance_wallet))
                    ],
                  )),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                            child: Incomecrad(
                                "ddd", "ddd", Icons.account_balance_wallet)),
                        Expanded(
                            child: Incomecrad(
                                "ddd", "ddd", Icons.account_balance_wallet))
                      ],
                    ),
                  ),
                  Container(
                      child: Row(
                    children: [
                      Expanded(
                          child: Incomecrad(
                              "ddd", "ddd", Icons.account_balance_wallet)),
                      Expanded(
                          child: Incomecrad(
                              "ddd", "ddd", Icons.account_balance_wallet))
                    ],
                  ))
                ]))
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
    );
  }
}

class Incomecrad {}
