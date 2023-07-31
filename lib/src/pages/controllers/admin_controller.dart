// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
// import 'package:rm/src/models/user_model.dart';
// import '../../models/user_list.dart';

// class AdminController with ChangeNotifier {
//   bool _isAdmin = false;
//   final String _userName = '';
//   UserModel? _user;

//   bool get isAdmin => _isAdmin;
//   String get userName => _userName;
//   UserModel? get user => _user;

//   UserModel User(BuildContext context) {
//     List<UserModel> user = Provider.of<UserList>(context).user;
//     //UserModel user = Provider.of<UserList>(context).user;
//     return user;
//   }

//   String UserName(BuildContext context) {
//     String userName = Provider.of<UserList>(context).userName;
//     return userName;
//   }

//   bool Admin(BuildContext context) {
//     UserModel user = Provider.of<UserList>(context).user;
//     if (user.name.isNotEmpty) _isAdmin = user.level == 0;
//     return _isAdmin;
//   }
// }
