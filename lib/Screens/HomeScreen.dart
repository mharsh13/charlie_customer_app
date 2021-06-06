import 'package:charlie_customer_app/Models/BrandModel.dart';
import 'package:charlie_customer_app/Models/CategoryModel.dart';
import 'package:charlie_customer_app/Models/GenderModel.dart';
import 'package:charlie_customer_app/Models/ProductModel.dart';
import 'package:charlie_customer_app/Models/UserModel.dart';
import 'package:charlie_customer_app/Models/VariantModel.dart';
import 'package:charlie_customer_app/Providers/BrandProvider.dart';
import 'package:charlie_customer_app/Providers/CategoryProvider.dart';
import 'package:charlie_customer_app/Providers/GenderProvider.dart';
import 'package:charlie_customer_app/Providers/ProductProvider.dart';
import 'package:charlie_customer_app/Providers/UserProvider.dart';
import 'package:charlie_customer_app/Screens/CategoriesScreen.dart';
import 'package:charlie_customer_app/Screens/DashboardScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserModel userInfo;
  bool _isLoading = false;
  List<CategoryModel> categoryList = [];
  List<ProductModel> productList = [];
  List<BrandModel> brandList = [];
  List<GenderModel> genderList = [];

  fetchUserInfo() async {
    setState(() {
      _isLoading = true;
    });
    CollectionReference userCollection =
        firestore.collection("User Information");
    userCollection.snapshots().listen((event) {
      event.docs.forEach((doc) {
        Map object = doc.data();
        if (doc.id == _firebaseAuth.currentUser.uid) {
          userInfo = UserModel(
            id: doc.id,
            phoneNumber: object["phoneNumber"],
            username: object["username"],
          );
        }
      });
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

  fetchBrand() async {
    setState(() {
      _isLoading = true;
    });
    CollectionReference categoryCollection = firestore.collection("brands");
    categoryCollection.orderBy("brand.Date").snapshots().listen((event) {
      brandList = [];
      event.docs.forEach((brand) {
        Map object = brand.data();
        brandList.add(
          BrandModel(
            id: brand.id,
            imageUrl: object["brand"]["ImageUrl"],
            name: object["brand"]["BrandName"],
          ),
        );
      });
      setState(() {
        Provider.of<BrandProvider>(context, listen: false)
            .setBrandList(brandList);
        _isLoading = false;
      });
    });
  }

  fetchGender() async {
    setState(() {
      _isLoading = true;
    });
    CollectionReference categoryCollection = firestore.collection("gender");
    categoryCollection.orderBy("gender.Date").snapshots().listen((event) {
      genderList = [];
      event.docs.forEach((gender) {
        Map object = gender.data();
        genderList.add(
          GenderModel(
            id: gender.id,
            imageUrl: object["gender"]["ImageUrl"],
            name: object["gender"]["GenderName"],
          ),
        );
      });
      setState(() {
        Provider.of<GenderProvider>(context, listen: false)
            .setGenderList(genderList);
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
        bool isFavorite = false;
        if (prodObject.containsKey("favorites")) {
          isFavorite = prodObject["favorites"][_firebaseAuth.currentUser.uid];
        }

        productList.add(
          ProductModel(
            id: product.id,
            brand: prodObject["product"]["brandName"],
            category: prodObject["product"]["categoryName"],
            desc: prodObject["product"]["description"],
            gender: prodObject["product"]["genderName"],
            imageUrl: images,
            isFav: isFavorite,
            name: prodObject["product"]["productName"],
            date: prodObject["product"]["Date"],
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
          setState(() {
            Provider.of<ProductProvider>(context, listen: false)
                .setProductList(productList);
          });
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
    super.initState();
    tabController = new TabController(length: 4, vsync: this, initialIndex: 0);
    fetchCategory();
    fetchUserInfo();
    fetchProductInfo();
    fetchBrand();
    fetchGender();
  }

//dispose method for good practice.
  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  var index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#F7EBF0"),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: index,
        selectedItemColor: HexColor("#f55d5d").withOpacity(.8),
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          index = i;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              FeatherIcons.home,
              size: 18,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FeatherIcons.grid,
              size: 18,
            ),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FeatherIcons.heart,
              size: 18,
            ),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FeatherIcons.user,
              size: 18,
            ),
            label: "Profile",
          ),
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
          : index == 0
              ? DashboardScreen()
              : index == 1
                  ? CategoriesScreen()
                  : Container(),
    );
  }
}
