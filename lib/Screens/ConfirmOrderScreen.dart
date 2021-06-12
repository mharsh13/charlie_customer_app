import 'package:cached_network_image/cached_network_image.dart';
import 'package:charlie_customer_app/Models/AddressModel.dart';
import 'package:charlie_customer_app/Models/OrderModel.dart';
import 'package:charlie_customer_app/Models/UserModel.dart';
import 'package:charlie_customer_app/Providers/UserProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class ConfirmOrderScreen extends StatefulWidget {
  final List<OrderModel> orderList;
  final AddressModel address;

  ConfirmOrderScreen({this.orderList, this.address});
  @override
  _ConfirmOrderScreenState createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  UserModel userInfo;
  @override
  void initState() {
    userInfo = Provider.of<UserProvider>(context, listen: false).userInfo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var totalPrice = 0.0;
    widget.orderList.forEach((order) {
      totalPrice += (double.parse(order.variant.sellingPrice) *
          double.parse(order.quantity));
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: HexColor("#f55d5d").withOpacity(.8),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Center(
            child: Icon(
              MdiIcons.chevronLeft,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
        title: Container(
          width: width * 0.8,
          child: Text(
            "Order Summary",
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height * .02,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Items List",
                style: GoogleFonts.montserrat(
                  color: HexColor("#302a30"),
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: height * .02,
            ),
            Container(
              height: height * 0.17 * widget.orderList.length,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: Container(
                    width: width,
                    child: Row(
                      children: [
                        Container(
                          height: height * 0.15,
                          width: width * 0.3,
                          child: CachedNetworkImage(
                            imageUrl: "${widget.orderList[index].imageUrl}",
                            placeholder: (context, url) => SpinKitRing(
                              color: Colors.grey,
                              lineWidth: 3,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.03,
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: height * 0.015,
                              ),
                              Container(
                                width: width * 0.5,
                                child: Text(
                                  "${widget.orderList[index].productName}",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(
                                    color: HexColor("#302a30").withOpacity(.9),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                width: width * 0.5,
                                child: Text(
                                  "${widget.orderList[index].gender} / ${widget.orderList[index].category} / ${widget.orderList[index].brand}",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              Container(
                                width: width * 0.5,
                                child: Text(
                                  "Quanity: ${widget.orderList[index].quantity}",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Container(
                                width: width * 0.65,
                                child: Row(
                                  children: [
                                    Text(
                                      "Size: " +
                                          "${widget.orderList[index].variant.size}",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                        color:
                                            HexColor("#302a30").withOpacity(.9),
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.03,
                                    ),
                                    Text(
                                      widget.orderList[index].variant
                                                  .colorName ==
                                              ""
                                          ? "Color: Mix Color"
                                          : "Color: " +
                                              "${widget.orderList[index].variant.colorName}",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                        color:
                                            HexColor("#302a30").withOpacity(.9),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    MdiIcons.currencyInr,
                                    color: HexColor("#302a30").withOpacity(.8),
                                    size: 18,
                                  ),
                                  Text(
                                    "${widget.orderList[index].variant.sellingPrice}",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.montserrat(
                                      color: HexColor("#302a30"),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                itemCount: widget.orderList.length,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Shipping Details",
                style: GoogleFonts.montserrat(
                  color: HexColor("#302a30"),
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: height * .02,
            ),
            Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Container(
                width: width,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width,
                      child: Text(
                        "Name: ${widget.address.username}",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          color: HexColor("#302a30").withOpacity(.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      width: width,
                      child: Text(
                        "Address: ${widget.address.address}",
                        style: GoogleFonts.montserrat(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Container(
                      width: width,
                      child: Text(
                        "Pincode: ${widget.address.pincode}",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Container(
                      width: width,
                      child: Text(
                        "Phone Number: ${widget.address.phoneNumber}",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * .03,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      "Subtotal",
                      style: GoogleFonts.montserrat(
                        color: HexColor("#302a30"),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        MdiIcons.currencyInr,
                        size: 16,
                        color: HexColor("#302a30"),
                      ),
                      Text(
                        "$totalPrice",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          color: HexColor("#302a30"),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Standard Ground Shipping",
                          style: GoogleFonts.montserrat(
                            color: HexColor("#302a30"),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "(1-2 business days)",
                          style: GoogleFonts.montserrat(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "FREE",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      color: HexColor("#302a30"),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                child: Text(
                  "Pay on delivery",
                  style: GoogleFonts.montserrat(
                    color: HexColor("#302a30"),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      "Total",
                      style: GoogleFonts.montserrat(
                        color: HexColor("#302a30"),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        MdiIcons.currencyInr,
                        size: 16,
                        color: HexColor("#302a30"),
                      ),
                      Text(
                        "$totalPrice",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          color: HexColor("#302a30"),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * .03,
            ),
            Center(
              child: InkWell(
                onTap: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  List orderList = [];
                  widget.orderList.forEach((order) async {
                    orderList.add({
                      "orderDetails": {
                        "productId": order.productId,
                        "variantId": order.variant.id,
                        "quantity": order.quantity,
                      }
                    });
                  });

                  CollectionReference orderCollection =
                      firestore.collection("Orders");
                  await orderCollection.add({
                    "OrderList": orderList,
                    "UserId": userInfo.id,
                    "AddressId": widget.address.id,
                  });
                  CollectionReference userCollection =
                      firestore.collection("User Information");
                  await userCollection.doc(userInfo.id).update({
                    "Cart Items": [],
                  });
                  setState(() {
                    _isLoading = false;
                  });
                  final snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text('Order Placed Successfully!'),
                    backgroundColor: HexColor("#f55d5d").withOpacity(0.8),
                    action: SnackBarAction(
                      label: 'Ok',
                      textColor: Colors.white,
                      onPressed: () {},
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    snackBar,
                  );
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: width * 0.6,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: _isLoading
                        ? SpinKitThreeBounce(
                            color: Colors.white,
                            size: 24,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Confirm Order",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Icon(
                                FeatherIcons.check,
                                color: Colors.white,
                                size: 20,
                              )
                            ],
                          ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * .03,
            ),
          ],
        ),
      ),
    );
  }
}
