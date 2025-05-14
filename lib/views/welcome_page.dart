import 'package:flutter/material.dart';
import 'home_page.dart';
import 'login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Illustration (replace with your asset if needed)
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Image.asset(
                      'assets/boy.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: Text(
                        'School\nHub',
                        style: TextStyle(
                          color: Color(0xFF1976D2),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              const Text(
                'Learn With Us Easily',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Text(
                'We help you remember,learn and review your study tasks.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');


                  },

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