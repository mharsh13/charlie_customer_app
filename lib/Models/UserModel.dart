import 'package:charlie_customer_app/Models/AddressModel.dart';
import 'package:charlie_customer_app/Models/CartModel.dart';

class UserModel {
  String username;
  String phoneNumber;
  String id;
  List<String> userFavList;
  List<CartModel> cartList;
  List<AddressModel> addressList;
  UserModel({
    this.id,
    this.phoneNumber,
    this.username,
    this.userFavList,
    this.cartList,
    this.addressList,
  });
}
