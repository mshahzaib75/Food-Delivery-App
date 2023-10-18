import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:divine/backgroundDesign/bg.dart';
import 'package:divine/colors.dart';
import 'package:divine/screens/noInternetScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../bottomBar.dart/cartScreen.dart';
import '../bottomBar.dart/itemScreen.dart';
import '../bottomBar.dart/menuScreen.dart';
import '../bottomBar.dart/searchScreen.dart';

class BottomBarDesign extends StatefulWidget {
  const BottomBarDesign({Key? key}) : super(key: key);
  static const pageName = "/BottomBarDesign";

  @override
  State<BottomBarDesign> createState() => _BottomBarDesignState();
}

class _BottomBarDesignState extends State<BottomBarDesign> {
  final fireStore = FirebaseFirestore.instance
      .collection('Cart')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection('Cart')
      .snapshots();

  int currentIndex = 0;
  StreamController<ConnectivityResult>? connectivityController;
  StreamSubscription<ConnectivityResult>? subscription;
  @override
  void initState() {
    super.initState();

    // Initialize the StreamController in initState
    connectivityController = StreamController<ConnectivityResult>();

    // Listen for connectivity changes and add the result to the stream
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      connectivityController!.add(result);
    });
  }

  @override
  void dispose() {
    // Cancel the subscription and close the StreamController
    subscription?.cancel();
    connectivityController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buildScreens() {
      return [
        const MenuScreen(),
        const ItemScreen(),
        const SearchScreen(),
        const CartScreen(),
      ];
    }

    List<PersistentBottomNavBarItem> navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home_filled),
          activeColorPrimary: boxColor,
          inactiveColorPrimary: whiteColor,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.menu_book),
          activeColorPrimary: boxColor,
          inactiveColorPrimary: whiteColor,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.search),
          activeColorPrimary: boxColor,
          inactiveColorPrimary: whiteColor,
        ),
        PersistentBottomNavBarItem(
          icon: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.shopping_cart),
              StreamBuilder(
                stream: fireStore,
                builder: (context, snapshot) {
                  num newtotalNoOfOrders = 0;
                  if (snapshot.hasData) {
                    final cartItems = snapshot.data!.docs;
                    for (var cartItem in cartItems) {
                      newtotalNoOfOrders += cartItem['noOrders'];
                    }
                  }
                  if (newtotalNoOfOrders > 0) {
                    return Positioned(
                      top: 0,
                      right: 0,
                      child: Badge(
                        label: Text(
                          '$newtotalNoOfOrders',
                          style: const TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox(); // Return an empty widget if not added to cart
                  }
                },
              ),
            ],
          ),
          activeColorPrimary: boxColor,
          inactiveColorPrimary: whiteColor,
        ),
      ];
    }

    PersistentTabController controller;

    controller = PersistentTabController(initialIndex: 0);

    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
        stream: connectivityController!.stream,
        builder: (context, snapshot) {
          final connectivityResult = snapshot.data;
          if (connectivityResult == ConnectivityResult.none) {
            return NoInternetConnectionScreen(
              snapshot: snapshot,
              widget: Stack(
                children: [
                  const BackGroundDesign(),
                  PersistentTabView(
                    context,
                    controller: controller,
                    screens: buildScreens(),
                    items: navBarsItems(),
                    confineInSafeArea: true,
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 7),
                    backgroundColor: yellow,
                    handleAndroidBackButtonPress: true,
                    resizeToAvoidBottomInset: true,
                    stateManagement: true,
                    hideNavigationBarWhenKeyboardShows: true,
                    decoration: const NavBarDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        adjustScreenBottomPaddingOnCurve: true,
                        colorBehindNavBar: boxColor),
                    popAllScreensOnTapOfSelectedTab: true,
                    popActionScreens: PopActionScreensType.all,
                    popAllScreensOnTapAnyTabs: true,
                    navBarStyle: NavBarStyle.simple,
                  )
                ],
              ),
            );
          } else {
            return PersistentTabView(
              context,
              controller: controller,
              screens: buildScreens(),
              items: navBarsItems(),
              confineInSafeArea: true,
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 7),
              backgroundColor: yellow,
              handleAndroidBackButtonPress: true,
              resizeToAvoidBottomInset: true,
              stateManagement: true,
              hideNavigationBarWhenKeyboardShows: true,
              decoration: const NavBarDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  adjustScreenBottomPaddingOnCurve: true,
                  colorBehindNavBar: boxColor),
              popAllScreensOnTapOfSelectedTab: true,
              popActionScreens: PopActionScreensType.all,
              popAllScreensOnTapAnyTabs: true,
              navBarStyle: NavBarStyle.simple,
            );
          }
        },
      ),
    ));
  }
}
