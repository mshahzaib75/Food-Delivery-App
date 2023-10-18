import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:divine/backgroundDesign/bg.dart';
import 'package:divine/colors.dart';
import 'package:flutter/material.dart';

class NoInternetConnectionScreen extends StatelessWidget {
  const NoInternetConnectionScreen(
      {super.key, required this.snapshot, required this.widget});
  final AsyncSnapshot<ConnectivityResult> snapshot;
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    switch (snapshot.connectionState) {
      case ConnectionState.active:
        final state = snapshot.data!;
        switch (state) {
          case ConnectivityResult.none:
            return SafeArea(
                child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: [
                  const BackGroundDesign(),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.2),
                        const Icon(
                          Icons.nearby_error_outlined,
                          size: 100,
                          color: yellow,
                        ),
                        SizedBox(height: height * 0.035),
                        const Text(
                          'NO INTERNET',
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 25,
                              fontWeight: FontWeight.w900),
                        ),
                        SizedBox(height: height * 0.01),
                        const Text(
                          'CONNECTION',
                          style: TextStyle(
                              color: yellow,
                              fontSize: 25,
                              fontWeight: FontWeight.w900),
                        ),
                        SizedBox(height: height * 0.01),
                        const Text(
                          'Looks like you are offline.',
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        const Text(
                          'Please check your internet connection.',
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: height * 0.1),
                        SizedBox(
                          height: height * 0.06,
                          width: width * 0.4,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: yellow,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: const Text('Retry',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      fontSize: 16)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
          default:
            return widget;
        }
      default:
        return const Text('');
    }
  }
}
