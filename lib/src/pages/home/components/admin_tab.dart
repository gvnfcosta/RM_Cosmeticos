import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/src/pages/initial/catalogs_screen.dart';
import '../../user/users_screen.dart';
import '../../../models/user_list.dart';

class AdminTab extends StatefulWidget {
  const AdminTab({super.key});

  @override
  State<AdminTab> createState() => _AdminTabState();
}

List<Widget> tabItems = [
  const Tab(text: 'Usuários'),
  const Tab(text: '   Catálogos'),
];

class _AdminTabState extends State<AdminTab> {
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
                  children: [
                    SizedBox(
                      height: size.height / 10,
                      width: size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (c) => const CatalogsScreen()),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Text('CATÁLOGOS', style: TextStyle(fontSize: 35)),
                            Icon(Icons.list, size: 35),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
