import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text("Home Page", style: TextStyle(fontSize: 20))),
    Center(child: Text("Pesanan", style: TextStyle(fontSize: 20))),
    Center(child: Text("Profile", style: TextStyle(fontSize: 20))),
  ];

  void _onTimeTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext content) {
    return Scaffold(body: _pages[_selectedIndex],
    appBar: PreferredSize(preferredSize: Size.fromHeight(80), child: Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ]
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Dashboard"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
    ),
    ),
    bottomNavigationBar: BottomNavigationBar(currentIndex: _selectedIndex, onTap: _onTimeTapped, items: [
      BottomNavigationBarItem(icon: Icon(Icons.home),
      label: 'Home',
      ),
      BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),
      label: 'Pesanan',
      ),
      BottomNavigationBarItem(icon: Icon(Icons.person),
      label: 'Profile'
      ),
    ],
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.grey,
    ),
    );
  }
}
