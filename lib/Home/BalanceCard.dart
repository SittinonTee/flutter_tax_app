// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class BalanceCard extends StatefulWidget {
//   const BalanceCard({super.key});

//   @override
//   State<BalanceCard> createState() => _BalanceCardState();
// }

// class _BalanceCardState extends State<BalanceCard> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   Future<void> _loadData() async {
//     try {
//       final url = Uri.parse('http://localhost:3000/Getdata');

//       final res = await http.get(
//         url,
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body);
//         print('✅ Get data success: $data');
//       } else {
//         print('❌ Error: ${res.statusCode}');
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: 380,
//       padding: const EdgeInsets.all(20),
//       margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center, // ✅ จัดกลางแนวตั้ง
//           crossAxisAlignment: CrossAxisAlignment.center, // ✅ จัดกลางแนวนอน
//           children: [
//             const Text(
//               'ภาษีที่ต้องจ่าย',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               '฿23,500.34',
//               style: TextStyle(
//                 color: Color(0xFFceff6a),
//                 fontSize: 50,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const Text(
//               'คุณมีโอกาสทำเพิ่มอีก ฿ 0',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 SizedBox(
//                   width: 100,
//                   height: 100,
//                   child: CircularProgressIndicator(
//                     value: 0.5,
//                     strokeWidth: 8,
//                     backgroundColor: Colors.grey[800],
//                     valueColor:
//                         const AlwaysStoppedAnimation<Color>(Color(0xFFceff6a)),
//                   ),
//                 ),
//                 const Text(
//                   '50%',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 30),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(25),
//               ),
//               child: const Text(
//                 'ได้สิทธิ์ลดหย่อนไปแล้ว',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
