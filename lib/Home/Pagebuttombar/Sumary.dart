import 'package:flutter/material.dart';

class Sumary extends StatefulWidget {
  const Sumary({super.key});

  @override
  State<Sumary> createState() => _SumaryState();
}

class _SumaryState extends State<Sumary> {
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
                  Boxsumary("จ่ายภาษีเพิ่ม", "฿123456.98"),
                  Boxcontenter(
                    title1: "รายได้",
                    value1: "3000000",
                    title2: "ค่าใช้จ่าย",
                    value2: "1000000",
                    title3: "ค่าใช้จ่าย",
                    value3: "1000000",
                    title4: "ค่าใช้จ่าย",
                    value4: "1000000",
                  ),
                  Boxcontenter(
                    title1: "ค่าภาษี",
                    value1: "3000000",
                    title2: "ภาษี ณ ที่หักจ่าย",
                    value2: "1000000",
                    title3: "เครดิตภาษี",
                    value3: "1000000",
                    title4: "จ่ายภาษีเพิ่ม",
                    value4: "1000000",
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
      padding: EdgeInsets.all(40),
      margin: EdgeInsets.all(20),
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

         Divider(height: 24), // ขีดเส้น

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
    {required String title1,
    required String title2,
    required String title3,
    required String title4,
    required String value1,
    required String value2,
    required String value3,
    required String value4}) {
  return Container(
    padding: EdgeInsets.all(15),
    margin: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color.fromARGB(232, 230, 229, 229),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        // ------------------------------------------------------------แถวที่1
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title1,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("฿$value1", style: TextStyle(fontSize: 16)),
          ],
        ),
        Divider(height: 24), // ขีดเส้น

        SizedBox(height: 12),
        // ------------------------------------------------------------แถวที่2
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title2,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("฿$value2", style: TextStyle(fontSize: 16)),
          ],
        ),
        Divider(height: 24), // ขีดเส้น

        SizedBox(height: 12),
        // ------------------------------------------------------------แถวที่3
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title3,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("฿$value3", style: TextStyle(fontSize: 16)),
          ],
        ),
        Divider(height: 24), // ขีดเส้น

        SizedBox(height: 12),
        // ------------------------------------------------------------แถวที่4
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title4, style: TextStyle(fontSize: 16)),
            Text("฿$value4",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    ),
  );
}
