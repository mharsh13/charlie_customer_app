import 'package:cached_network_image/cached_network_image.dart';
import 'package:charlie_customer_app/Models/OrderModel.dart';
import 'package:charlie_customer_app/Models/OrderSummaryModel.dart';
import 'package:charlie_customer_app/Models/ProductModel.dart';
import 'package:charlie_customer_app/Models/UserModel.dart';
import 'package:charlie_customer_app/Providers/ProductProvider.dart';
import 'package:charlie_customer_app/Providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

class OrderSummaryScreen extends StatefulWidget {
  final OrderSummary orderSummary;
  OrderSummaryScreen({this.orderSummary});
  @override
  _OrderSummaryScreenState createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  List<ProductModel> productList = [];
  List<OrderModel> orderList = [];
  List<String> orderProcess = [
    "Placed",
    "Confirmed",
    "Delivery",
    "Success",
  ];

  int currentIndex = 0;

  UserModel userInfo;
  @override
  void initState() {
    userInfo = Provider.of<UserProvider>(context, listen: false).userInfo;
    productList = Provider.of<ProductProvider>(context, listen: false).products;
    if (widget.orderSummary.status == "Placed") {
      currentIndex = 0;
    } else if (widget.orderSummary.status == "Confirmed") {
      currentIndex = 1;
    } else if (widget.orderSummary.status == "Delivery") {
      currentIndex = 2;
    } else {
      currentIndex = 3;
    }
    widget.orderSummary.orderList.forEach((orderItem) {
      productList.forEach((product) {
        if (product.id == orderItem.productId) {
          product.variantList.forEach((variant) {
            if (orderItem.variantId == variant.id) {
              orderList.add(OrderModel(
                brand: product.brand,
                category: product.category,
                desc: product.desc,
                gender: product.gender,
                productId: product.id,
                productName: product.name,
                variant: variant,
                imageUrl: product.imageUrl[0],
                quantity: orderItem.quantity,
              ));
            }
          });
        }
      });
    });
    super.initState();
  }

  String formatDate(DateTime date) {
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    String formatted = formatter.format(date);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
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
            "Order Details",
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
              height: height * 0.02,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Order : #${widget.orderSummary.id.substring(0, 10)}",
                style: GoogleFonts.montserrat(
                  color: HexColor("#302a30"),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Order Date : ${formatDate(DateTime.parse(widget.orderSummary.date))}",
                style: GoogleFonts.montserrat(
                  color: HexColor("#302a30"),
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    "Total : ",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      color: HexColor("#302a30"),
                      fontSize: 14,
                    ),
                  ),
                  Icon(
                    MdiIcons.currencyInr,
                    color: HexColor("#302a30"),
                    size: 14,
                  ),
                  Text(
                    "${widget.orderSummary.total}",
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
              child: Text(
                "Shipping Details",
                style: GoogleFonts.montserrat(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.02,
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
                        "Name: ${widget.orderSummary.address.username}",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          color: HexColor("#302a30").withOpacity(.9),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      width: width,
                      child: Text(
                        "Address: ${widget.orderSummary.address.address}",
                        style: GoogleFonts.montserrat(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Container(
                      width: width,
                      child: Text(
                        "Pincode: ${widget.orderSummary.address.pincode}",
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
                        "Phone Number: ${widget.orderSummary.address.phoneNumber}",
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
              height: height * 0.02,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Payment Details",
                style: GoogleFonts.montserrat(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Container(
                width: width,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Container(
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Cash on Delivery",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          color: HexColor("#302a30").withOpacity(.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(MdiIcons.currencyInr)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "You'll receive order in 1 delivery",
                style: GoogleFonts.montserrat(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: height * 0.13,
              child: Timeline.tileBuilder(
                theme: TimelineThemeData(
                  direction: Axis.horizontal,
                  indicatorTheme: IndicatorThemeData(
                    color: HexColor("#f55d5d"),
                    size: 32,
                  ),
                  connectorTheme: ConnectorThemeData(
                    color: Colors.black,
                  ),
                ),
                builder: TimelineTileBuilder.connected(
                  contentsAlign: ContentsAlign.basic,
                  indicatorBuilder: (context, index) => DotIndicator(
                    child: currentIndex >= index
                        ? Icon(
                            MdiIcons.check,
                            color: Colors.white,
                            size: 18,
                          )
                        : Container(),
                  ),
                  connectorBuilder: (context, index, type) =>
                      Connector.solidLine(),
                  contentsBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      '${orderProcess[index]}',
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  itemCount: orderProcess.length,
                ),
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Order Summary",
                style: GoogleFonts.montserrat(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Container(
              height: height * 0.17 * orderList.length,
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
                            imageUrl: "${orderList[index].imageUrl}",
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
                                  "${orderList[index].productName}",
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
                                  "${orderList[index].gender} / ${orderList[index].category} / ${orderList[index].brand}",
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
                                  "Quanity: ${orderList[index].quantity}",
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
                                          "${orderList[index].variant.size}",
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
                                      orderList[index].variant.colorName == ""
                                          ? "Color: Mix Color"
                                          : "Color: " +
                                              "${orderList[index].variant.colorName}",
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
                                    "${orderList[index].variant.sellingPrice}",
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
                itemCount: orderList.length,
              ),
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
                        "${widget.orderSummary.total}",
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
                        "${widget.orderSummary.total}",
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
          ],
        ),
      ),
    );
  }
}
