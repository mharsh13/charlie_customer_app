import 'package:cached_network_image/cached_network_image.dart';
import 'package:charlie_customer_app/Models/ProductModel.dart';
import 'package:charlie_customer_app/Providers/ProductProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'ProductDetailScreen.dart';

class AllProductsScreen extends StatefulWidget {
  @override
  _AllProductsScreenState createState() => _AllProductsScreenState();
}

enum SingingCharacter { priceUp, priceDown, latest }

class _AllProductsScreenState extends State<AllProductsScreen> {
  SingingCharacter _sort = SingingCharacter.latest;
  List<ProductModel> productList = [];
  List<ProductModel> filteredList = [];
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    productList =
        Provider.of<ProductProvider>(context, listen: false).productList;
    filteredList = productList;
    filteredList.sort((a, b) => b.date.compareTo(a.date));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
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
        title: Text(
          "All Products",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              MdiIcons.sortVariant,
              color: Colors.white,
              size: 22,
            ),
            onPressed: () {
              showBarModalBottomSheet(
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (context, setModalState) => SingleChildScrollView(
                    child: Container(
                      height: height * 0.3,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              "SORT BY",
                              style: GoogleFonts.montserrat(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Divider(),
                          RadioListTile(
                            value: SingingCharacter.latest,
                            groupValue: _sort,
                            title: Text(
                              "Newest First",
                              style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            onChanged: (SingingCharacter value) {
                              setModalState(() {
                                _sort = value;
                              });
                              setState(() {
                                filteredList
                                    .sort((a, b) => b.date.compareTo(a.date));
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                          RadioListTile(
                            value: SingingCharacter.priceDown,
                            groupValue: _sort,
                            title: Text(
                              "Price -- Low to High",
                              style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            onChanged: (SingingCharacter value) {
                              setModalState(() {
                                _sort = value;
                              });
                              setState(() {
                                filteredList.sort((a, b) => a
                                    .variantList[0].sellingPrice
                                    .compareTo(b.variantList[0].sellingPrice));
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                          RadioListTile(
                            value: SingingCharacter.priceUp,
                            groupValue: _sort,
                            title: Text(
                              "Price -- High to Low",
                              style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            onChanged: (SingingCharacter value) {
                              setModalState(() {
                                _sort = value;
                              });
                              setState(() {
                                filteredList.sort((a, b) => b
                                    .variantList[0].sellingPrice
                                    .compareTo(a.variantList[0].sellingPrice));
                              });
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              FeatherIcons.filter,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 4 / 5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                    product: productList[index],
                  ),
                ),
              );
            },
            child: Card(
              child: Container(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: height * 0.15,
                          width: width,
                          child: CachedNetworkImage(
                            imageUrl: "${filteredList[index].imageUrl[0]}",
                            placeholder: (context, url) => SpinKitRing(
                              color: Colors.grey,
                              lineWidth: 3,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: InkWell(
                            onTap: () {
                              final User user = auth.currentUser;
                              final uid = user.uid;
                              setState(() {
                                filteredList[index].isFav =
                                    !filteredList[index].isFav;
                              });
                              if (filteredList[index].isFav) {
                                CollectionReference quotes =
                                    firestore.collection("products");
                                quotes.doc(filteredList[index].id).update({
                                  "favorites": {
                                    uid: true,
                                  }
                                });
                              } else {
                                CollectionReference quotes =
                                    firestore.collection("products");
                                quotes.doc(filteredList[index].id).update({
                                  "favorites": {
                                    uid: false,
                                  }
                                });
                              }
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 16,
                              child: Icon(
                                filteredList[index].isFav
                                    ? MdiIcons.heart
                                    : MdiIcons.heartOutline,
                                color: HexColor("#f55d5d"),
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "${filteredList[index].name}",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          color: HexColor("#302a30").withOpacity(.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "${filteredList[index].gender}/${filteredList[index].category}",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    filteredList[index].variantList == null
                        ? Container()
                        : Container(
                            width: width,
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: Row(
                              children: [
                                Icon(
                                  MdiIcons.currencyInr,
                                  size: 18,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${filteredList[index].variantList[0].sellingPrice}",
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
                                      "${filteredList[index].variantList[0].costPrice}",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * .01,
                                    ),
                                    Text(
                                      "${(((double.parse(filteredList[index].variantList[0].costPrice) - double.parse(filteredList[index].variantList[0].sellingPrice)) / double.parse(filteredList[index].variantList[0].costPrice)) * 100).toStringAsFixed(0)}" +
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
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
          itemCount: filteredList.length,
        ),
      ),
    );
  }
}
