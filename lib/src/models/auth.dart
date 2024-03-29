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
  // final String _userEmail = '';
  // final String _userPassword = '';

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

  // Future<void> startUser() async {
  //   box = await Hive.openBox('userData');
  // }

  // Future<void> newLogin(String email, String password) async {
  //   _userEmail = email;
  //   _userPassword = password;
  //   login(_userEmail, _userPassword);
  // }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password,
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBSycGT_t9EY5cFNCLHbTR8Ep-tZRZH-YY');
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

// 0: "kind" -> "identitytoolkit#VerifyPasswordResponse"
// 1: "localId" -> "jXxb2twxdJRpvN4xIpksKtp3Tgp1"
// 2: "email" -> "mauricio@rm.com"
// 3: "displayName" -> ""
// 4: "idToken" -> "eyJhbGciOiJSUzI1NiIsImtpZCI6IjYyM2YzNmM4MTZlZTNkZWQ2YzU0NTkyZTM4ZGFlZjcyZjE1YTBmMTMiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY…"
// 5: "registered" -> true
// 6: "refreshToken" -> "AMf-vBzNFns3KvH4lbm1YHK8S7LytH1H4BVkzaYXZoeAyIYaoK679h_Wqc0jG0vbzLKHe_Qx0dOXMnVC_5h_h0x6xo_F9E6MptVhpQ7pGE6JcdJ1A2omMjF6E4qtSb7k…"
// 7: "expiresIn" -> "3600"

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

      // _autoLogout();
      notifyListeners();
    }
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final userData = await Store.getMap('userData');

    if (userData.isEmpty) return;

    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return;
    }

    _token = userData['token'];
    _email = userData['email'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;

    _autoLogout();
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

  void keepLogged() async {
    //  await login(_userEmail, _userPassword);
  }

  void _autoLogout() {
    _clearLogoutTimer();
    final timeToLogout = _expiryDate?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(
      Duration(seconds: timeToLogout! - 60),
      // logout,
      keepLogged,
    );
  }
}
