import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {

  Timer _authTimer = Timer(const Duration(seconds: 1), () {});
  String _idToken = '';
  String userId = '';
  DateTime _expiryDate = DateTime.now();

  String _tempidToken = '';
  String tempuserId = '';
  DateTime _tempexpiryDate = DateTime.now();

  void tempData() async {
    _idToken = _tempidToken;
    userId = tempuserId;
    _expiryDate = _tempexpiryDate;

    // agar autologin bisa berjalan
    final sharedPref = await SharedPreferences.getInstance();
    final userData = json.encode({
      'idToken': _tempidToken,
      'userId': tempuserId,
      'expiryDate': _tempexpiryDate.toIso8601String()
    });
    sharedPref.setString('userData', userData);

    _autologout();
    notifyListeners();
  }

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_idToken != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _expiryDate != null) {
      return _idToken;
    } else {
      return null;
    }
  }

  String apiKey = 'AIzaSyD2OYYjrpT1Yy3lizY0ysPM72A7nxoQJqM';


  Future<void> signUp(String? email, String? password) async {

    Uri url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey');

    try {
      var response = await http.post(
          url, body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      })
      );

      var responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        if (responseData['error']['message'] == 'EMAIL_EXISTS') {
          throw 'The email address is already in use by another account';
        } else if (responseData['error']['message'] == 'OPERATION_NOT_ALLOWED') {
          throw 'Password sign-in is disabled for this project';
        } else if (responseData['error']['message'] == 'TOO_MANY_ATTEMPTS_TRY_LATER') {
          throw 'We have blocked all requests from this device due to unusual activity. Try again later';
        }
      }

      _tempidToken = responseData['idToken'];
      tempuserId = responseData['localId'];
      _tempexpiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));

    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> login(String? email, String? password) async {

    Uri url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey');

    try {
      var response = await http.post(
          url, body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      })
      );

      var responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
          throw 'Email not found';
        } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
          throw 'Invalid password';
        } else if (responseData['error']['message'] == 'USER_DISABLED') {
          throw 'User disabled';
        }
      }

      _tempidToken = responseData['idToken'];
      tempuserId = responseData['localId'];
      _tempexpiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));

    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> logout() async {
    _idToken = '';
    userId = '';
    _expiryDate = DateTime(0);
    _authTimer.cancel();
    _authTimer = Timer(const Duration(seconds: 0), () {});

    final pref = await SharedPreferences.getInstance();
    pref.clear();

    notifyListeners();
  }

  void _autologout() {
    _authTimer.cancel();
    final timeToExpiry = _tempexpiryDate.difference(DateTime.now()).inSeconds;
    print("Expire in $timeToExpiry");
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<bool> autoLogin() async {

    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('userData')) {
      return false;
    }

    final userData = json.decode(pref.get('userData').toString()) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _idToken = userData['idToken'];
    userId = userData['userId'];
    _expiryDate = expiryDate;

    notifyListeners();
    return true;
  }
}