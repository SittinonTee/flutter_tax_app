import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3), // สีหม่น
                blurRadius: 15, // ความเบลอของเงา
                spreadRadius: 3, // กระจายออก
                offset: Offset(0, 5), // ตำแหน่งเงา
              ),
            ],
            borderRadius: BorderRadius.circular(15), // ขอบมน
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15), // ตัดรูปให้ขอบโค้งตามกรอบ
            child: Image.asset(
              'assets/images/tax2.jpeg',
              width: 500,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
