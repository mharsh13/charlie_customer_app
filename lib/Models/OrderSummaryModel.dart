import 'package:charlie_customer_app/Models/OrderItemModel.dart';

class OrderSummary {
  String id;
  String addressId;
  List<OrderItemModel> orderList;
  OrderSummary({this.addressId, this.id, this.orderList});
}
