import 'package:flutter/material.dart';
import '../Income/incom.dart';
import 'package:flutter_tax_app/userdatamodel.dart';
import 'package:provider/provider.dart';

class Boxcontent extends StatefulWidget {
  final String user_id;
  final String username;

  const Boxcontent({super.key, required this.user_id, required this.username});

  // final String hh;

  @override
  State<Boxcontent> createState() => _BoxcontentState();
}

class _BoxcontentState extends State<Boxcontent> {
  IncomeModel? incomeModel;

  @override
  void initState() {
    super.initState();
    print(widget.user_id);
    incomeModel = Provider.of<IncomeModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          _buildCategoryCard('รายได้', '${incomeModel?.total_amount}',
              Icons.account_balance_wallet),
          const SizedBox(height: 30),
          _buildCategoryCard('ลดหย่อนภาษี', '', Icons.savings),
          const SizedBox(height: 30),
          _buildCategoryCard('ลดหย่อนภาษี', '', Icons.savings),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, String value, IconData icon) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFFceff6a),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(1),
                width: 2),
          ),
          alignment: Alignment.topLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 70,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 0, 0),
              // borderRadius: const BorderRadius.only(
              //   topRight: Radius.circular(30),
              //   topLeft: Radius.circular(30),
              //   bottomLeft: Radius.circular(30),
              //   bottomRight: Radius.circular(30),
              // ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    size: 40,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'รายได้ปี 2566',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      value,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFFceff6a),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => incomepage(
                                user_id: widget.user_id,
                                username: widget.username,
                              ))),
                  icon: const Icon(Icons.add_circle,
                      color: Colors.white, size: 50),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
