import 'package:charlie_customer_app/Models/BrandModel.dart';
import 'package:flutter/material.dart';

class BrandProvider with ChangeNotifier {
  List<BrandModel> brandList;

  void setBrandList(List<BrandModel> brandList) {
    this.brandList = brandList;
    notifyListeners();
  }
}
