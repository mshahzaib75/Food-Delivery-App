// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divine/bottomBar.dart/cartScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../backgroundDesign/bg.dart';
import '../colors.dart';

class DescriptionScreen extends StatefulWidget {
  const DescriptionScreen({
    Key? key,
    required this.id,
    required this.itemName,
    required this.price,
    required this.image,
    required this.description,
    required this.quantity,
    this.noOrders,
    required this.originalPrice,
  }) : super(key: key);

  static const pageName = "/DescriptionScreen";

  final String id;
  final String itemName;
  final num price;
  final num originalPrice;
  final String image;
  final String description;
  final String quantity;
  final int? noOrders;

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final firestore = FirebaseFirestore.instance.collection('Cart');
  final fireStore1 = FirebaseFirestore.instance
      .collection('Cart')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection('Cart')
      .snapshots();
  int noOrders = 1;
  int totalOrders = 1;

  //This method is used to send data to Firestore
  void addTOCart() {
    final newPrice = calculateTotalPrice(widget.price, noOrders);
    firestore
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('Cart')
        .doc(widget.itemName)
        .set({
      'id': widget.id,
      'image': widget.image,
      'itemName': widget.itemName,
      'price': newPrice,
      'noOrders': noOrders++,
      'originalPrice': widget.originalPrice,
      'quantity': widget.quantity
    });
  }

  //Method is used to calculate the price per noOrders
  num calculateTotalPrice(price, noOrders) {
    return price * noOrders;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            const BackGroundDesign(),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.07,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: yellow,
                                  size: 27,
                                ))),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 14, 0),
                          child: SlideTransition(
                            position: _offsetAnimation,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return const CartScreen();
                                  },
                                ));
                              },
                              child: const Icon(Icons.child_friendly,
                                  color: yellow, size: 27),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.1,
                  ),
                  Container(
                    width: width * 0.9,
                    decoration: BoxDecoration(
                        color: boxColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(7, 0, 7, 9),
                      child: Column(
                        children: [
                          Hero(
                            tag: widget.image,
                            placeholderBuilder: (context, heroSize, child) {
                              return SizedBox(
                                height: heroSize.height,
                                width: heroSize.width,
                                child: Opacity(
                                  opacity: 0.3,
                                  child: Image.network(widget.image),
                                ),
                              );
                            },
                            child: SizedBox(
                              height: height * 0.4,
                              width: width,
                              child: Image.network(
                                widget.image,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Text(widget.itemName,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: yellow),
                            height: height * 0.05,
                            width: width * 0.3,
                            child: Center(
                              child: Text(widget.quantity,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: whiteColor,
                                      fontWeight: FontWeight.w900)),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Rs. ',
                                  style:
                                      TextStyle(color: yellow, fontSize: 13)),
                              Text(widget.price.toString(),
                                  style: const TextStyle(
                                      color: whiteColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          InkWell(
                            onTap: () {
                              addTOCart();
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: height * 0.05,
                                  width: width * 0.3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13),
                                    color: yellow,
                                  ),
                                  child: const Center(
                                      child: Text('Add to cart',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: whiteColor,
                                              fontWeight: FontWeight.w900))),
                                ),
                                StreamBuilder(
                                  stream: fireStore1,
                                  builder: (context, snapshot) {
                                    num newtotalNoOfOrders = 0;
                                    if (snapshot.hasData) {
                                      final cartItems = snapshot.data!.docs;

                                      for (var cartItem in cartItems) {
                                        if (cartItem['itemName'] ==
                                            widget.itemName) {
                                          newtotalNoOfOrders =
                                              cartItem['noOrders'];
                                          break;
                                        }
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
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text('Description:-',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: yellow,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.005,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: AutoSizeText(
                              widget.description,
                              style: const TextStyle(
                                  fontSize: 12, color: whiteColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.1)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
