import 'package:divine/screens/contactScreen.dart';
import 'package:divine/screens/googleDataScreen.dart';
import 'package:divine/screens/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../backgroundDesign/bg.dart';
import '../colors.dart';
import 'accountScreen.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);
  static const pageName = "/DrawerScreen";

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final firebase = FirebaseAuth.instance;
  //this method checks that user logins from google account or not
  bool isGoogleLogin = FirebaseAuth.instance.currentUser!.providerData
      .any((element) => element.providerId == 'google.com');
  bool isEmailLogin = FirebaseAuth.instance.currentUser!.providerData
      .any((element) => element.providerId == 'password');

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
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 7, 10, 0),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.menu,
                    size: 27,
                    color: whiteColor,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(27, 80, 0, 0),
            child: SizedBox(
              height: height * 0.33,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  container(height * 0.08, width * 0.85, context, 'Contact Us',
                      () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: const ContactScreen(),
                      withNavBar: false,
                    );
                  }),
                  container(height * 0.08, width * 0.85, context, 'My Account',
                      () {
                    if (isGoogleLogin) {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: const GoogleAccountScreen(),
                        withNavBar: false,
                      );
                    } else if (isEmailLogin) {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: const AccountScreen(),
                        withNavBar: false,
                      );
                    }
                  }),
                  container(height * 0.08, width * 0.85, context, 'Logout', () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: yellow,
                          title: const Center(
                            child: Text("LOGOUT",
                                style: TextStyle(
                                    color: boxColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18)),
                          ),
                          content: const Text(
                              'If you want to exist then press Yes',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                          actions: <Widget>[
                            WillPopScope(
                              onWillPop: () async {
                                return true; // This will prevent the back button from working on this screen
                              },
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: boxColor,
                                ),
                                child: const Text(
                                  'Yes',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  firebase.signOut();
                                  Future.delayed(
                                      const Duration(milliseconds: 100));
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      DivineApp.pageName, (route) => false);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}

Widget container(double height, double width, BuildContext context, String text,
    Function onTap) {
  return SizedBox(
    height: height,
    width: width,
    child: InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        color: boxColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 16,
                      color: whiteColor,
                      fontWeight: FontWeight.w500)),
            )),
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 25,
                color: yellow,
              ),
            )
          ],
        ),
      ),
    ),
  );
}
