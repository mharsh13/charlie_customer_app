import 'package:charlie_customer_app/Models/UserModel.dart';
import 'package:charlie_customer_app/Providers/UserProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController phoneNo = new TextEditingController();
  TextEditingController username = new TextEditingController();
  final _editProf = GlobalKey<FormState>();

  UserModel userInfo;
  bool _isLoading = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    userInfo = Provider.of<UserProvider>(context, listen: false).userInfo;
    phoneNo.text = userInfo.phoneNumber;
    username.text = userInfo.username;
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
            "Edit Profile",
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _editProf,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.04,
                ),
                TextFormField(
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Enter in Field";
                    } else
                      return null;
                  },
                  controller: username,
                  cursorColor: HexColor('#f55d5d').withOpacity(.3),
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: HexColor('#f55d5d').withOpacity(.6),
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.pink[100],
                      ),
                    ),
                    labelText: 'Enter username',
                  ),
                ),
                TextFormField(
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Enter in Field";
                    } else
                      return null;
                  },
                  controller: phoneNo,
                  readOnly: true,
                  cursorColor: HexColor('#f55d5d').withOpacity(.3),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: HexColor('#f55d5d').withOpacity(.6),
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.pink[100],
                      ),
                    ),
                    labelText: 'Enter phone number',
                  ),
                ),
                SizedBox(
                  height: height * 0.1,
                ),
                Center(
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      CollectionReference userCollection =
                          firestore.collection("User Information");
                      await userCollection
                          .doc(userInfo.id)
                          .update({"username": username.text}).then((value) {
                        setState(() {
                          _isLoading = false;
                        });
                        final snackBar = SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text('Username Changed'),
                          backgroundColor: HexColor("#f55d5d").withOpacity(0.8),
                          action: SnackBarAction(
                            label: 'Ok',
                            textColor: Colors.white,
                            onPressed: () {},
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          snackBar,
                        );
                      });
                    },
                    child: Container(
                      width: width * 0.6,
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: HexColor("#f55d5d").withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _isLoading
                          ? SpinKitThreeBounce(
                              color: Colors.white,
                              size: 24,
                            )
                          : Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Save changes",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  Icon(
                                    FeatherIcons.save,
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
      ),
    );
  }
}
