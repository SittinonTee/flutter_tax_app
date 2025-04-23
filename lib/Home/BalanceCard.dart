import 'package:flutter/material.dart';
import 'package:flutter_tax_app/Income/incom.dart';
import 'package:flutter_tax_app/userdatamodel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key, required this.percentage});

  final num percentage;
  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  IncomeModel? incomeModel;

  @override
  void initState() {
    super.initState();
    incomeModel = Provider.of<IncomeModel>(context, listen: false);
  }

  // Future<void> getdata() async {}

  @override
  Widget build(BuildContext context) {
    final percentage = widget.percentage;
    // final amount = incomeModel?.total_amount ?? 0;
    // final tax = incomeModel?.total_tax ?? 0;
    // final taxWithhold = incomeModel?.total_tax_withhold ?? 0;
    final paytax = incomeModel?.paytax ?? 0;

    final formatter = NumberFormat('#,###');
    final formattedpaytax = formatter.format(paytax);

    return Container(
      width: double.infinity,
      height: 380,
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'ภาษีที่ต้องจ่าย',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Noto Sans Thai',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              formattedpaytax.toString(),
              style: TextStyle(
                color: Color(0xFFceff6a),
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'อัตราภาษีที่ต้องจ่าย',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey[800],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFFceff6a)),
                  ),
                ),
                Text(
                  '${percentage}%',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'ได้สิทธิ์ลดหย่อนไปแล้ว',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
