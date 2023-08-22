import 'package:flutter/cupertino.dart';

class AdminController with ChangeNotifier {
  bool _isWeb = false;

  bool get isWeb => _isWeb;

  void toggleWeb() {
    _isWeb = !_isWeb;
    notifyListeners();
  }
}
