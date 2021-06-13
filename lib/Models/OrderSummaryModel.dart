import 'package:charlie_customer_app/Models/AddressModel.dart';
import 'package:charlie_customer_app/Models/OrderItemModel.dart';

class OrderSummary {
  String id;
  AddressModel address;
  List<OrderItemModel> orderList;
  String date;
  String status;
  String total;
  OrderSummary(
      {this.address,
      this.id,
      this.orderList,
      this.date,
      this.status,
      this.total});
}
