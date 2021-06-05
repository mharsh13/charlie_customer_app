import 'package:cached_network_image/cached_network_image.dart';
import 'package:charlie_customer_app/Models/BrandModel.dart';
import 'package:charlie_customer_app/Models/CategoryModel.dart';
import 'package:charlie_customer_app/Models/GenderModel.dart';
import 'package:charlie_customer_app/Models/ProductModel.dart';
import 'package:charlie_customer_app/Providers/BrandProvider.dart';
import 'package:charlie_customer_app/Providers/CategoryProvider.dart';
import 'package:charlie_customer_app/Providers/GenderProvider.dart';
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
import 'package:smart_select/smart_select.dart';

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
  List<CategoryModel> categoryList = [];
  List<BrandModel> brandList = [];
  List<GenderModel> genderList = [];
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> categoryValue = [];
  List<S2Choice<String>> categoriesChips = [];
  List<String> brandValue = [];
  List<S2Choice<String>> brandsChips = [];
  List<String> genderValue = [];
  List<S2Choice<String>> genderChips = [];

  @override
  void initState() {
    productList =
        Provider.of<ProductProvider>(context, listen: false).productList;
    categoryList =
        Provider.of<CategoryProvider>(context, listen: false).categoryList;
    brandList = Provider.of<BrandProvider>(context, listen: false).brandList;
    genderList = Provider.of<GenderProvider>(context, listen: false).genderList;
    filteredList = productList;
    filteredList.sort((a, b) => b.date.compareTo(a.date));
    categoryList.asMap().forEach((index, category) {
      categoriesChips.add(
        S2Choice<String>(value: category.name, title: category.name),
      );
    });
    brandList.asMap().forEach((index, brand) {
      brandsChips.add(
        S2Choice<String>(value: brand.name, title: brand.name),
      );
    });
    genderList.asMap().forEach((index, gender) {
      genderChips.add(
        S2Choice<String>(value: gender.name, title: gender.name),
      );
    });
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
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (context, setModalState) => Container(
                    height: height,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                "FILTER BY",
                                style: GoogleFonts.montserrat(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            IconButton(
                              iconSize: 22,
                              splashRadius: 20,
                              icon: Icon(
                                MdiIcons.close,
                                size: 22,
                                color: HexColor("#f55d5d").withOpacity(0.8),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        ),
                        Divider(),
                        Container(
                          height: height * 0.35,
                          child: ListView(
                            children: [
                              SmartSelect<String>.multiple(
                                title: "Categories",
                                modalTitle: "Choose Categories",
                                tileBuilder: (context, state) => Container(
                                  child: InkWell(
                                    onTap: () {
                                      state.showModal();
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Categories",
                                              style: GoogleFonts.roboto(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Icon(
                                              FeatherIcons.chevronRight,
                                              color: Colors.grey,
                                              size: 20,
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: height * 0.02,
                                        ),
                                        if (categoryValue.isNotEmpty)
                                          Container(
                                            width: width,
                                            child: Text.rich(
                                              TextSpan(
                                                children: [
                                                  for (var string
                                                      in categoryValue)
                                                    TextSpan(
                                                      text: string + " ",
                                                    )
                                                ],
                                                text: "Selected Categories : ",
                                                style: GoogleFonts.roboto(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                ),
                                value: categoryValue,
                                choiceItems: categoriesChips,
                                choiceType: S2ChoiceType.chips,
                                modalType: S2ModalType.bottomSheet,
                                choiceStyle: S2ChoiceStyle(
                                  activeColor:
                                      HexColor("#f55d5d").withOpacity(0.8),
                                ),
                                onChange: (state) =>
                                    setState(() => categoryValue = state.value),
                              ),
                              Divider(),
                              SmartSelect<String>.multiple(
                                title: "Brands",
                                modalTitle: "Choose Brands",
                                tileBuilder: (context, state) => Container(
                                  child: InkWell(
                                    onTap: () {
                                      state.showModal();
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Brands",
                                              style: GoogleFonts.roboto(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Icon(
                                              FeatherIcons.chevronRight,
                                              color: Colors.grey,
                                              size: 20,
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: height * 0.02,
                                        ),
                                        if (brandValue.isNotEmpty)
                                          Container(
                                            width: width,
                                            child: Text.rich(
                                              TextSpan(
                                                children: [
                                                  for (var string in brandValue)
                                                    TextSpan(
                                                      text: string + " ",
                                                    )
                                                ],
                                                text: "Selected Brands : ",
                                                style: GoogleFonts.roboto(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                ),
                                value: brandValue,
                                choiceItems: brandsChips,
                                choiceType: S2ChoiceType.chips,
                                modalType: S2ModalType.bottomSheet,
                                choiceStyle: S2ChoiceStyle(
                                  activeColor:
                                      HexColor("#f55d5d").withOpacity(0.8),
                                ),
                                onChange: (state) =>
                                    setState(() => brandValue = state.value),
                              ),
                              Divider(),
                              SmartSelect<String>.multiple(
                                title: "Gender",
                                modalTitle: "Choose Gender",
                                tileBuilder: (context, state) => Container(
                                  child: InkWell(
                                    onTap: () {
                                      state.showModal();
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Gender",
                                              style: GoogleFonts.roboto(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Icon(
                                              FeatherIcons.chevronRight,
                                              color: Colors.grey,
                                              size: 20,
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: height * 0.02,
                                        ),
                                        if (genderValue.isNotEmpty)
                                          Container(
                                            width: width,
                                            child: Text.rich(
                                              TextSpan(
                                                children: [
                                                  for (var string
                                                      in genderValue)
                                                    TextSpan(
                                                      text: string + " ",
                                                    )
                                                ],
                                                text: "Selected gender : ",
                                                style: GoogleFonts.roboto(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                ),
                                value: genderValue,
                                choiceItems: genderChips,
                                choiceType: S2ChoiceType.chips,
                                modalType: S2ModalType.bottomSheet,
                                choiceStyle: S2ChoiceStyle(
                                  activeColor:
                                      HexColor("#f55d5d").withOpacity(0.8),
                                ),
                                onChange: (state) =>
                                    setState(() => genderValue = state.value),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                categoryValue = [];
                                brandValue = [];
                                genderValue = [];
                                setModalState(() {});
                              },
                              child: Container(
                                width: width * 0.3,
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey[200],
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Clear Filters",
                                    style: GoogleFonts.poppins(
                                      color:
                                          HexColor("#f55d5d").withOpacity(0.8),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                filteredList = [];
                                List<ProductModel> tempList1 = [];
                                if (categoryValue.isNotEmpty) {
                                  categoryValue.forEach((category) {
                                    productList.forEach((product) {
                                      if (product.category == category) {
                                        tempList1.add(product);
                                      }
                                    });
                                  });
                                } else {
                                  tempList1 = productList;
                                }
                                List<ProductModel> tempList2 = [];
                                if (brandValue.isNotEmpty) {
                                  brandValue.forEach((brand) {
                                    productList.forEach((product) {
                                      if (product.brand == brand) {
                                        tempList2.add(product);
                                      }
                                    });
                                  });
                                } else {
                                  tempList2 = productList;
                                }
                                List<ProductModel> tempList3 = [];
                                if (genderValue.isNotEmpty) {
                                  genderValue.forEach((gender) {
                                    productList.forEach((product) {
                                      if (product.gender == gender) {
                                        tempList3.add(product);
                                      }
                                    });
                                  });
                                } else {
                                  tempList3 = productList;
                                }
                                List<List> temps = [
                                  tempList1,
                                  tempList2,
                                  tempList3
                                ];
                                Map map = Map();
                                for (List l in temps) {
                                  l.forEach((item) => map[item] =
                                      map.containsKey(item)
                                          ? (map[item] + 1)
                                          : 1);
                                }

                                var commonValues = map.keys
                                    .where((key) => map[key] == temps.length);
                                commonValues.forEach((product) {
                                  filteredList.add(product);
                                });
                                setState(() {});

                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: width * 0.3,
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: HexColor("#f55d5d").withOpacity(0.8),
                                ),
                                child: Center(
                                  child: Text(
                                    "Show results",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
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
