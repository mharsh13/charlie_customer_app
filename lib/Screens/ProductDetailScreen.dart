import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class ProductDetailScreen extends StatefulWidget {
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

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
              itemCount: 4,
              currentPageNotifier: _currentPageNotifier,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
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
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        child: Center(
                          child: Text(
                            "4",
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
                              setState(() {});
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
                ],
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Center(
                child: InkWell(
                  onTap: () {},
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
                    itemCount: 4,
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Image.network(
                          "https://i.picsum.photos/id/1061/200/300.jpg?hmac=wvuhffnNEQ5g9Q0f7LZiEvh6JEJqL3ppJuHT2M_YJLI",
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
                      "Denim shirt",
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
                          icon: Icon(FeatherIcons.heart),
                          onPressed: () {},
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
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ",
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
              height: height * 0.08,
              padding: EdgeInsets.only(left: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Center(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Text(
                      "XL",
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                itemCount: 4,
              ),
            ),
            Container(
              width: width,
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
              height: height * 0.08,
              padding: EdgeInsets.only(left: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Center(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Icon(
                      FeatherIcons.check,
                      size: 14,
                    ),
                  ),
                ),
                itemCount: 4,
              ),
            )
          ],
        ),
      ),
    );
  }
}
