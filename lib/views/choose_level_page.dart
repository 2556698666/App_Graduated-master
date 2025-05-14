import 'package:flutter/material.dart';

class ChooseLevelPage extends StatefulWidget {
  const ChooseLevelPage({Key? key}) : super(key: key);

  @override
  State<ChooseLevelPage> createState() => _ChooseLevelPageState();
}

class _ChooseLevelPageState extends State<ChooseLevelPage> {
  int? _selectedGrade;

  final List<String> grades = [
    'First Grade',
    'Second Grade',
    'Third Grade',
    'Fourth Grade',
    'Fifth Grade',
    'Sixth Grade',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    onPressed: () {
                      Navigator.of(context).maybePop();
                    },
                  ),
                  const Text(
                    'Back',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Center(
                child: Text(
                  'Choose Your Level !',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Primary School',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...List.generate(grades.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: SizedBox(
                          width: 260,
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _selectedGrade = index;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: _selectedGrade == index ? const Color(0xFF1976D2) : Colors.blue,
                                width: 2,
                              ),
                              backgroundColor: _selectedGrade == index ? const Color(0xFFE3F0FB) : Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              grades[index],
                              style: TextStyle(
                                color: const Color(0xFF1976D2),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedGrade != null ? () {
                    // Navigation to HomePage removed as it no longer exists.
                    // You can add navigation to another page here if needed.
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}