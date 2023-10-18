import 'package:divine/backgroundDesign/bg.dart';
import 'package:divine/colors.dart';
import 'package:divine/screens/bottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class LastScreen extends StatefulWidget {
  const LastScreen({super.key});
  static const pageName = '/AccountScreen';

  @override
  State<LastScreen> createState() => _LastScreenState();
}

class _LastScreenState extends State<LastScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          const BackGroundDesign(),
          Center(
            child: Column(
              children: [
                SizedBox(height: height * 0.2),
                const Icon(
                  Icons.check_circle,
                  color: yellow,
                  size: 50,
                ),
                SizedBox(height: height * 0.04),
                const Text('ORDER PLACED',
                    style: TextStyle(
                        fontSize: 20,
                        color: whiteColor,
                        fontWeight: FontWeight.w900)),
                SizedBox(height: height * 0.02),
                const FittedBox(
                  child: Text(
                      '             Thank you for shopping \nat divine lahore. Your order has been\nplaced and you will be notified with an \norder confirmation call with your details \n                           shortly',
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 15,
                          color: whiteColor,
                          fontWeight: FontWeight.w400)),
                ),
                SizedBox(height: height * 0.04),
                InkWell(
                  onTap: () {
                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: const BottomBarDesign(), withNavBar: false);
                  },
                  child: Container(
                    height: height * 0.07,
                    width: width * 0.7,
                    decoration: BoxDecoration(
                        color: yellow, borderRadius: BorderRadius.circular(15)),
                    child: const Center(
                      child: Text(
                        'Continue Shopping',
                        style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
