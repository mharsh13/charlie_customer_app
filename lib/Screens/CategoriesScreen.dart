import 'package:cached_network_image/cached_network_image.dart';
import 'package:charlie_customer_app/Models/BrandModel.dart';
import 'package:charlie_customer_app/Models/CategoryModel.dart';
import 'package:charlie_customer_app/Models/GenderModel.dart';
import 'package:charlie_customer_app/Providers/BrandProvider.dart';
import 'package:charlie_customer_app/Providers/CategoryProvider.dart';
import 'package:charlie_customer_app/Providers/GenderProvider.dart';
import 'package:charlie_customer_app/Screens/BrandDetailScreen.dart';
import 'package:charlie_customer_app/Screens/CategoryDetailScreen.dart';
import 'package:charlie_customer_app/Screens/GenderDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<CategoryModel> categoryList = [];
  List<BrandModel> brandList = [];
  List<GenderModel> genderList = [];

  @override
  void initState() {
    categoryList =
        Provider.of<CategoryProvider>(context, listen: false).categoryList;
    brandList = Provider.of<BrandProvider>(context, listen: false).brandList;
    genderList = Provider.of<GenderProvider>(context, listen: false).genderList;
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height * .01,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Explore!",
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
              "Multi-branded store with various categories",
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
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Gender",
              style: GoogleFonts.montserrat(
                color: HexColor("#302a30").withOpacity(.9),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: height * .01,
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            height: height * 0.15,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GenderDetailScreen(
                        selectedGender: genderList[index],
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 0,
                  child: Container(
                    width: width * .3,
                    child: Column(
                      children: [
                        Container(
                          height: height * 0.1,
                          width: width * .3,
                          child: CachedNetworkImage(
                            imageUrl: "${genderList[index].imageUrl}",
                            placeholder: (context, url) => SpinKitRing(
                              color: Colors.grey,
                              lineWidth: 3,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        Container(
                          width: width * .3,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Center(
                            child: Text(
                              "${genderList[index].name}",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                color: HexColor("#302a30").withOpacity(.9),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              itemCount: genderList.length,
            ),
          ),
          SizedBox(
            height: height * .01,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Categories",
              style: GoogleFonts.montserrat(
                color: HexColor("#302a30").withOpacity(.9),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: height * .01,
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            height: height * 0.15,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CategoryDetailScreen(
                        selectedCategory: categoryList[index],
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 0,
                  child: Container(
                    width: width * .3,
                    child: Column(
                      children: [
                        Container(
                          height: height * 0.1,
                          width: width * .3,
                          padding: EdgeInsets.all(10),
                          child: CachedNetworkImage(
                            imageUrl: "${categoryList[index].imageUrl}",
                            placeholder: (context, url) => SpinKitRing(
                              color: Colors.grey,
                              lineWidth: 3,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        Container(
                          width: width * .3,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Center(
                            child: Text(
                              "${categoryList[index].name}",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                color: HexColor("#302a30").withOpacity(.9),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              itemCount: categoryList.length,
            ),
          ),
          SizedBox(
            height: height * .01,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Brands",
              style: GoogleFonts.montserrat(
                color: HexColor("#302a30").withOpacity(.9),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: height * .01,
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            height: height * 0.15,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BrandDetailScreen(
                        selectedBrand: brandList[index],
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 0,
                  child: Container(
                    width: width * .3,
                    child: Column(
                      children: [
                        Container(
                          height: height * 0.1,
                          width: width * .3,
                          padding: EdgeInsets.all(10),
                          child: CachedNetworkImage(
                            imageUrl: "${brandList[index].imageUrl}",
                            placeholder: (context, url) => SpinKitRing(
                              color: Colors.grey,
                              lineWidth: 3,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        Container(
                          width: width * .3,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Center(
                            child: Text(
                              "${brandList[index].name}",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                color: HexColor("#302a30").withOpacity(.9),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              itemCount: brandList.length,
            ),
          ),
        ],
      ),
    );
  }
}
