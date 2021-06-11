import 'package:cached_network_image/cached_network_image.dart';
import 'package:charlie_customer_app/Models/CartModel.dart';
import 'package:charlie_customer_app/Models/ProductModel.dart';
import 'package:charlie_customer_app/Models/VariantModel.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  ProductDetailScreen({this.product});
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  List<VariantModel> filteredList = [];
  List<String> sizeList = [];
  List<String> colorList = [];
  VariantModel selectedVariantModel = new VariantModel();
  var selectedQuantity = 1;
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  _buildCircleIndicator5() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CirclePageIndicator(
              size: 8,
              selectedSize: 12,
              dotColor: Colors.white,
              selectedDotColor: HexColor("#f55d5d"),
              itemCount: widget.product.imageUrl.length,
              currentPageNotifier: _currentPageNotifier,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    filteredList = widget.product.variantList;
    sizeList = [];
    colorList = [];
    filteredList.forEach((element) {
      if (sizeList.contains(element.size)) {
      } else {
        sizeList.add(element.size);
      }
    });

    selectedVariantModel.size = sizeList[0];
    filteredList.forEach((element) {
      if (element.size == selectedVariantModel.size) {
        colorList.add(element.colorCode);
      }
    });
    selectedVariantModel.colorCode = colorList[0];
    filteredList.forEach((element) {
      if (element.colorCode == selectedVariantModel.colorCode) {
        selectedVariantModel.colorName = element.colorName;
      }
    });

    filteredList.forEach((element) {
      if (element.size == selectedVariantModel.size &&
          element.colorCode == selectedVariantModel.colorCode) {
        selectedVariantModel.costPrice = element.costPrice;
        selectedVariantModel.sellingPrice = element.sellingPrice;
        selectedVariantModel.quantity = element.quantity;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      bottomNavigationBar: Card(
        color: Colors.white,
        margin: EdgeInsets.all(0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: height * 0.2,
          width: width,
          child: Column(
            children: [
              SizedBox(
                height: height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        child: Text(
                          "Qty",
                          style: GoogleFonts.montserrat(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.04,
                      ),
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                        ),
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              FeatherIcons.minus,
                              size: 12,
                            ),
                            onPressed: () {
                              setState(() {
                                if (selectedQuantity > 1) {
                                  selectedQuantity--;
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        child: Center(
                          child: Text(
                            "$selectedQuantity",
                            style: GoogleFonts.quicksand(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                        ),
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              FeatherIcons.plus,
                              size: 12,
                            ),
                            onPressed: () {
                              setState(() {
                                if (selectedQuantity <
                                    int.parse(selectedVariantModel.quantity)) {
                                  selectedQuantity++;
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        child: Text(
                          "Total",
                          style: GoogleFonts.montserrat(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.01,
                      ),
                      Icon(
                        MdiIcons.currencyInr,
                        size: 18,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${(int.parse(selectedVariantModel.sellingPrice)) * selectedQuantity}",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              color: HexColor("#302a30"),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: width * .02,
                          ),
                          Text(
                            "${(int.parse(selectedVariantModel.costPrice)) * selectedQuantity}",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              color: Colors.grey,
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Center(
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    CartModel cartItem;
                    widget.product.variantList.forEach((variant) {
                      if (variant.colorCode == selectedVariantModel.colorCode &&
                          variant.size == selectedVariantModel.size) {
                        cartItem = CartModel(
                          productId: widget.product.id,
                          variantId: variant.id,
                          quantity: selectedQuantity.toString(),
                        );
                      }
                    });
                    final User user = auth.currentUser;
                    final uid = user.uid;
                    Map<String, Object> mapItems;
                    mapItems = {
                      "ProductId": cartItem.productId,
                      "VariantId": cartItem.variantId,
                      "Quantity": cartItem.quantity,
                    };
                    CollectionReference userInfo =
                        firestore.collection("User Information");
                    await userInfo.doc(uid).update({
                      "Cart Items": FieldValue.arrayUnion(
                        [mapItems],
                      )
                    }).then(
                      (value) {
                        setState(() {
                          _isLoading = false;
                        });
                        final snackBar = SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text('Item added to cart'),
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
                      },
                    );
                  },
                  child: Container(
                    width: width * 0.6,
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: HexColor("#f55d5d").withOpacity(0.8),
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
                                  "Add to cart",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                Icon(
                                  FeatherIcons.shoppingCart,
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
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: height * 0.35,
              child: Stack(
                children: [
                  PageView.builder(
                    onPageChanged: (int index) {
                      _currentPageNotifier.value = index;
                    },
                    itemCount: widget.product.imageUrl.length,
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      return Container(
                        child: CachedNetworkImage(
                          imageUrl: "${widget.product.imageUrl[index]}",
                          placeholder: (context, url) => SpinKitRing(
                            color: Colors.grey,
                            lineWidth: 3,
                          ),
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                  _buildCircleIndicator5(),
                  Positioned(
                    top: 40,
                    left: 20,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 16,
                        child: Center(
                          child: Icon(
                            MdiIcons.chevronLeft,
                            color: HexColor("#2c3448"),
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Container(
                    width: width * 0.6,
                    child: Text(
                      "${widget.product.name}",
                      style: GoogleFonts.montserrat(
                        color: HexColor("#302a30").withOpacity(.9),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    width: width * 0.34,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            widget.product.isFav
                                ? MdiIcons.heart
                                : MdiIcons.heartOutline,
                            color: widget.product.isFav
                                ? HexColor("#f55d5d")
                                : Colors.black,
                          ),
                          onPressed: () async {
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            setState(() {
                              widget.product.isFav = !widget.product.isFav;
                            });
                            if (widget.product.isFav) {
                              CollectionReference userInfo =
                                  firestore.collection("User Information");
                              await userInfo.doc(uid).update({
                                "favorites": FieldValue.arrayUnion(
                                  [widget.product.id],
                                )
                              });
                            } else {
                              CollectionReference userInfo =
                                  firestore.collection("User Information");
                              await userInfo.doc(uid).update({
                                "favorites": FieldValue.arrayRemove(
                                  [widget.product.id],
                                )
                              });
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(FeatherIcons.share2),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: width,
              child: Text(
                "${widget.product.desc}",
                style: GoogleFonts.montserrat(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
            ),
            Divider(),
            Container(
              width: width,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Item Size",
                style: GoogleFonts.montserrat(
                  color: HexColor("#302a30").withOpacity(.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              height: height * 0.1,
              padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedVariantModel.size = sizeList[index];
                      colorList = [];
                      filteredList.forEach((element) {
                        if (element.size == selectedVariantModel.size) {
                          colorList.add(element.colorCode);
                        }
                      });
                      selectedVariantModel.colorCode = colorList[0];
                      filteredList.forEach((element) {
                        if (element.colorCode ==
                            selectedVariantModel.colorCode) {
                          selectedVariantModel.colorName = element.colorName;
                        }
                      });
                      filteredList.forEach((element) {
                        if (element.size == selectedVariantModel.size &&
                            element.colorCode ==
                                selectedVariantModel.colorCode) {
                          selectedVariantModel.costPrice = element.costPrice;
                          selectedVariantModel.sellingPrice =
                              element.sellingPrice;
                          selectedVariantModel.quantity = element.quantity;
                        }
                      });
                    });
                  },
                  child: Container(
                    // width: width * 0.2,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: selectedVariantModel.size == sizeList[index]
                          ? Colors.white
                          : Colors.grey[100],
                      border: selectedVariantModel.size == sizeList[index]
                          ? Border.all(
                              color: HexColor("#f55d5d").withOpacity(.8),
                            )
                          : Border.all(
                              color: Colors.white,
                            ),
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "${sizeList[index]}",
                        style: GoogleFonts.montserrat(
                          color: selectedVariantModel.size == sizeList[index]
                              ? HexColor("#f55d5d").withOpacity(.8)
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                itemCount: sizeList.length,
              ),
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Item Color",
                    style: GoogleFonts.montserrat(
                      color: HexColor("#302a30").withOpacity(.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    selectedVariantModel.colorName,
                    style: GoogleFonts.montserrat(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: height * 0.1,
              padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedVariantModel.colorCode = colorList[index];
                      filteredList.forEach((element) {
                        if (element.colorCode ==
                            selectedVariantModel.colorCode) {
                          selectedVariantModel.colorName = element.colorName;
                        }
                      });
                      filteredList.forEach((element) {
                        if (element.size == selectedVariantModel.size &&
                            element.colorCode ==
                                selectedVariantModel.colorCode) {
                          selectedVariantModel.costPrice = element.costPrice;
                          selectedVariantModel.sellingPrice =
                              element.sellingPrice;
                          selectedVariantModel.quantity = element.quantity;
                        }
                      });
                    });
                  },
                  child: colorList[index] == ""
                      ? Container(
                          child: Text(
                            "Mix Colors",
                            style: GoogleFonts.montserrat(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : Card(
                          margin: EdgeInsets.only(right: 20),
                          elevation:
                              selectedVariantModel.colorCode == colorList[index]
                                  ? 5
                                  : 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              18,
                            ),
                          ),
                          child: Container(
                            width: selectedVariantModel.colorCode ==
                                    colorList[index]
                                ? width * 0.1
                                : width * 0.06,
                            padding: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedVariantModel.colorCode ==
                                        colorList[index]
                                    ? Colors.transparent
                                    : Colors.grey,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: HexColor("${colorList[index]}"),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                ),
                itemCount: colorList.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
