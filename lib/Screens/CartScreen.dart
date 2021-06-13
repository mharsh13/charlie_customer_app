import 'package:cached_network_image/cached_network_image.dart';
import 'package:charlie_customer_app/Models/AddressModel.dart';
import 'package:charlie_customer_app/Models/OrderModel.dart';
import 'package:charlie_customer_app/Models/ProductModel.dart';
import 'package:charlie_customer_app/Models/UserModel.dart';
import 'package:charlie_customer_app/Providers/ProductProvider.dart';
import 'package:charlie_customer_app/Providers/UserProvider.dart';
import 'package:charlie_customer_app/Screens/AddAddressScreen.dart';
import 'package:charlie_customer_app/Screens/ConfirmOrderScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<ProductModel> productList = [];
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<OrderModel> orderList = [];
  AddressModel addressValue;
  List<S2Choice<AddressModel>> addressRadio = [];
  List<AddressModel> addressList = [];

  bool _isLoading = false;
  UserModel userInfo;

  @override
  void initState() {
    super.initState();
    userInfo = Provider.of<UserProvider>(context, listen: false).userInfo;
    productList = Provider.of<ProductProvider>(context, listen: false).products;
    userInfo.cartList.forEach((cartItem) {
      productList.forEach((product) {
        if (product.id == cartItem.productId) {
          product.variantList.forEach((variant) {
            if (cartItem.variantId == variant.id) {
              orderList.add(OrderModel(
                brand: product.brand,
                category: product.category,
                desc: product.desc,
                gender: product.gender,
                productId: product.id,
                productName: product.name,
                variant: variant,
                imageUrl: product.imageUrl[0],
                quantity: cartItem.quantity,
              ));
            }
          });
        }
      });
    });

    userInfo.addressList.forEach((address) {
      addressRadio.add(
        S2Choice<AddressModel>(value: address, title: address.address),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var totalPrice = 0.0;
    orderList.forEach((order) {
      totalPrice += (double.parse(order.variant.sellingPrice) *
          double.parse(order.quantity));
    });
    var totalCost = 0.0;
    orderList.forEach((order) {
      totalCost += (double.parse(order.variant.costPrice) *
          double.parse(order.quantity));
    });
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Card(
        color: Colors.white,
        elevation: 20,
        margin: EdgeInsets.all(0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: height * 0.3,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                child: Text(
                  orderList.length == 1
                      ? "Price Details (${orderList.length} Item)"
                      : "Price Details (${orderList.length} Items)",
                  style: GoogleFonts.montserrat(
                    color: HexColor("#302a30"),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      "Total MRP",
                      style: GoogleFonts.montserrat(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        MdiIcons.currencyInr,
                        size: 14,
                      ),
                      Text(
                        "$totalCost",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          color: HexColor("#302a30"),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      "Discount on MRP",
                      style: GoogleFonts.montserrat(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "-",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          color: Colors.green,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        MdiIcons.currencyInr,
                        size: 14,
                        color: Colors.green,
                      ),
                      Text(
                        "${totalCost - totalPrice}",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          color: Colors.green,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      "Total Amount",
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
              SizedBox(
                height: height * 0.05,
              ),
              Center(
                child: SmartSelect<AddressModel>.single(
                    title: "Address",
                    modalTitle: "Choose Address",
                    value: addressValue,
                    choiceItems: addressRadio,
                    choiceEmptyBuilder: (context, value) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                "Please add an address to continue!",
                                style: GoogleFonts.montserrat(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.05,
                            ),
                            Center(
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          AddAddressScreen(
                                        isEdit: false,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: width * 0.6,
                                  height: height * 0.05,
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: HexColor("#f55d5d").withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Add Address",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.02,
                                        ),
                                        Icon(
                                          FeatherIcons.mapPin,
                                          color: Colors.white,
                                          size: 20,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    tileBuilder: (context, state) => InkWell(
                          onTap: () {
                            state.showModal();
                          },
                          child: Container(
                            width: width * 0.6,
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: HexColor("#f55d5d").withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Order Now",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  Icon(
                                    FeatherIcons.shoppingBag,
                                    color: Colors.white,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                    choiceType: S2ChoiceType.radios,
                    modalType: S2ModalType.bottomSheet,
                    choiceStyle: S2ChoiceStyle(
                      activeColor: HexColor("#f55d5d").withOpacity(0.8),
                    ),
                    onChange: (state) {
                      setState(() => addressValue = state.value);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ConfirmOrderScreen(
                            orderList: orderList,
                            address: addressValue,
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
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
            "Your Cart",
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: SpinKitRing(
                lineWidth: 4,
                size: 40,
                color: HexColor("#f55d5d"),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * .02,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${orderList.length} Items",
                          style: GoogleFonts.montserrat(
                            color: HexColor("#302a30").withOpacity(.8),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          width: width * 0.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Total : ",
                                style: GoogleFonts.montserrat(
                                  color: HexColor("#302a30").withOpacity(.8),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Icon(
                                MdiIcons.currencyInr,
                                color: HexColor("#302a30").withOpacity(.8),
                                size: 18,
                              ),
                              Container(
                                child: Text(
                                  "$totalPrice",
                                  style: GoogleFonts.montserrat(
                                    color: HexColor("#302a30").withOpacity(.8),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * .03,
                  ),
                  Container(
                    height: height * 0.22 * orderList.length,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => Card(
                        elevation: 3,
                        margin:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        child: Container(
                          height: height * 0.2,
                          width: width,
                          child: Row(
                            children: [
                              Container(
                                height: height,
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
                                          color: HexColor("#302a30")
                                              .withOpacity(.9),
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
                                              color: HexColor("#302a30")
                                                  .withOpacity(.9),
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.03,
                                          ),
                                          Text(
                                            orderList[index]
                                                        .variant
                                                        .colorName ==
                                                    ""
                                                ? "Color: Mix Color"
                                                : "Color: " +
                                                    "${orderList[index].variant.colorName}",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.montserrat(
                                              color: HexColor("#302a30")
                                                  .withOpacity(.9),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          MdiIcons.currencyInr,
                                          color: HexColor("#302a30")
                                              .withOpacity(.8),
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
                                        SizedBox(
                                          width: width * .01,
                                        ),
                                        Text(
                                          "${orderList[index].variant.costPrice}",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.montserrat(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * .01,
                                        ),
                                        Text(
                                          "${(((double.parse(orderList[index].variant.costPrice) - double.parse(orderList[index].variant.sellingPrice)) / double.parse(orderList[index].variant.costPrice)) * 100).toStringAsFixed(0)}" +
                                              "% off",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.montserrat(
                                            color: Colors.green,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        final User user = auth.currentUser;
                                        final uid = user.uid;
                                        Map<String, Object> mapItems;
                                        mapItems = {
                                          "ProductId":
                                              orderList[index].productId,
                                          "VariantId":
                                              orderList[index].variant.id,
                                          "Quantity": orderList[index].quantity,
                                        };
                                        CollectionReference userInformation =
                                            firestore
                                                .collection("User Information");
                                        await userInformation.doc(uid).update({
                                          "Cart Items": FieldValue.arrayRemove(
                                            [mapItems],
                                          )
                                        }).then(
                                          (value) {
                                            setState(() {
                                              _isLoading = false;
                                              orderList
                                                  .remove(orderList[index]);
                                            });
                                            final snackBar = SnackBar(
                                              duration: Duration(seconds: 2),
                                              content: Text(
                                                  'Item removed from cart!'),
                                              backgroundColor:
                                                  HexColor("#f55d5d")
                                                      .withOpacity(0.8),
                                              action: SnackBarAction(
                                                label: 'Ok',
                                                textColor: Colors.white,
                                                onPressed: () {},
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              snackBar,
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: width * 0.3,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Remove",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              SizedBox(
                                                width: width * 0.02,
                                              ),
                                              Icon(
                                                FeatherIcons.trash2,
                                                color: Colors.white,
                                                size: 14,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
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
                  )
                ],
              ),
            ),
    );
  }
}
