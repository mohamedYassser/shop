import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart ' as http;
import '../models/http_exception.dart';


class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment)async{
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDxcRFDgex70r3MLzP-V1K_VIjk2Y-GJFs';

    try {
      final response = await http.post(url,
          body: jsonEncode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final resposeData = json.decode(response.body);
      if (resposeData['error'] != null) {
     HttpException(resposeData['error']['message']);
      }
      _token = resposeData['idToken'];
      _userId = resposeData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(resposeData['expiresIn'])));
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      String userData = jsonEncode({
        'token': _token,
        "userId": _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (e) {
throw e ;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;
    final Map<String, Object> exrtactData =
        jsonDecode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(exrtactData['expiryDate']);
    if (_expiryDate.isBefore(DateTime.now())) return false;
    _token = exrtactData['token'];
    _userId = exrtactData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    return true;
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
