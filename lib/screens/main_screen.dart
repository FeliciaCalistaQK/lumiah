import 'package:flutter/material.dart';
import 'package:skin_match/screens/explore_screen.dart';
import 'package:skin_match/screens/home_screen.dart';
import 'package:skin_match/screens/favorite_screen.dart';
import 'package:skin_match/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static List<Widget> _screenOptions = <Widget>[
    HomeScreen(),
    const ExploreScreen(),
    const FavoriteScreen(),
    const ProfileScreen(),
   
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screenOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          //item pertama
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Home'),
          //item kedua
          BottomNavigationBarItem(
              icon: Icon(Icons.explore), label: 'explore'),
          //item ketiga
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorite'),
          //item keempat
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.pink.shade200,
        backgroundColor: Colors.white,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.pink.shade400,
        ),
        unselectedLabelStyle: TextStyle(
          color: Colors.pink.shade200,
        ),
      ),
    );
  }
}
