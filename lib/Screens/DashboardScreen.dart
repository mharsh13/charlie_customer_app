import 'package:charlie_customer_app/Models/CategoryModel.dart';
import 'package:charlie_customer_app/Models/ProductModel.dart';
import 'package:charlie_customer_app/Models/UserModel.dart';
import 'package:charlie_customer_app/Models/VariantModel.dart';
import 'package:charlie_customer_app/Providers/CategoryProvider.dart';
import 'package:charlie_customer_app/Providers/ProductProvider.dart';
import 'package:charlie_customer_app/Providers/UserProvider.dart';
import 'package:charlie_customer_app/Screens/ProductDetailScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserModel userInfo;
  bool _isLoading = false;
  List<CategoryModel> categoryList = [];
  List<ProductModel> productList;

  fetchUserInfo() async {
    setState(() {
      _isLoading = true;
    });
    CollectionReference userCollection =
        firestore.collection("User Information");
    await userCollection.doc(_firebaseAuth.currentUser.uid).get().then((doc) {
      Map object = doc.data();
      userInfo = UserModel(
        id: doc.id,
        phoneNumber: object["phoneNumber"],
        username: object["username"],
      );
      setState(() {
        Provider.of<UserProvider>(context, listen: false).setUser(userInfo);
        _isLoading = false;
      });
    });
  }

  fetchCategory() async {
    setState(() {
      _isLoading = true;
    });
    CollectionReference categoryCollection = firestore.collection("categories");
    categoryCollection.orderBy("category.Date").snapshots().listen((event) {
      categoryList = [];
      event.docs.forEach((category) {
        Map object = category.data();
        categoryList.add(
          CategoryModel(
            id: category.id,
            imageUrl: object["category"]["ImageUrl"],
            name: object["category"]["CategoryName"],
          ),
        );
      });
      setState(() {
        Provider.of<CategoryProvider>(context, listen: false)
            .setCategoryList(categoryList);
        _isLoading = false;
      });
    });
  }

  fetchProductInfo() async {
    setState(() {
      _isLoading = true;
    });
    CollectionReference productCollection = firestore.collection("products");
    productCollection.orderBy("product.Date").snapshots().listen((event) {
      productList = [];
      event.docs.forEach((product) {
        Map prodObject = product.data();
        var imageUrls = prodObject["product"]["ImageUrl"];
        List<String> images = [...imageUrls.map((el) => el.toString())];

        productList.add(
          ProductModel(
            id: product.id,
            brand: prodObject["product"]["brandName"],
            category: prodObject["product"]["categoryName"],
            desc: prodObject["product"]["description"],
            gender: prodObject["product"]["genderName"],
            imageUrl: images,
            isFav: false,
            name: prodObject["product"]["productName"],
          ),
        );
        CollectionReference variantCollection = firestore
            .collection("products")
            .doc(product.id)
            .collection("variants");
        variantCollection.snapshots().listen((event) {
          productList.forEach((prod) {
            if (prod.id == product.id) {
              prod.variantList = [];
            }
          });
          event.docs.forEach((variant) {
            Map variantObject = variant.data();
            productList.forEach((prod) {
              if (prod.id == product.id) {
                prod.variantList.add(
                  VariantModel(
                    colorCode: variantObject["variant"]["colorCode"],
                    colorName: variantObject["variant"]["colorName"],
                    costPrice: variantObject["variant"]["costPrice"],
                    id: variant.id,
                    quantity: variantObject["variant"]["quantity"],
                    sellingPrice: variantObject["variant"]["sellingPrice"],
                    size: variantObject["variant"]["size"],
                  ),
                );
              }
            });
          });
          setState(() {});
        });
      });
      setState(() {
        Provider.of<ProductProvider>(context, listen: false)
            .setProductList(productList);
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    fetchCategory();
    fetchUserInfo();
    fetchProductInfo();
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
        actions: [
          IconButton(
            icon: Icon(FeatherIcons.shoppingCart),
            onPressed: () {},
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
                        elevation: 0,
                        child: Container(
                          width: width * .3,
                          child: Column(
                            children: [
                              Container(
                                height: height * 0.1,
                                width: width * .3,
                                padding: EdgeInsets.all(10),
                                child: Image.network(
                                  "${categoryList[index].imageUrl}",
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
                                      color:
                                          HexColor("#302a30").withOpacity(.9),
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
                      itemCount: categoryList.length,
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
                    height: height * 1.3,
                    child: GridView.builder(
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
                                      child: Image.network(
                                        "${productList[index].imageUrl[0]}",
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
                                    "${productList[index].name}",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.montserrat(
                                      color:
                                          HexColor("#302a30").withOpacity(.9),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: width,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "${productList[index].gender}/${productList[index].category}",
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
                                productList[index].variantList == null
                                    ? Container()
                                    : Container(
                                        width: width,
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 2),
                                        child: Row(
                                          children: [
                                            Icon(
                                              MdiIcons.currencyInr,
                                              size: 18,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${productList[index].variantList[0].sellingPrice}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                  "${productList[index].variantList[0].costPrice}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.montserrat(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width * .01,
                                                ),
                                                Text(
                                                  "${(((double.parse(productList[index].variantList[0].costPrice) - double.parse(productList[index].variantList[0].sellingPrice)) / double.parse(productList[index].variantList[0].costPrice)) * 100).toStringAsFixed(0)}" +
                                                      "% off",
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                      itemCount: productList.length,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
