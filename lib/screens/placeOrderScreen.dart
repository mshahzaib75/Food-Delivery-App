import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divine/backgroundDesign/bg.dart';
import 'package:divine/colors.dart';
import 'package:divine/screens/lastScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({super.key, required this.firstTotalCartPrice});
  final num firstTotalCartPrice;

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  Map<String, dynamic>? data1;
  num add(num totalCartPrice, num shippingPrice) {
    return totalCartPrice + shippingPrice;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getData() async {
    return await FirebaseFirestore.instance
        .collection('ShippingAddress')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();
  }

  Future<void> storeUserData(Map<String, dynamic> userData) async {
    await FirebaseFirestore.instance
        .collection('FinalShippingAddress')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('FinalAddress')
        .doc()
        .set(userData);
  }

  TextEditingController orderController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    orderController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    num total = add(widget.firstTotalCartPrice, 100);
    return SafeArea(
        child: Scaffold(
            body: Stack(
      children: [
        const BackGroundDesign(),
        SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(6, 7, 10, 0),
                  child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 27,
                        color: yellow,
                      )),
                ),
              ),
              SizedBox(height: height * 0.02),
              SizedBox(
                height: height * 0.2,
                width: width * 0.9,
                child: Container(
                  color: boxColor,
                  child: Column(
                    children: [
                      const Center(
                          child: Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: FittedBox(
                          child: Text(
                            'Order Summary',
                            style: TextStyle(
                                fontSize: 17,
                                color: yellow,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )),
                      SizedBox(height: height * 0.015),
                      Row(
                        children: [
                          SizedBox(width: width * 0.12),
                          const FittedBox(
                            child: Text(
                              'Sub Total',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: width * 0.2),
                          const FittedBox(
                            child: Text('PKR',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: whiteColor,
                                    fontWeight: FontWeight.w900)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3),
                            child: FittedBox(
                              child: Text('${widget.firstTotalCartPrice}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: yellow,
                                      fontWeight: FontWeight.w900)),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: width * 0.12),
                          const FittedBox(
                            child: Text(
                              'Shipping',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: width * 0.21),
                          const FittedBox(
                            child: Text('PKR',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: whiteColor,
                                    fontWeight: FontWeight.w900)),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 3),
                            child: FittedBox(
                              child: Text('100',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: yellow,
                                      fontWeight: FontWeight.w900)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.02,
                        child: Container(
                            margin:
                                const EdgeInsets.only(left: 23.0, right: 23.0),
                            child: const Divider(
                              thickness: 0.7,
                              color: Colors.white,
                              height: 50,
                            )),
                      ),
                      Row(
                        children: [
                          SizedBox(width: width * 0.12),
                          const FittedBox(
                            child: Text(
                              'Total',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: whiteColor,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                          SizedBox(width: width * 0.28),
                          const FittedBox(
                            child: Text('PKR',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: whiteColor,
                                    fontWeight: FontWeight.w900)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3),
                            child: FittedBox(
                              child: Text('$total',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: yellow,
                                      fontWeight: FontWeight.w900)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),
              SizedBox(
                height: height * 0.24,
                width: width * 0.9,
                child: Container(
                  color: boxColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(8, 10, 0, 10),
                          child: FittedBox(
                            child: Text(
                              'Shipping Address',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: yellow,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ),
                      FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          future: getData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                var data = snapshot.data!.data();
                                data1 = data;
                                return Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FittedBox(
                                        child: Text(
                                          data!['userName'].toString(),
                                          style: const TextStyle(
                                              fontSize: 15, color: whiteColor),
                                        ),
                                      ),
                                      FittedBox(
                                        child: Text(
                                          data['userAddress'].toString(),
                                          style: const TextStyle(
                                              fontSize: 15, color: whiteColor),
                                        ),
                                      ),
                                      FittedBox(
                                        child: Text(
                                          data['userPhone'].toString(),
                                          style: const TextStyle(
                                              fontSize: 15, color: whiteColor),
                                        ),
                                      ),
                                      FittedBox(
                                        child: Text(
                                          data['selectedCity'].toString(),
                                          style: const TextStyle(
                                              fontSize: 15, color: whiteColor),
                                        ),
                                      ),
                                      FittedBox(
                                        child: Text(
                                          data['userLocation'].toString(),
                                          softWrap: true,
                                          style: const TextStyle(
                                              fontSize: 15, color: whiteColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const Text(
                                  'No Data',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900),
                                );
                              }
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: boxColor,
                                ),
                              );
                            } else {
                              return const Text(
                                'Something went wrong',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900),
                              );
                            }
                          })
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),
              SizedBox(
                height: height * 0.1,
                width: width * 0.9,
                child: Container(
                  color: boxColor,
                  child: const Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(8, 7, 0, 10),
                          child: Text(
                            'Payment Option',
                            style: TextStyle(
                                fontSize: 14,
                                color: yellow,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      Center(
                        child: Text('Cash on Delivery (COD)',
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w700)),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),
              SizedBox(
                height: height * 0.1,
                width: width * 0.9,
                child: Container(
                  color: boxColor,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: TextFormField(
                      controller: orderController,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: whiteColor,
                      textAlign: TextAlign.start,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          border: const UnderlineInputBorder(),
                          labelText: 'Order Note',
                          labelStyle: const TextStyle(
                            color: yellow,
                            fontWeight: FontWeight.w400,
                          ),
                          hintStyle: const TextStyle(color: Colors.white),
                          hintText: orderController.text,
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),
              SizedBox(
                height: height * 0.08,
                width: width * 0.9,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (data1 != null) {
                        storeUserData({
                          'userName': data1!['userName'],
                          'userAddress': data1!['userAddress'],
                          'userLocation': data1!['userLocation'],
                          'userPhone': data1!['userPhone'],
                          'selectedCity': data1!['selectedCity'],
                          'orderInstruction': orderController.text,
                          'orderTime': FieldValue.serverTimestamp(),
                          'totalPrice': total
                        });
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const LastScreen();
                        }));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: yellow,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        FlickerAnimatedText('Place Order',
                            speed: const Duration(milliseconds: 300),
                            textStyle: const TextStyle(
                                color: whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w900)),
                      ],
                      displayFullTextOnTap: true,
                      repeatForever: true,
                      totalRepeatCount: 3,
                      pause: const Duration(milliseconds: 300),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    )));
  }
}
