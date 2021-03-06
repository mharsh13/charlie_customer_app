import 'package:charlie_customer_app/Authentication/otpverificationscreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool showSignIn = false;
  TextEditingController phoneLogin = new TextEditingController();
  TextEditingController phoneSignUp = new TextEditingController();
  TextEditingController username = new TextEditingController();
  final _formKeyLogin = GlobalKey<FormState>();
  final _formKeySignUp = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#F3DDE6"),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: height * .02,
                  ),
                  Container(
                    height: height * 0.35,
                    width: width,
                    child: Image.asset(
                      "Assets/welcome.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  showSignIn
                      ? Card(
                          elevation: 12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                          margin: EdgeInsets.all(0),
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return SlideTransition(
                                child: child,
                                position: Tween<Offset>(
                                  begin: Offset(1, 0),
                                  end: Offset(0, 0),
                                ).animate(
                                  animation,
                                ),
                              );
                            },
                            child: Container(
                              key: Key("1"),
                              height: height * 0.585,
                              width: width,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: height * .01,
                                  ),
                                  Text(
                                    "Sign in",
                                    style: GoogleFonts.montserrat(
                                      color: HexColor("#302a30"),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * .03,
                                  ),
                                  Form(
                                    key: _formKeyLogin,
                                    child: TextFormField(
                                      validator: (val) {
                                        if (val.isEmpty) {
                                          return "Enter in Field";
                                        } else if (val.length < 10) {
                                          return "Enter correct phone number";
                                        } else
                                          return null;
                                      },
                                      controller: phoneLogin,
                                      cursorColor:
                                          HexColor('#f55d5d').withOpacity(.3),
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: HexColor('#f55d5d')
                                                .withOpacity(.6),
                                            width: 2.0,
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.pink[100],
                                          ),
                                        ),
                                        labelText: 'Enter Phone Number',
                                        prefixText: "+91",
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * .05,
                                  ),
                                  Center(
                                    child: InkWell(
                                      onTap: () {
                                        if (!_formKeyLogin.currentState
                                            .validate()) {
                                          return;
                                        }
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OtpVerificationScreen(
                                              phoneno: "+91${phoneLogin.text}",
                                              username: username.text,
                                              logIn: true,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: width * 0.6,
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: HexColor("#f55d5d")
                                              .withOpacity(0.8),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "CONTINUE",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(
                                                width: width * 0.02,
                                              ),
                                              Icon(
                                                MdiIcons.arrowRight,
                                                color: Colors.white,
                                                size: 20,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * .05,
                                  ),
                                  Center(
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "I'm a new user.",
                                            style: GoogleFonts.montserrat(
                                              color: HexColor("#302a30"),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.02,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                showSignIn = !showSignIn;
                                              });
                                            },
                                            child: Text(
                                              "Sign up",
                                              style: GoogleFonts.montserrat(
                                                color: HexColor("#f83737")
                                                    .withOpacity(.8),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : Card(
                          elevation: 12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                          margin: EdgeInsets.all(0),
                          child: AnimatedSwitcher(
                            transitionBuilder: (child, animation) {
                              return SlideTransition(
                                child: child,
                                position: Tween<Offset>(
                                  begin: Offset(1, 0),
                                  end: Offset(0, 0),
                                ).animate(animation),
                              );
                            },
                            duration: Duration(milliseconds: 300),
                            child: Container(
                              key: Key("2"),
                              height: height * 0.585,
                              width: width,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: height * .01,
                                  ),
                                  Text(
                                    "Sign Up",
                                    style: GoogleFonts.montserrat(
                                      color: HexColor("#302a30"),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * .03,
                                  ),
                                  Form(
                                    key: _formKeySignUp,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          validator: (val) {
                                            if (val.isEmpty) {
                                              return "Enter in Field";
                                            } else
                                              return null;
                                          },
                                          controller: username,
                                          cursorColor: HexColor('#f55d5d')
                                              .withOpacity(.6),
                                          keyboardType: TextInputType.name,
                                          decoration: InputDecoration(
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: HexColor('#f55d5d')
                                                    .withOpacity(.6),
                                                width: 2.0,
                                              ),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.pink[100],
                                              ),
                                            ),
                                            hintText: 'Enter Name',
                                          ),
                                        ),
                                        TextFormField(
                                          validator: (val) {
                                            if (val.isEmpty) {
                                              return "Enter in Field";
                                            } else if (val.length < 10) {
                                              return "Enter correct phone number";
                                            } else
                                              return null;
                                          },
                                          controller: phoneSignUp,
                                          cursorColor: HexColor('#f55d5d')
                                              .withOpacity(.6),
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: HexColor('#f55d5d')
                                                    .withOpacity(.6),
                                                width: 2.0,
                                              ),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.pink[100],
                                              ),
                                            ),
                                            labelText: 'Enter Phone Number',
                                            prefixText: "+91",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * .05,
                                  ),
                                  Center(
                                    child: InkWell(
                                      onTap: () {
                                        if (!_formKeySignUp.currentState
                                            .validate()) {
                                          return;
                                        }
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OtpVerificationScreen(
                                              phoneno: "+91${phoneSignUp.text}",
                                              username: username.text,
                                              logIn: false,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: width * 0.6,
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: HexColor("#f55d5d")
                                              .withOpacity(0.8),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "CONTINUE",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(
                                                width: width * 0.02,
                                              ),
                                              Icon(
                                                MdiIcons.arrowRight,
                                                color: Colors.white,
                                                size: 20,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * .05,
                                  ),
                                  Center(
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "I'm already a member.",
                                            style: GoogleFonts.montserrat(
                                              color: HexColor("#302a30"),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.02,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                showSignIn = !showSignIn;
                                              });
                                            },
                                            child: Text(
                                              "Sign in",
                                              style: GoogleFonts.montserrat(
                                                color: HexColor("#f83737")
                                                    .withOpacity(.8),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                ],
              ),
              Positioned(
                right: 40,
                top: height * 0.34,
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: HexColor("#f55d5d"),
                  child: Icon(
                    MdiIcons.shopping,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
