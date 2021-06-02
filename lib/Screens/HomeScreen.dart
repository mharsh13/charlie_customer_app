import 'package:charlie_customer_app/Screens/DashboardScreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 4, vsync: this, initialIndex: 0);
  }

//dispose method for good practice.
  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: HexColor("#eceaec"),
      bottomNavigationBar: Material(
        color: Colors.white,
        child: TabBar(
          indicatorColor: Colors.transparent,
          dragStartBehavior: DragStartBehavior.start,
          labelColor: HexColor('#f55d5d').withOpacity(.8),
          unselectedLabelColor: Colors.grey,
          controller: tabController,
          tabs: <Widget>[
            Container(
              height: height * .08,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FeatherIcons.home,
                    size: 18,
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Text(
                    'Home',
                    style: GoogleFonts.roboto(fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              height: height * .08,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FeatherIcons.grid,
                    size: 18,
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Text(
                    'Categories',
                    style: GoogleFonts.roboto(fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              height: height * .08,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FeatherIcons.heart,
                    size: 18,
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Text(
                    'Favorites',
                    style: GoogleFonts.roboto(fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              height: height * .08,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FeatherIcons.user,
                    size: 18,
                  ),
                  SizedBox(
                    height: height * .005,
                  ),
                  Text(
                    'Profile',
                    style: GoogleFonts.roboto(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          DashboardScreen(),
          Container(),
          Container(),
          Container(),
        ],
        controller: tabController,
      ),
    );
  }
}
