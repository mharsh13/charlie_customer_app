import 'package:charlie_customer_app/Models/ProductModel.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> productList = [];
  List<ProductModel> get products {
    return [...productList];
  }

  void setProductList(List<ProductModel> productList) {
    this.productList = productList;
    notifyListeners();
  }
}
