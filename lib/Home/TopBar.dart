// import 'package:flutter/material.dart';

// class Topbar extends StatefulWidget {
//   const Topbar({super.key, this.user_id, this.username});

//   final String? user_id;
//   final String? username;

//   @override
//   State<Topbar> createState() => _TopbarState();
// }

// class _TopbarState extends State<Topbar> {
//   @override
//   Widget build(BuildContext context) {
//     final String? user_id = widget.user_id;
//     final String? username = widget.username;

//     return Padding(
//       // padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
//       padding: const EdgeInsets.all(20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             height: 50,
//             width: 180,
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.black,
//               borderRadius: BorderRadius.circular(50),
//             ),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 '$user_id, $username',
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20),
//               ),
//             ),
//           ),
//           Container(
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//               color: Colors.black,
//               borderRadius: BorderRadius.circular(50),
//             ),
//             child: const Icon(Icons.person, size: 40, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }
// }
