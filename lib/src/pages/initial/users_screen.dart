import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm/src/models/user_model.dart';
import 'package:rm/src/pages/user/user_form_page.dart';
import '../../models/user_list.dart';
import '../home/components/user_tile.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
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
        title: const Text('Usuários', style: TextStyle(color: Colors.white)),
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
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (_, i) {
                        return UserTile(user: users[i]);
                      },
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 10 / 10,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
