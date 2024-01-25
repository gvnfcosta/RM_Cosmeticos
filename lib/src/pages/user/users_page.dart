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
    Provider.of<UserList>(context, listen: false)
        .loadData()
        .then((value) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserList>(context);
    final List<UserModel> users = provider.items;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        // title: const Text('USUÁRIOS', style: TextStyle(color: Colors.red)),
      ),

      // Campo Pesquisa
      body: !_isLoading
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: users.length,
                      separatorBuilder: (_, index) => const Divider(),
                      itemBuilder: (_, i) {
                        return UserTile(user: users[i]);
                      },
                    ),
                  ),
                ],
              ),
            )
          : const Center(),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (c) => const UserFormPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
