import 'package:charlie_customer_app/Models/ProductModel.dart';
import 'package:charlie_customer_app/Providers/ProductProvider.dart';
import 'package:charlie_customer_app/Widgets/ProductGrid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  final String searchedText;
  SearchScreen({this.searchedText});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<ProductModel> productList = [];
  List<ProductModel> filteredList = [];
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    productList = Provider.of<ProductProvider>(context, listen: false).products;
    productList.forEach((product) {
      if (product.name.toLowerCase().contains(widget.searchedText) ||
          product.category.toLowerCase().contains(widget.searchedText) ||
          product.brand.toLowerCase().contains(widget.searchedText) ||
          product.gender.toLowerCase().contains(widget.searchedText)) {
        filteredList.add(product);
      }
    });
    super.initState();
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
            "Search Results for \"${widget.searchedText}\"",
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
              height: height * .01,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "${filteredList.length} Products Found!",
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
                "Prices may vary with size and color",
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
            Container(
              height: height * 0.8,
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
