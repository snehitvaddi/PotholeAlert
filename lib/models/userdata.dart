import 'package:flutter/cupertino.dart';


class UserData with ChangeNotifier{
  UserData();

  String _userId = '';


  void setUserID(String text) {
    _userId = text;
    notifyListeners();
  }


  String get getUserID => _userId;
}