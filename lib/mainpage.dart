import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_system/models/pet.dart';
import 'package:pet_adoption_system/models/post.dart';


import 'package:pet_adoption_system/screens/home/home_screen.dart';
import 'package:pet_adoption_system/screens/pet/pet.dart';
import 'package:pet_adoption_system/screens/profile/profile.dart';
import 'package:pet_adoption_system/screens/status/status.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

 late final PetData petData;
 late final PostData postData;

class _MainPageState extends State<MainPage> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final List pages = [
    HomeScreen(),
    Pet(),
    Status(),
    const Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        key: _bottomNavigationKey,
        height: 50,
        color: Colors.white,
        backgroundColor: Colors.indigo,
        buttonBackgroundColor: Colors.white,
        items: const [
          Icon(Icons.home, color: Colors.indigo),
          Icon(Icons.pets, color: Colors.indigo),
          Icon(Icons.menu_book, color: Colors.indigo),
          Icon(Icons.person, color: Colors.indigo),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        animationCurve: Curves.fastLinearToSlowEaseIn,
      ),
      body: pages[_page],
    );
  }
}
