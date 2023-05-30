import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/src/pages/initial/catalogs_screen.dart';
import '/src/pages/initial/users_screen.dart';
import '../../models/user_list.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title:
            const Text('Administração', style: TextStyle(color: Colors.white)),
      ),

      // Campo Pesquisa
      body: !_isLoading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: SizedBox(
                    height: size.height / 6,
                    width: size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (c) => const UsersScreen()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Text('USUÁRIOS', style: TextStyle(fontSize: 35)),
                          Icon(Icons.people, size: 35),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: SizedBox(
                    height: size.height / 6,
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
                ),
              ],
            )
          : const Center(),
    );
  }
}
