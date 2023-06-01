import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/user/users_screen.dart';
import '../models/user_list.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

List<Widget> tabItems = [
  const Tab(text: 'Usuários'),
  const Tab(text: '   Catálogos'),
];

class _AdminScreenState extends State<AdminScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<UserList>(
      context,
      listen: false,
    ).loadData().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (BuildContext conext) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              title: TabBar(
                tabs: tabItems,
                indicatorColor: Colors.white,
              ),
            ),

            // Campo Pesquisa
            body: TabBarView(
              children: [
                UsersScreen(),
                Row(
                  children: [],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
