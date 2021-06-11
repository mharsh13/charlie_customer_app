import 'package:charlie_customer_app/Models/ProductModel.dart';
import 'package:charlie_customer_app/Providers/ProductProvider.dart';
import 'package:charlie_customer_app/Widgets/ProductGrid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<ProductModel> productList = [];
  List<ProductModel> filteredList = [];
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    productList = Provider.of<ProductProvider>(context, listen: false).products;
    productList.forEach((product) {
      if (product.isFav) {
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
                "Wishlist",
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
                "See your favorite items here",
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
              child: filteredList.isEmpty
                  ? Center(
                      child: Text(
                        "No Items added",
                        style: GoogleFonts.montserrat(
                          color: HexColor("#302a30"),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  : ProductGrid(
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
