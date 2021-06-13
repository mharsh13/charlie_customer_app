import 'package:charlie_customer_app/Models/AddressModel.dart';
import 'package:charlie_customer_app/Models/CartModel.dart';
import 'package:charlie_customer_app/Models/OrderSummaryModel.dart';

class UserModel {
  String username;
  String phoneNumber;
  String id;
  List<String> userFavList;
  List<CartModel> cartList;
  List<AddressModel> addressList;
  OrderSummary orderSummary;
  UserModel({
    this.id,
    this.phoneNumber,
    this.username,
    this.userFavList,
    this.cartList,
    this.addressList,
    this.orderSummary,
  });
}
