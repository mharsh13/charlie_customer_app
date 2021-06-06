import 'package:charlie_customer_app/Authentication/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

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
          'Are you sure you want to Logout',
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
    return Center(
      child: InkWell(
        onTap: () {
          logoutDialog(context);
        },
        child: Container(
          width: width * 0.6,
          height: height * 0.05,
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
                  "Logout",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                Icon(
                  FeatherIcons.logOut,
                  color: Colors.white,
                  size: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
