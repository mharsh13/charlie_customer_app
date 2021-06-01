import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TextEditingController searchController = new TextEditingController();
  var searchfocusNode = FocusNode();
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
        actions: [
          IconButton(
            icon: Icon(FeatherIcons.shoppingCart),
            onPressed: () {},
          )
        ],
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
                "Hello Harsh!",
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
                          cursorColor: HexColor("#f55d5d").withOpacity(.8),
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
                    "Categories",
                    style: GoogleFonts.montserrat(
                      color: HexColor("#302a30").withOpacity(.9),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "See All",
                    style: GoogleFonts.montserrat(
                      color: HexColor("#f55d5d").withOpacity(.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
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
                itemBuilder: (context, index) => Card(
                  child: Container(
                    width: width * .3,
                    child: Column(
                      children: [
                        Container(
                          height: height * 0.1,
                          width: width * .3,
                          child: Image.network(
                            "https://i.picsum.photos/id/464/200/200.jpg?hmac=rT0rkzkukXVK3LYD1qHhc-Yqk0dFyIYoFk8wuNpCkAY",
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
                              "Tshirt",
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
                itemCount: 4,
              ),
            ),
            SizedBox(
              height: height * .02,
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
                  Text(
                    "See All",
                    style: GoogleFonts.montserrat(
                      color: HexColor("#f55d5d").withOpacity(.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * .01,
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              height: height * 0.4,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 4 / 5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) => Card(
                  child: Container(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: height * 0.15,
                              width: width,
                              child: Image.network(
                                "https://i.picsum.photos/id/1061/200/300.jpg?hmac=wvuhffnNEQ5g9Q0f7LZiEvh6JEJqL3ppJuHT2M_YJLI",
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 10,
                              bottom: 10,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 16,
                                child: Icon(
                                  FeatherIcons.heart,
                                  color: HexColor("#f55d5d"),
                                  size: 18,
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
                            "Denim Shirt",
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
                            "Men/Shirts",
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
                        Container(
                          width: width,
                          padding: EdgeInsets.symmetric(horizontal: 8),
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
                                    "300",
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
                                    "350",
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
                        ),
                      ],
                    ),
                  ),
                ),
                itemCount: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
