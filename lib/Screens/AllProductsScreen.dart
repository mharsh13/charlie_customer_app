import 'package:charlie_customer_app/Models/BrandModel.dart';
import 'package:charlie_customer_app/Models/CategoryModel.dart';
import 'package:charlie_customer_app/Models/GenderModel.dart';
import 'package:charlie_customer_app/Models/ProductModel.dart';
import 'package:charlie_customer_app/Providers/BrandProvider.dart';
import 'package:charlie_customer_app/Providers/CategoryProvider.dart';
import 'package:charlie_customer_app/Providers/GenderProvider.dart';
import 'package:charlie_customer_app/Providers/ProductProvider.dart';
import 'package:charlie_customer_app/Widgets/ProductGrid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';

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
    productList = Provider.of<ProductProvider>(context, listen: false).products;
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
          Column(
            children: [
              IconButton(
                icon: Icon(
                  MdiIcons.sortVariant,
                  color: Colors.white,
                  size: 26,
                ),
                onPressed: () {
                  showBarModalBottomSheet(
                    context: context,
                    builder: (context) => StatefulBuilder(
                      builder: (context, setModalState) =>
                          SingleChildScrollView(
                        child: Container(
                          height: height * 0.3,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
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
                                    filteredList.sort(
                                        (a, b) => b.date.compareTo(a.date));
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
                                    filteredList.sort((a, b) =>
                                        a.variantList[0].sellingPrice.compareTo(
                                            b.variantList[0].sellingPrice));
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
                                    filteredList.sort((a, b) =>
                                        b.variantList[0].sellingPrice.compareTo(
                                            a.variantList[0].sellingPrice));
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
            ],
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  FeatherIcons.filter,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => StatefulBuilder(
                      builder: (context, setModalState) => Container(
                        height: height,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                    text:
                                                        "Selected Categories : ",
                                                    style: GoogleFonts.roboto(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  textAlign: TextAlign.left,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                    onChange: (state) => setState(
                                        () => categoryValue = state.value),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                      for (var string
                                                          in brandValue)
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                    onChange: (state) => setState(
                                        () => brandValue = state.value),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                    onChange: (state) => setState(
                                        () => genderValue = state.value),
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
                                          color: HexColor("#f55d5d")
                                              .withOpacity(0.8),
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

                                    var commonValues = map.keys.where(
                                        (key) => map[key] == temps.length);
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
                                      color:
                                          HexColor("#f55d5d").withOpacity(0.8),
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
              if (categoryValue.length +
                      brandValue.length +
                      genderValue.length !=
                  0)
                Positioned(
                  right: 5,
                  top: 5,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.yellow,
                    child: Center(
                      child: Text(
                        "${categoryValue.length + brandValue.length + genderValue.length}",
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ],
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
                "Results",
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
              child: filteredList.isEmpty
                  ? Center(
                      child: Text(
                        "No Items found!",
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
