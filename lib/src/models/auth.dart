import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rm/src/config/app_data.dart';
import '../data/store.dart';
import '../exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _logoutTimer;

  //Você pode obter idTokenusando o getIdToken() método no objeto FirebaseUser

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

  Future<void> _authenticate(
      String email, String password, String urlFragment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=${Constants.webApiKey}';
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

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
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
  }

// https://pt.stackoverflow.com/questions/516370/como-manter-o-login-ativo-flutter-firebase

  // void changePassword(String password) async {
  //   const url =
  //       'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${Constants.webApiKey}';

  //   final response = await http
  //       .post(
  //     Uri.parse(url),
  //     body: jsonEncode({
  //       'email': email,
  //       'password': password,
  //       'returnSecureToken': true,
  //     }),
  //   )
  //       .then((_) {
  //     print("A senha foi alterada.");
  //   }).catchError((error) {
  //     print("Alteração deu erro changed$error");
  //   });
  // }

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

  void _autoLogout() async {
    _clearLogoutTimer();
    final timeToLogout = _expiryDate?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(
      Duration(seconds: timeToLogout ?? 0),
      logout,
    );
  }

  String validarSenha(String newPassword, String confirmPassword) {
    if (newPassword != confirmPassword) {
      return 'Senhas informadas não conferem.';
    }
    return "Senha Alterada com Sucesso";
  }
}
