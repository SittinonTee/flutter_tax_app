import 'package:flutter/material.dart';

class Sumary extends StatefulWidget {
  const Sumary({super.key});

  @override
  State<Sumary> createState() => _SumaryState();
}

class _SumaryState extends State<Sumary> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Chart Page",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
