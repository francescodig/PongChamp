import 'package:flutter/material.dart';

class CustomSectionheader extends StatelessWidget{
  final String title;

  const CustomSectionheader({
    Key? key,
    required this.title,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Divider(thickness: 1.2, color: Colors.grey),
        ],
      ),
    );
  }
}