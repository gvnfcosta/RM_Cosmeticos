import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/auth.dart';

class AuthAuto extends StatefulWidget {
  const AuthAuto({Key? key}) : super(key: key);

  @override
  State<AuthAuto> createState() => _AuthAutoState();
}

class _AuthAutoState extends State<AuthAuto> {
  @override
  void initState() {
    super.initState();
    _submit();
  }

  Future<void> _submit() async {
    Auth auth = Provider.of(context, listen: false);

    await auth.login('loja@rm.com', '123456');
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
