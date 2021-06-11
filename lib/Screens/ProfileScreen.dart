import 'package:charlie_customer_app/Authentication/LoginScreen.dart';
import 'package:charlie_customer_app/Screens/CartScreen.dart';
import 'package:charlie_customer_app/Screens/EditProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void logoutDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(
          'Are you sure you want to logout?',
        ),
        actions: [
          TextButton(
            child: Text(
              "Cancel",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text(
              "Sure",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: HexColor("282b50"),
                ),
              ),
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
          )
        ],
      ),
    );
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
                "My Account",
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
                "Manage your orders and profile here",
                style: GoogleFonts.montserrat(
                  color: HexColor("#302a30"),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            Divider(),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Icon(
                      FeatherIcons.user,
                      color: HexColor("#302a30"),
                      size: 30,
                    ),
                    SizedBox(
                      width: width * 0.1,
                    ),
                    Text(
                      "My Profile",
                      style: GoogleFonts.montserrat(
                        color: HexColor("#302a30").withOpacity(.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CartScreen(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Icon(
                      FeatherIcons.shoppingCart,
                      color: HexColor("#302a30"),
                      size: 30,
                    ),
                    SizedBox(
                      width: width * 0.1,
                    ),
                    Text(
                      "Cart",
                      style: GoogleFonts.montserrat(
                        color: HexColor("#302a30").withOpacity(.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Icon(
                    FeatherIcons.package,
                    color: HexColor("#302a30"),
                    size: 30,
                  ),
                  SizedBox(
                    width: width * 0.1,
                  ),
                  Text(
                    "Order History",
                    style: GoogleFonts.montserrat(
                      color: HexColor("#302a30").withOpacity(.8),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Icon(
                    FeatherIcons.book,
                    color: HexColor("#302a30"),
                    size: 30,
                  ),
                  SizedBox(
                    width: width * 0.1,
                  ),
                  Text(
                    "Address Book",
                    style: GoogleFonts.montserrat(
                      color: HexColor("#302a30").withOpacity(.8),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Icon(
                    FeatherIcons.phone,
                    color: HexColor("#302a30"),
                    size: 30,
                  ),
                  SizedBox(
                    width: width * 0.1,
                  ),
                  Text(
                    "Contact Us",
                    style: GoogleFonts.montserrat(
                      color: HexColor("#302a30").withOpacity(.8),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Icon(
                    MdiIcons.mapMarkerOutline,
                    color: HexColor("#302a30"),
                    size: 30,
                  ),
                  SizedBox(
                    width: width * 0.1,
                  ),
                  Text(
                    "About",
                    style: GoogleFonts.montserrat(
                      color: HexColor("#302a30").withOpacity(.8),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                logoutDialog(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Icon(
                      FeatherIcons.logOut,
                      color: HexColor("#302a30"),
                      size: 30,
                    ),
                    SizedBox(
                      width: width * 0.1,
                    ),
                    Text(
                      "Sign Out",
                      style: GoogleFonts.montserrat(
                        color: HexColor("#302a30").withOpacity(.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
