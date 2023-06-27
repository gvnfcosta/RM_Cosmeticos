import 'package:flutter/material.dart';
import '../../../components/app_drawer.dart';
import '../../user/users_page.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Usuários'),
      ),

      // Campo Pesquisa
      body: const UsersScreen(),
      drawer: const AppDrawer(),
    );
  }
}
