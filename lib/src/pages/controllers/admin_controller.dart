import 'package:flutter/cupertino.dart';

class AdminController with ChangeNotifier {
  bool _isAdmin = false;

  bool get isAdmin => _isAdmin;

  void toggleAdmin() {
    _isAdmin = !_isAdmin;
    notifyListeners();
  }
}
