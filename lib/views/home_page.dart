import 'package:flutter/material.dart';

import '../widget/custom_bottom_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Back", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildBlueButton("First Grade"),
            const SizedBox(height: 15),
            buildBlueButton("Arabic"),
            const SizedBox(height: 20),
            buildGrayBox("Arabic", Icons.article),
            const SizedBox(height: 20),
            buildGrayBox("Task", Icons.assignment),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }

  Widget buildBlueButton(String text) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1265ae),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {},
    child: Text(
    text,
    style: const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white, // ✅ ده السطر اللي هيخلي النص أبيض
    ),
    )));

  }

  Widget buildGrayBox(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 90,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 40),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(fontSize: 18)),
          const Spacer(),
          const Icon(Icons.download, size: 35),
        ],
      ),
    );
  }

}
