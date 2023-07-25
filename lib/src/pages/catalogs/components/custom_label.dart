import 'package:flutter/material.dart';

class CustomLabel extends StatelessWidget {
  CustomLabel(
      {super.key,
      required this.label,
      required this.description,
      this.fontSize,
      this.fontColor,
      this.fontItalic,
      this.customWidth});

  final String label;
  final String description;
  final double? customWidth;
  double? fontSize = 9;
  Color? fontColor;
  FontStyle? fontItalic = FontStyle.italic;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: customWidth ?? customWidth,
          child: Text(description,
              style: TextStyle(
                fontSize: fontSize ?? 12,
                color: fontColor,
                fontStyle: fontItalic ?? FontStyle.normal,
              )),
        ),
      ],
    );
  }
}
