import 'package:charlie_customer_app/Authentication/LoginScreen.dart';
import 'package:charlie_customer_app/Screens/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import 'otp.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneno;
  final String username;
  final bool logIn;

  OtpVerificationScreen({
    this.phoneno,
    this.username,
    this.logIn,
  });

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  bool isCodeSent = false;
  bool _isLoading = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _verificationId;
  PinDecoration _pinDecoration = UnderlineDecoration(
    enteredColor: Colors.black,
    hintText: '123456',
    hintTextStyle: GoogleFonts.roboto(color: Colors.grey, fontSize: 18),
    textStyle: GoogleFonts.roboto(color: Colors.black, fontSize: 18),
    color: Colors.black,
  );
  TextEditingController _pinEditingController = TextEditingController();

  void _onformsubmitted() async {
    setState(() {
      _isLoading = true;
    });

    AuthCredential _authCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: _pinEditingController.text);

    _firebaseAuth
        .signInWithCredential(_authCredential)
        .then((UserCredential value) async {
      if (value.user != null) {
        CollectionReference userCollection =
            firestore.collection("User Information");
        var userExist = false;
        await userCollection.doc(value.user.uid).get().then((doc) {
          if (doc.exists) {
            userExist = true;
          } else {
            userExist = false;
          }
        });

        if (widget.logIn ? !userExist : userExist) {
          FirebaseAuth.instance.signOut();
          showDialog(
            context: context,
            builder: (context) => WillPopScope(
              // ignore: missing_return
              onWillPop: () {},
              child: AlertDialog(
                title: Text(
                  widget.logIn ? "User not found!" : "User already exist!",
                  style: GoogleFonts.montserrat(
                    color: HexColor("#302a30"),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                content: Text(
                  widget.logIn ? "Try signing up" : "Try signing in",
                  style: GoogleFonts.montserrat(
                    color: HexColor("#302a30"),
                    fontSize: 14,
                  ),
                ),
                actions: [
                  // ignore: deprecated_member_use
                  TextButton(
                    child: Text(
                      "Ok",
                      style: GoogleFonts.montserrat(
                        color: HexColor("#f55d5d"),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );

          setState(() {
            _isLoading = false;
          });
          return;
        } else {
          if (widget.logIn) {
            setState(() {
              _isLoading = false;
            });
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          } else {
            var userInfo = {
              "uid": value.user.uid,
              "username": widget.username,
              "phoneNumber": widget.phoneno,
            };

            userCollection.doc(value.user.uid).set(userInfo);
            setState(() {
              _isLoading = false;
            });
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          }
        }
      } else {
        showToast("Error validating OTP, try again", Colors.white);
        setState(() {
          _isLoading = false;
        });
      }
    }).catchError((error) {
      print(error);
      showToast("Something went wrong", Colors.white);
      setState(() {
        _isLoading = false;
      });
    });
  }

  void showToast(message, Color color) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: color,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  void _onVerifyCode() async {
    setState(() {
      isCodeSent = true;
    });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      //....
      _firebaseAuth
          .signInWithCredential(phoneAuthCredential)
          .then((UserCredential value) async {
        if (value.user != null) {
          CollectionReference userCollection =
              firestore.collection("User Information");
          var userExist = false;
          await userCollection.doc(value.user.uid).get().then((doc) {
            if (doc.exists) {
              userExist = true;
            } else {
              userExist = false;
            }
          });

          if (widget.logIn ? !userExist : userExist) {
            FirebaseAuth.instance.signOut();
            showDialog(
              context: context,
              builder: (context) => WillPopScope(
                // ignore: missing_return
                onWillPop: () {},
                child: AlertDialog(
                  title: Text(
                    widget.logIn ? "User not found!" : "User already exist!",
                    style: GoogleFonts.montserrat(
                      color: HexColor("#302a30"),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  content: Text(
                    widget.logIn ? "Try signing up" : "Try signing in",
                    style: GoogleFonts.montserrat(
                      color: HexColor("#302a30"),
                      fontSize: 14,
                    ),
                  ),
                  actions: [
                    // ignore: deprecated_member_use
                    TextButton(
                      child: Text(
                        "Ok",
                        style: GoogleFonts.montserrat(
                          color: HexColor("#f55d5d"),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            );

            setState(() {
              _isLoading = false;
            });
            return;
          } else {
            if (widget.logIn) {
              setState(() {
                _isLoading = false;
              });
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            } else {
              var userInfo = {
                "uid": value.user.uid,
                "username": widget.username,
                "phoneNumber": widget.phoneno,
              };

              userCollection.doc(value.user.uid).set(userInfo);
              setState(() {
                _isLoading = false;
              });
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            }
          }
        } else {
          showToast("Error validating OTP, try again", Colors.white);
          setState(() {
            _isLoading = false;
          });
        }
      }).catchError((error) {
        showToast("Try again in sometime", Colors.white);
        setState(() {
          _isLoading = false;
        });
      });
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      showToast(authException.message, Colors.white);
      setState(() {
        isCodeSent = false;
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };

    //Change country code

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "${widget.phoneno}",
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  @override
  void initState() {
    _onVerifyCode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#F3DDE6"),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: height * .1,
                ),
                Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  margin: EdgeInsets.all(0),
                  child: Container(
                    height: height * 0.855,
                    width: width,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height * .01,
                        ),
                        Text(
                          "Code Verification",
                          style: GoogleFonts.montserrat(
                            color: HexColor("#302a30"),
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: height * .05,
                        ),
                        Text(
                          "Enter verificaton code here",
                          style: GoogleFonts.montserrat(
                            color: HexColor("#302a30"),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: height * .05,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: PinInputTextField(
                            pinLength: 6,
                            decoration: _pinDecoration,
                            controller: _pinEditingController,
                            autoFocus: true,
                            textInputAction: TextInputAction.done,
                            onSubmit: (pin) {
                              if (pin.length == 6) {
                                _onformsubmitted();
                              } else {
                                showToast("Invalid OTP", Colors.red);
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: height * .05,
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              if (_pinEditingController.text.length == 6) {
                                _onformsubmitted();
                              } else {
                                showToast("Invalid OTP", Colors.white);
                              }
                            },
                            child: Container(
                              width: width * 0.6,
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: HexColor("#f55d5d").withOpacity(0.8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: _isLoading
                                    ? SpinKitThreeBounce(
                                        color: Colors.white,
                                        size: 20,
                                      )
                                    : Text(
                                        "SUBMIT",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * .05,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
