import 'package:charlie_customer_app/Authentication/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ));
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor('090b17'),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: width * 0.7,
                child: Image.asset(
                  "Assets/splashLogo.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: height * .02,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  logoutDialog(context);
                },
                child: Container(
                  height: height * .05,
                  width: width * .5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        HexColor('294fbb'),
                        HexColor('09c7f7'),
                      ],
                      tileMode: TileMode.repeated,
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Logout",
                          style: GoogleFonts.ptSans(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.05,
                        ),
                        Icon(
                          MdiIcons.logout,
                          color: Colors.white,
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
    );
  }
}
