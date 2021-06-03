import 'package:charlie_customer_app/Models/CategoryModel.dart';
import 'package:charlie_customer_app/Models/ProductModel.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> productList;

  void setProductList(List<ProductModel> productList) {
    this.productList = productList;
    notifyListeners();
  }
}
