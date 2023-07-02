import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  late String _token;
  late DateTime? _expiryDate = null;
  late String _userId;
  late Timer? _authTimer = null;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    // For signup => 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBZZb0kCWdQWZXTZvp9ho9WMTzPj2RngYg'
    // For login  => 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBZZb0kCWdQWZXTZvp9ho9WMTzPj2RngYg'

    // For signup => 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY]'
    // For login  => 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=[API_KEY]'
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyD1TAhmi_CTXRwBevS2NjelDSg66D3OhW4');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      print(json.decode(response.body)); // For debug console...
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken']; // Get the id token...
      _userId = responseData['localId']; // Get the user id
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );

      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      print("Debug => Token value = " + _token);
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout() {
    _token = '';
    _userId = '';
    _expiryDate = null;

    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer?.cancel();
    }
     final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
     _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
    //_authTimer = Timer(Duration(seconds: 8), logout); //use for testing only
  }
      Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('UserData')) {
      return false;
    }
    final extractedUserData = json.decode(
      prefs.getString('UserData').toString()) as Map<String, dynamic>;
      final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;


    notifyListeners();
    _autoLogout();
    return true;
  }
}
