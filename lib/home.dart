import 'package:auth/simple_signin_screen.dart';
import 'package:auth/sso_signin_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController = PageController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          SimpleSignInScreen(),
          SSOSignInScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: 'Simple',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.vpn_lock),
            label: 'SSO',
          ),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
            pageController.jumpToPage(index);
          });
        },
      ),
    );
  }
}
