import 'package:flutter/material.dart';

class customTextField extends StatelessWidget {
  const customTextField({
    super.key,
    required this.text1,
    required this.text2,
    required this.validH,
    required this.validV,
    this.enabled = true,
  });

  final double validH;
  final double validV;
  final String text1;
  final String text2;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: validH, vertical: validV),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text1,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 8),
          TextField(
            enabled: enabled,
            controller: TextEditingController(text: text2),
            style: const TextStyle( // ✅ هنا خلي النص غامق
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
