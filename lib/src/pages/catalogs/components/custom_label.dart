import 'package:flutter/material.dart';

class CustomLabel extends StatelessWidget {
  const CustomLabel(
      {super.key,
      required this.label,
      required this.description,
      this.customWidth});

  final String label;
  final String description;
  final double? customWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: customWidth ?? customWidth,
          child: Text(description, style: const TextStyle(fontSize: 11)),
        ),
      ],
    );
  }
}
