import 'package:flutter/material.dart';
import '../Income/incom.dart';
import 'package:flutter_tax_app/Login/Login.dart';

class Detailer extends StatefulWidget {
  const Detailer({super.key});

  @override
  State<Detailer> createState() => _DetailerState();
}

class _DetailerState extends State<Detailer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text("Detailer"),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Boxbalance("ภาษีที่ต้องจ่ายประจำปี", "฿123,500.34"),
                  paymentCard(
                    title: "ค่าประกันสังคม",
                    income: "฿123,500.34",
                    tax: "฿0",
                    onDelete: () {},
                    onDetail: () {},
                  ),
                  paymentCard(
                    title: "ค่าจ้างทั่วไป",
                    income: "฿45,709.99",
                    tax: "฿0",
                    onDelete: () {},
                    onDetail: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            btnincome(context, 'รายได้ ก้อนใหม่'),
            const SizedBox(height: 16), // ช่องว่างเผื่อปุ่มชิดขอบ
          ],
        ),
      ),
    );
  }
}

Widget Boxbalance(String title, String value) {
  return Container(
      padding: EdgeInsets.all(60),
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 77, 77, 77),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255)),
        ),

        Divider(height: 24),  // ขีดเส้น

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
}) {
  return Container(
    padding: EdgeInsets.all(20),
    margin: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 255, 255, 255),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 6,
          offset: Offset(0, 4),
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
        Divider(height: 24), // ขีดเส้น

        SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("ภาษีหัก ณ ที่จ่าย", style: TextStyle(fontSize: 14)),
            Text(tax, style: TextStyle(fontSize: 14)),
          ],
        ),
        Divider(height: 24), // ขีดเส้น

        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: onDelete,
                child: Text(
                  "Delete",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
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
                MaterialPageRoute(builder: (context) => const Login()),
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
