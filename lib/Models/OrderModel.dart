import 'package:charlie_customer_app/Models/VariantModel.dart';

class OrderModel {
  String productId;
  String productName;
  String desc;
  String brand;
  String gender;
  String category;
  String imageUrl;
  VariantModel variant;
  String quantity;
  OrderModel({
    this.brand,
    this.category,
    this.desc,
    this.gender,
    this.productId,
    this.productName,
    this.variant,
    this.imageUrl,
    this.quantity,
  });
}
