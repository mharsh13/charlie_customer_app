import 'package:charlie_customer_app/Models/AddressModel.dart';
import 'package:charlie_customer_app/Models/UserModel.dart';
import 'package:charlie_customer_app/Providers/UserProvider.dart';
import 'package:charlie_customer_app/Screens/AddAddressScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class AddressBookScreen extends StatefulWidget {
  @override
  _AddressBookScreenState createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  UserModel userInfo;
  bool _isLoading = false;
  List<AddressModel> addressList = [];
  void fetchAddress() {
    setState(() {
      _isLoading = true;
    });
    CollectionReference addressCollection = firestore
        .collection("User Information")
        .doc(userInfo.id)
        .collection("User Address");
    addressCollection.snapshots().listen((event) {
      addressList = [];
      event.docs.forEach((doc) {
        Map object = doc.data();
        addressList.add(
          AddressModel(
            address: object["address"],
            id: doc.id,
            phoneNumber: object["phoneNumber"],
            pincode: object["pincode"],
            username: object["username"],
          ),
        );
      });
      setState(() {
        var updateUser = UserModel(
          addressList: addressList,
          cartList: userInfo.cartList,
          id: userInfo.id,
          phoneNumber: userInfo.phoneNumber,
          userFavList: userInfo.userFavList,
          username: userInfo.username,
        );
        Provider.of<UserProvider>(context, listen: false).setUser(updateUser);
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    userInfo = Provider.of<UserProvider>(context, listen: false).userInfo;
    fetchAddress();
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
            "Address Book",
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddAddressScreen(
                    isEdit: false,
                  ),
                ),
              );
            },
            icon: Icon(
              FeatherIcons.plus,
              color: Colors.white,
            ),
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
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: height,
                    child: addressList.isEmpty
                        ? Center(
                            child: Text(
                              "No address added!",
                              style: GoogleFonts.montserrat(
                                color: HexColor("#302a30"),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemBuilder: (context, index) => Card(
                              elevation: 10,
                              margin:
                                  EdgeInsets.only(left: 20, right: 20, top: 30),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                width: width,
                                child: Column(
                                  children: [
                                    Container(
                                      width: width * 0.8,
                                      child: Text(
                                        "${addressList[index].username}",
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    Container(
                                      width: width * 0.8,
                                      child: Text(
                                        "${addressList[index].address}, ${addressList[index].pincode}",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: width * 0.8,
                                      child: Text(
                                        "Mobile Number : ${addressList[index].phoneNumber}",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddAddressScreen(
                                                    isEdit: true,
                                                    selectedAddress:
                                                        addressList[index],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              child: Text(
                                                "EDIT",
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.05,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              CollectionReference
                                                  userCollection = firestore
                                                      .collection(
                                                          "User Information")
                                                      .doc(userInfo.id)
                                                      .collection(
                                                          "User Address");
                                              await userCollection
                                                  .doc(addressList[index].id)
                                                  .delete()
                                                  .then((value) {
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              });
                                            },
                                            child: Container(
                                              child: Text(
                                                "DELETE",
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 14,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            itemCount: addressList.length,
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
