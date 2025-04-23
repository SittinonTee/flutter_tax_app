
import 'package:flutter/material.dart';
import 'package:flutter_tax_app/%C2%A0Tax/Tax.dart';
import 'package:flutter_tax_app/Income/incom.dart';
class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  @override

  Widget build(BuildContext context) {
    return Center();
  }
}

void showEditDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titlePadding: EdgeInsets.fromLTRB(24, 24, 24, 12),
        title: Text(
          "เพิ่มรายได้ / ค่าลดหย่อน",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.attach_money, color: Colors.green),
                title: Text("รายได้", style: TextStyle(color: Colors.black87)),
                onTap: () => selectPage(context, "1"),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.savings, color: Colors.green),
                title: Text("ค่าลดหย่อน", style: TextStyle(color: Colors.black87)),
                onTap: () => selectPage(context, "2"),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> selectPage(BuildContext context, String pageNum) async {
  print(pageNum);
  if (pageNum == "1") {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => incomepage()),
    );
  } else if (pageNum == "2") {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Taxpage()),
    );
  }
}
