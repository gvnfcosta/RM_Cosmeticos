import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/pages/initial/initial_screen.dart';
import '../../models/auth.dart';
import '../initial/base_screen.dart';
import 'sign_in_screen.dart';

class AuthOrHomePage extends StatelessWidget {
  AuthOrHomePage({Key? key}) : super(key: key);

  bool isAdmin = true;

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return const Center(
            child: Text('Ocorreu um erro!'),
          );
        } else {
          return auth.isAuth
              ? isAdmin
                  ? InitialScreen()
                  : const BaseScreen()
              : SignInScreen();
        }
      },
    );
  }
}
