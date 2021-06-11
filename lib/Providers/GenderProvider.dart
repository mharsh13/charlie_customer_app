
import 'package:charlie_customer_app/Models/GenderModel.dart';
import 'package:flutter/material.dart';

class GenderProvider with ChangeNotifier {
  List<GenderModel> genderList;

  void setGenderList(List<GenderModel> genderList) {
    this.genderList = genderList;
    notifyListeners();
  }
}
