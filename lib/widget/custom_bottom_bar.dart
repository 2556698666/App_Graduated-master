import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/Access_Denied_Page.dart';
import '../views/create_class_page.dart';
import '../views/home_page.dart';
import '../views/profile_page.dart';
import '../views/search_page.dart';

class CustomBottomBar extends StatefulWidget {
  final int currentIndex;

  const CustomBottomBar({super.key, this.currentIndex = 0});

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        if (widget.currentIndex != 0) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomePage()));
        }
        break;
      case 1:
        if (widget.currentIndex != 1) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const SearchPage()));
        }
        break;
      case 2:
        if (widget.currentIndex != 2) {
          _navigateToCreateClassOrDenied(context);
        }
        break;
      case 4:
        if (widget.currentIndex != 4) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const ProfilePage()));
        }
        break;
      default:
        break;
    }
  }

  void _navigateToCreateClassOrDenied(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');

    if (role == 'teacher') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CreateClass()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AccessDeniedPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF1976D2).withOpacity(0.15),
          selectedItemColor: const Color(0xFF1976D2),
          unselectedItemColor: Colors.black,
          currentIndex: widget.currentIndex,
          onTap: (index) => _onItemTapped(context, index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.check_box), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.add_box), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          ],
        ),
      ),
    );
  }
}

