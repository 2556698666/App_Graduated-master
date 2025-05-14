import 'package:flutter/material.dart';
import '../widget/custom_bottom_bar.dart';
import 'create_class_page.dart';
import 'search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Back', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 50),
          SizedBox(
            width: 400,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xff1265ae),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'first grade',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: const [
                  SizedBox(
                    width: 150,
                    child: SizedBox(
                      height: 50,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xff1265ae),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text('Ahmed',
                              style: TextStyle(color: Colors.white, fontSize: 25)),
                        ),
                      ),
                    ),
                  ),
                  Icon(Icons.menu_book, size: 100),
                  Text('Arabic',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
                  SizedBox(height: 15),
                  Icon(Icons.assignment, size: 100),
                  Text('Class\nperformance', style: TextStyle(fontSize: 22)),
                  SizedBox(height: 15),
                  Icon(Icons.assignment, size: 100),
                  Text('Home\nperformance', style: TextStyle(fontSize: 22)),
                ],
              ),
              Column(
                children: const [
                  SizedBox(
                    width: 150,
                    child: SizedBox(
                      height: 50,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xff1265ae),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text('Arabic',
                              style: TextStyle(color: Colors.white, fontSize: 25)),
                        ),
                      ),
                    ),
                  ),
                  Icon(Icons.group, size: 100),
                  Text('student',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
                  SizedBox(height: 15),
                  Icon(Icons.assignment, size: 100),
                  Text('Monthly\nassessmwnt', style: TextStyle(fontSize: 22)),
                  SizedBox(height: 15),
                  Icon(Icons.assignment, size: 100),
                  Text('Weekly\nperformance', style: TextStyle(fontSize: 22)),
                ],
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: CustomBottomBar(),
      ),
    );
  }
}
