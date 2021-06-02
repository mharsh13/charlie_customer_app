import 'package:charlie_customer_app/Models/VariantModel.dart';

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
  ProductModel(
      {this.brand,
      this.category,
      this.desc,
      this.gender,
      this.id,
      this.imageUrl,
      this.isFav,
      this.name,
      this.variantList});
}
