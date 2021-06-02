import 'package:charlie_customer_app/Models/UserModel.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  UserModel userInfo;

  void setUser(UserModel userInfo) {
    this.userInfo = userInfo;
    notifyListeners();
  }
}
