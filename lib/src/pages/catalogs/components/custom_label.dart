import 'package:flutter/material.dart';

class CustomLabel extends StatelessWidget {
  const CustomLabel(this.label, this.description, {super.key});

  final String label;
  final String description;
  //Size? deviceSize = 100.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Text(
        //   '$label: ',
        //   style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        // ),
        SizedBox(
          //width: 230,
          child: Text(
            description,
            style: const TextStyle(fontSize: 11),
          ),
        ),
      ],
    );
  }
}
