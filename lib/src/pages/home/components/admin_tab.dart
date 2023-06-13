import 'package:flutter/material.dart';
import '../../catalogs/catalogs_page.dart';
import '../../user/users_page.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            body: const TabBarView(
              children: [
                UsersScreen(),
                CatalogsPage(),
              ],
            ),
          );
        },
      ),
    );
  }
}

List<Widget> tabItems = [
  const Tab(text: 'Usuários'),
  const Tab(text: 'Catálogos'),
];
