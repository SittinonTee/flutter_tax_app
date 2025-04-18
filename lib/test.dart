import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Kanit',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          children: [
            TopBar(),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    BalanceCard(),
                    SizedBox(
                        height: 60,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                            child: const Text(
                              "รายการ",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )),
                    Boxcontent(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(),
    );
  }

  Widget TopBar() {
    return Padding(
      // padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 50,
            width: 180,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'User',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(Icons.person, size: 40, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget BalanceCard() {
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
          mainAxisAlignment: MainAxisAlignment.center, // ✅ จัดกลางแนวตั้ง
          crossAxisAlignment: CrossAxisAlignment.center, // ✅ จัดกลางแนวนอน
          children: [
            const Text(
              'ภาษีที่ต้องจ่าย',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '฿23,500.34',
              style: TextStyle(
                color: Color(0xFFceff6a),
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'คุณมีโอกาสทำเพิ่มอีก ฿ 0',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: 0.5,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey[800],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFFceff6a)),
                  ),
                ),
                const Text(
                  '50%',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Text(
                'ได้สิทธิ์ลดหย่อนไปแล้ว',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

//=======================================================================================
  Widget Boxcontent() {
    return Expanded(
      child: ListView(
        children: [
          _buildCategoryCard(
              'รายได้', '฿720,000', Icons.account_balance_wallet),
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
                const Icon(Icons.add_circle, color: Colors.white, size: 50),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget BottomNavigationBar() {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 0),
          _buildNavItem(Icons.show_chart, 1),
          _buildAddButton(),
          _buildNavItem(Icons.notifications, 2),
          _buildNavItem(Icons.more_horiz, 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return IconButton(
      icon: Icon(
        icon,
        size: 30,
        color: _selectedIndex == index ? const Color(0xFFceff6a) : Colors.white,
      ),
      onPressed: () {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFceff6a),
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Icon(
        Icons.add,
        color: Colors.black,
        size: 50,
      ),
    );
  }
}
