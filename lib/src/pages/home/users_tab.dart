import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/user_model.dart';
import 'package:rm/src/pages/user/user_form_page.dart';
import '../../models/user_list.dart';
import 'components/user_tile.dart';

class UsersTab extends StatefulWidget {
  const UsersTab({super.key});

  @override
  State<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> {
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
    final provider = Provider.of<UserList>(context);
    final List<UserModel> users = provider.user.toList();

    double tamanhoTela = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Usuários e Vendedores',
            style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (c) => const UserFormPage()),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),

      // Campo Pesquisa
      body: users.isNotEmpty
          ? Column(
              children: [
                //const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: users.length,
                    itemBuilder: (_, i) {
                      return UserTile(user: users[i]);
                    },
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
