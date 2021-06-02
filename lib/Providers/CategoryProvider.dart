import 'package:charlie_customer_app/Models/CategoryModel.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> categoryList;

  void setCategoryList(List<CategoryModel> categoryList) {
    this.categoryList = categoryList;
    notifyListeners();
  }
}
