import 'package:cached_network_image/cached_network_image.dart';
import 'package:charlie_customer_app/Models/CategoryModel.dart';
import 'package:charlie_customer_app/Models/ProductModel.dart';
import 'package:charlie_customer_app/Models/UserModel.dart';
import 'package:charlie_customer_app/Providers/CategoryProvider.dart';
import 'package:charlie_customer_app/Providers/ProductProvider.dart';
import 'package:charlie_customer_app/Providers/UserProvider.dart';
import 'package:charlie_customer_app/Screens/AllProductsScreen.dart';
import 'package:charlie_customer_app/Screens/CartScreen.dart';
import 'package:charlie_customer_app/Screens/ProductDetailScreen.dart';
import 'package:charlie_customer_app/Screens/SearchScreen.dart';
import 'package:charlie_customer_app/Widgets/ProductGrid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TextEditingController searchController = new TextEditingController();
  var searchfocusNode = FocusNode();

  UserModel userInfo;
  bool _isLoading = false;

  List<ProductModel> productList = [];
  List<ProductModel> filteredList = [];
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void fetch() {
    userInfo = Provider.of<UserProvider>(context, listen: false).userInfo;

    productList = Provider.of<ProductProvider>(context, listen: false).products;
    filteredList = productList;

    filteredList.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    fetch();
    return Scaffold(
      backgroundColor: HexColor("#F7EBF0"),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: HexColor("#F7EBF0"),
        title: Container(
          width: width * 0.25,
          child: Image.asset(
            "Assets/Logo.png",
            fit: BoxFit.cover,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(FeatherIcons.shoppingCart),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CartScreen(),
                ),
              );
            },
          )
        ],
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
                    height: height * .01,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      userInfo != null
                          ? "Hello " +
                              "${userInfo.username.substring(0, userInfo.username.indexOf(" "))}!"
                          : "Hello!",
                      style: GoogleFonts.montserrat(
                        color: HexColor("#302a30").withOpacity(.8),
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Welcome to Charlie - A discount shopee",
                      style: GoogleFonts.montserrat(
                        color: HexColor("#302a30"),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  Center(
                    child: Card(
                      elevation: 0,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              MdiIcons.magnify,
                              color: HexColor("#f55d5d"),
                            ),
                            SizedBox(
                              width: width * .02,
                            ),
                            Container(
                              width: width * .7,
                              child: TextFormField(
                                focusNode: searchfocusNode,
                                controller: searchController,
                                onEditingComplete: () {
                                  if (searchController.text != "")
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => SearchScreen(
                                          searchedText: searchController.text,
                                        ),
                                      ),
                                    );
                                },
                                textInputAction: TextInputAction.search,
                                keyboardType: TextInputType.text,
                                cursorColor:
                                    HexColor("#f55d5d").withOpacity(.8),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  suffix: GestureDetector(
                                    onTap: () {
                                      searchController.clear();
                                      searchfocusNode.unfocus();
                                    },
                                    child: Icon(
                                      MdiIcons.close,
                                      color: Colors.grey,
                                      size: 18,
                                    ),
                                  ),
                                  hintText: "Search the clothes you need",
                                  hintStyle: GoogleFonts.roboto(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Popular Items",
                          style: GoogleFonts.montserrat(
                            color: HexColor("#302a30").withOpacity(.9),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AllProductsScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "See All",
                            style: GoogleFonts.montserrat(
                              color: HexColor("#f55d5d").withOpacity(.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * .01,
                  ),
                  filteredList.isEmpty
                      ? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: Text(
                            "No Popular Item here! Tap \"See All\" to explore more!",
                            style: GoogleFonts.montserrat(
                              color: HexColor("#302a30"),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          height: height * .28 * (filteredList.length / 2),
                          child: ProductGrid(
                            filteredList: filteredList,
                            height: height,
                            width: width,
                            auth: auth,
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
