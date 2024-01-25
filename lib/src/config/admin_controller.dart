import 'package:flutter/foundation.dart';

class AdminController with ChangeNotifier {
  final bool _isWeb = kIsWeb;
  bool get isWeb => _isWeb;

  bool _isAdmin = false;

  bool get isAdmin => _isAdmin;

  void toggleAdmin() {
    _isAdmin = true;
    notifyListeners();
  }
}
