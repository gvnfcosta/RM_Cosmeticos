import 'dart:async';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../data/store.dart';
import '../exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _logoutTimer;
  String _userEmail = '';
  String _userPassword = '';

  late Box box;

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

  Future<void> startUser() async {
    box = await Hive.openBox('userData');
  }

  Future<void> _authenticate(String email, String password, String url) async {
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];

      _expiryDate = DateTime.now().add(
        Duration(seconds: (int.parse(body['expiresIn']))),
      );

      Store.saveMap('userData', {
        'token': _token,
        'email': _email,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });

      _autoLogout();
      notifyListeners();
    }
  }

  Future<void> newLogin(String email, String password) async {
    _userEmail = email;
    _userPassword = password;
    login(_userEmail, _userPassword);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password,
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBSycGT_t9EY5cFNCLHbTR8Ep-tZRZH-YY');
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final userData = await Store.getMap('userData');

    // if (_userEmail.isNotEmpty && _userPassword.isNotEmpty) {
    //   await login(_userPassword, _userPassword);
    // }

    if (userData.isEmpty) return;

    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return;
    }

    _token = userData['token'];
    _email = userData['email'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;

    //_autoLogout();
    notifyListeners();
  }

  void logout() {
    _token = null;
    _email = null;
    _userId = null;
    _expiryDate = null;
    _clearLogoutTimer();
    Store.remove('userData').then((_) {
      notifyListeners();
    });
  }

  void _clearLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  void _keepLoged() async {
    await login(_userPassword, _userPassword);
  }

  void _autoLogout() {
    _clearLogoutTimer();
    final timeToLogout = _expiryDate?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(
      Duration(seconds: timeToLogout ?? 0),
      _keepLoged,
    );
  }
}
