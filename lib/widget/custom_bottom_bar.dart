import 'package:flutter/material.dart';
import '../views/create_class_page.dart';
import '../views/home_page.dart';
import '../views/profile_page.dart';
import '../views/search_page.dart';


class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xff1265ae), // الأزرق
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                  );
                },
                child: const Icon(Icons.person, size: 35, color: Colors.black),
              ),

              // 🔔 Notifications with red dot
              Stack(
                children: [
                  const Icon(Icons.notifications, size: 35, color: Colors.black),
                  Positioned(
                    top: 4,
                    right: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),

              // ⬆️ Floating home button
              Container(width: 35), // فراغ مكان الأيقونة في البار

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateClass()),
                  );
                },
                child: const Icon(Icons.check_box, size: 35, color: Colors.black),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchPage()),
                  );
                },
                child: const Icon(Icons.search, size: 35, color: Colors.black),
              ),
            ],
          ),

          // 🏠 Floating home icon
          Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black12, width: 2),
                ),
                child: const Icon(Icons.home, size: 40, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
