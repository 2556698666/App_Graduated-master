import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Back',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Search'),
                      content: TextField(
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'Type your search here...',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (value) {
                          // You can handle the search logic here
                          print('Search submitted: $value');
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                },
                child: Container(
                  width: screenWidth * 0.9,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xff1265ae),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: const [
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'Search...',
                          style: TextStyle(color: Colors.grey, fontSize: 22),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.search, size: 30, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                'Categories',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/icon.jpg',
              width: screenWidth * 0.9,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Text(
              'What are you looking for?',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
