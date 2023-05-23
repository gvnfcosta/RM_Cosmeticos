import 'package:flutter/material.dart';
import 'package:rm/src/utils/app_routes.dart';

import 'base_screen.dart';

class InitialScreen extends StatelessWidget {
  InitialScreen({super.key});

  bool isAdmin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(220),
      //App bar
      appBar: AppBar(
        backgroundColor: Colors.pink.shade200,
        centerTitle: true,
        elevation: 0,
        title: Image.asset('assets/images/LogoRM.png'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () =>
              Navigator.of(context).pushReplacementNamed(AppRoutes.baseScreen),
          child: const Text("VOLTAR"),
        ),
      ),
    );
  }
}
