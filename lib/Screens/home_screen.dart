import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe_ship/Screens/cart_screen.dart';
import 'package:safe_ship/Screens/products_screen.dart';
import 'package:safe_ship/Screens/profile_page.dart';
import 'map_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  List<Widget> body = const [
    ProductsScreen(),
    CartScreen(),
    MapScreen(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Scaffold(
        body: Center(
          child: body[_currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int newIndex) {
            setState(() {
              _currentIndex = newIndex;
            });
          },
          items: const [
            BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                backgroundColor: Colors.grey),
            BottomNavigationBarItem(
                label: 'cart',
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.black,
                ),
                backgroundColor: Colors.grey),
            BottomNavigationBarItem(
                label: 'tracking',
                icon: Icon(
                  Icons.map,
                  color: Colors.black,
                ),
                backgroundColor: Colors.grey),
            BottomNavigationBarItem(
                label: 'profile',
                icon: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                ),
          ],
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed
        ),
      ),
    );
  }
}
