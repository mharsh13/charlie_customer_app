import 'package:charlie_customer_app/Screens/AddAddressScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddressBookScreen extends StatefulWidget {
  @override
  _AddressBookScreenState createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
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
                  builder: (context) => AddAddressScreen(),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height,
              child: ListView.builder(
                itemBuilder: (context, index) => Card(
                  elevation: 10,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: Container(
                    height: height * 0.19,
                    width: width,
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Container(
                          width: width * 0.8,
                          child: Text(
                            "Harsh Mehta",
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
                            "4/10 RHB Colony goverdhan Vilas, UDAIPUR RAJASTHAN, 313001",
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          width: width * 0.8,
                          child: Text(
                            "Mobile Number : +919950558495",
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Divider(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              InkWell(
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
                itemCount: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
