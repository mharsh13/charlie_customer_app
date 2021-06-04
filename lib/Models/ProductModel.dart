import 'package:charlie_customer_app/Models/VariantModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String name;
  String desc;
  List<String> imageUrl;
  String category;
  String brand;
  String gender;
  bool isFav;
  List<VariantModel> variantList;
  String id;
  Timestamp date;
  ProductModel(
      {this.brand,
      this.category,
      this.desc,
      this.gender,
      this.id,
      this.imageUrl,
      this.isFav,
      this.name,
      this.date,
      this.variantList});
}
