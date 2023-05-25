import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../../models/user_list.dart';
import '../../../../models/user_model.dart';

class AdminController with ChangeNotifier {
  bool _isAdmin = false;

  bool get isAdmin => _isAdmin;

  String userName(BuildContext context) {
    final String nomeUsuario =
        Provider.of<UserList>(context).usuario.first.name;

    return nomeUsuario;
    // final List<UserModel> usuario = Provider.of<UserList>(context).usuario;

    // return usuario.first.name;
  }
}