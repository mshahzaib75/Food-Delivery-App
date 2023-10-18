import 'package:divine/bottomBar.dart/menuScreen.dart';
import 'package:divine/screens/accountScreen.dart';
import 'package:divine/screens/bottomNavigationBar.dart';
import 'package:divine/screens/contactScreen.dart';
import 'package:divine/screens/drawerScreen.dart';
import 'package:divine/screens/loginScreen.dart';
import 'package:divine/screens/phoneScreen.dart';
import 'package:divine/screens/resetScreen.dart';
import 'package:divine/screens/signupScreen.dart';
import 'package:divine/splash/splash_screen.dart';
import 'package:flutter/material.dart';

Route onGenerateRoute(RouteSettings settings) {
  if (settings.name == SplashScreen.pageName) {
    return MaterialPageRoute(builder: (context) => const SplashScreen());
  } else if (settings.name == SignUpScreen.pageName) {
    return SlideLeftTransition(page: const SignUpScreen(), settings: settings);
  } else if (settings.name == BottomBarDesign.pageName) {
    return MaterialPageRoute(builder: (context) => const BottomBarDesign());
  } else if (settings.name == ContactScreen.pageName) {
    return MaterialPageRoute(builder: (context) => const ContactScreen());
  } else if (settings.name == DrawerScreen.pageName) {
    return MaterialPageRoute(builder: (context) => const DrawerScreen());
  } else if (settings.name == ResetScreen.pageName) {
    return MaterialPageRoute(builder: (context) => const ResetScreen());
  } else if (settings.name == PhoneScreen.pageName) {
    return MaterialPageRoute(builder: (context) => const PhoneScreen());
  } else if (settings.name == AccountScreen.pageName) {
    return MaterialPageRoute(builder: (context) => const AccountScreen());
  } else if (settings.name == DivineApp.pageName) {
    return SlideLeftTransition(page: const DivineApp(), settings: settings);
  } else {
    return MaterialPageRoute(
      builder: (context) => const MenuScreen(),
    );
  }
}

class SlideLeftTransition extends PageRouteBuilder {
  final Widget page;
  SlideLeftTransition({required this.page, RouteSettings? settings})
      : super(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return page;
            },
            reverseTransitionDuration: const Duration(seconds: 1),
            transitionDuration: const Duration(seconds: 1),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1.0, 0.5),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                    parent: animation, curve: Curves.easeInSine)),
                child: child,
              );
            });
}
