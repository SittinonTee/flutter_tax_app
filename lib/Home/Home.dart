import 'package:flutter/material.dart';
import 'package:flutter_tax_app/Home/BalanceCard.dart';
import 'package:flutter_tax_app/Home/Boxcontent.dart';
import 'TopBar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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


  final List<Widget> _pages = [
    const Homepage(),
    const ChartPage(),
    const AddPage(),
    const NotificationsPage(),
    const MorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          children: [
            const Topbar(),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: IndexedStack(
                  index: _selectedIndex,
                  children: _pages,
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildBottomNavigationBar() {
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
          _buildNavItem(Icons.notifications, 3),
          _buildNavItem(Icons.more_horiz, 4),
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
      child: IconButton(
        icon: const Icon(
          Icons.add,
          color: Colors.black,
          size: 30,
        ),
        onPressed: () {
          setState(() {
            _selectedIndex = 2; // ตั้งค่าให้เป็นหน้า AddPage
          });
        },
      ),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BalanceCard(), // ส่วน BalanceCard
        SizedBox(
          height: 60,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: const Text(
                "รายการ", // ข้อความ "รายการ"
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const Boxcontent(), // ส่วน Boxcontent
      ],
    );
  }
}

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

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

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Notifications Page",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "More Page",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_circle, size: 100, color: Color(0xFFceff6a)),
          const SizedBox(height: 20),
          const Text(
            "Add New Content",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              // ทำงานเมื่อกดปุ่ม
            },
            child: const Text(
              "เพิ่มรายการ",
              style: TextStyle(fontSize: 18, color: Color(0xFFceff6a)),
            ),
          ),
        ],
      ),
    );
  }
}
