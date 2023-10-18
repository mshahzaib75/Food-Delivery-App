import 'package:divine/splash/splash_services.dart';
import 'package:flutter/material.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
static const pageName = "/SplashScreen";
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashScreen = SplashServices();
  @override
  void initState() {
    super.initState();
    splashScreen.isLogin(context);
  }
  @override
  Widget build(BuildContext context) {
 
    return SafeArea(
      child: Scaffold(
          body:Stack(
            children:[
           Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/background.jpeg'),
            fit: BoxFit.fill),
      ),
    ),
           Center(child: Image.asset('assets/images/splash.png'))
            ],
          )
),

    );
  }
}
