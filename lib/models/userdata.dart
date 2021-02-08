import 'package:flutter/cupertino.dart';


class UserData with ChangeNotifier{
  UserData();

  String _userId = '';
  String _userEmail = '';
  String _userName = '';


  void setUserID(String text) {
    _userId = text;
    notifyListeners();
  }

  String get getUserID => _userId;

  void setUserEmail(String text) {
    _userEmail = text;
    notifyListeners();
  }

  String get getUserEmail => _userEmail;

  void setUserName(String text) {
    _userName = text;
    notifyListeners();
  }

  String get getUserName => _userName;
}