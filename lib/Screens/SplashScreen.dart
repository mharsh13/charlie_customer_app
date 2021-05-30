import 'package:charlie_customer_app/Authentication/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    getcurrentUser();
  }

  Future<void> getcurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Future.delayed(Duration(seconds: 3)).then((value) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen(),
          ),
        );
      });
      return;
    }
    if (user != null) {
      Future.delayed(Duration(seconds: 3)).then((value) {
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (BuildContext context) => HomeScreen(),
        //   ),
        // );
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#F3DDE6"),
      body: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.2,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "Assets/background.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Image.asset(
                "Assets/splashLogo.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
