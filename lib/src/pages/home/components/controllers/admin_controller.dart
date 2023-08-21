import 'package:flutter/cupertino.dart';

class AdminController with ChangeNotifier {
  bool _isWeb = true;

  bool get isWeb => _isWeb;

  void toggleWeb() {
    _isWeb = !_isWeb;
    notifyListeners();
  }
}
