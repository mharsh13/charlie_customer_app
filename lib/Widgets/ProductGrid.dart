import 'package:cached_network_image/cached_network_image.dart';
import 'package:charlie_customer_app/Models/ProductModel.dart';
import 'package:charlie_customer_app/Screens/ProductDetailScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProductGrid extends StatefulWidget {
  const ProductGrid({
    Key key,
    @required this.filteredList,
    @required this.height,
    @required this.width,
    @required this.auth,
  }) : super(key: key);

  final List<ProductModel> filteredList;
  final double height;
  final double width;
  final FirebaseAuth auth;

  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4 / 5,
        crossAxisSpacing: 2,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(
                product: widget.filteredList[index],
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
                      height: widget.height * 0.15,
                      width: widget.width,
                      child: CachedNetworkImage(
                        imageUrl: "${widget.filteredList[index].imageUrl[0]}",
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
                          final User user = widget.auth.currentUser;
                          final uid = user.uid;
                          setState(() {
                            widget.filteredList[index].isFav =
                                !widget.filteredList[index].isFav;
                          });
                          if (widget.filteredList[index].isFav) {
                            // CollectionReference quotes =
                            //     firestore.collection(
                            //         "products");
                            // quotes
                            //     .doc(filteredList[index]
                            //         .id)
                            //     .update({
                            //   "favorites": {
                            //     uid: true,
                            //   }
                            // });
                          } else {
                            // CollectionReference quotes =
                            //     firestore.collection(
                            //         "products");
                            // quotes
                            //     .doc(filteredList[index]
                            //         .id)
                            //     .update({
                            //   "favorites": {
                            //     uid: false,
                            //   }
                            // });
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 16,
                          child: Icon(
                            widget.filteredList[index].isFav
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
                  height: widget.height * .01,
                ),
                Container(
                  width: widget.width,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "${widget.filteredList[index].name}",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      color: HexColor("#302a30").withOpacity(.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  width: widget.width,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "${widget.filteredList[index].gender}/${widget.filteredList[index].category}",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ),
                SizedBox(
                  height: widget.height * .01,
                ),
                widget.filteredList[index].variantList == null
                    ? Container()
                    : Container(
                        width: widget.width,
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
                                  "${widget.filteredList[index].variantList[0].sellingPrice}",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(
                                    color: HexColor("#302a30"),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: widget.width * .01,
                                ),
                                Text(
                                  "${widget.filteredList[index].variantList[0].costPrice}",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                SizedBox(
                                  width: widget.width * .01,
                                ),
                                Text(
                                  "${(((double.parse(widget.filteredList[index].variantList[0].costPrice) - double.parse(widget.filteredList[index].variantList[0].sellingPrice)) / double.parse(widget.filteredList[index].variantList[0].costPrice)) * 100).toStringAsFixed(0)}" +
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
      itemCount: widget.filteredList.length,
    );
  }
}
