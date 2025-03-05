import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'transaction_screen.dart';
import 'log_screen.dart';
import 'warehouse_screen.dart'; 
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; 

  final List<Widget> _screens = [
    const HomeScreen(), 
    const LogScreen(), 
    const TransactionScreen(),
    const WarehouseScreen(), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, 
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Logs"),
          BottomNavigationBarItem(icon: Icon(Icons.sync), label: "Transactions"),
          BottomNavigationBarItem(icon: Icon(Icons.warehouse), label: "Warehouse"), 
        ],
      ),
    );
  }
}
