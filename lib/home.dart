import 'package:eclipce_app/bottom/bottom_favorite.dart';
import 'package:eclipce_app/bottom/bottom_home.dart';
import 'package:eclipce_app/bottom/bottom_profile.dart';
import 'package:eclipce_app/bottom/bottom_search.dart';
import 'package:eclipce_app/database/auth.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  final screens = [
    BottomHomePage(),
    BottomSearchPage(),
    BottomFavoritePage(),
    BottomProfilePage(),
  ];
  AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await _authService.logOut();
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              Navigator.popAndPushNamed(context, '/');
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: screens.elementAt(index),
      bottomNavigationBar: SalomonBottomBar(
        selectedItemColor: Colors.deepPurple,
        currentIndex: index,
        onTap: (p0) {
          setState(() {
            index = p0;
          });
        },
        items: [
          SalomonBottomBarItem(icon: Icon(Icons.home), title: Text('Home')),
          SalomonBottomBarItem(icon: Icon(Icons.search), title: Text('Search')),
          SalomonBottomBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Favorite'),
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
      ),
    );
  }
}
