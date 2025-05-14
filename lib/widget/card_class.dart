import 'package:flutter/material.dart';

class CardClass extends StatelessWidget {
  const CardClass({super.key, required this.text3});
  final String text3;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 280,
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xff1265ae),
            ),
            child: Center(
              child: Text(
              text3,
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
          ),
        ),
        Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: Color(0xffdfe1e7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.add, size: 35),
    ),
      ],
    );
    
  }
}
