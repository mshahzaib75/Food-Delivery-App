import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:divine/backgroundDesign/bg.dart';
import 'package:divine/colors.dart';
import 'package:divine/screens/shippingScreen.dart';
import '../screens/drawerScreen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const pageName = "/CartScreen";
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final fireStore = FirebaseFirestore.instance
      .collection('Cart')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection('Cart')
      .snapshots();
  int noOrders = 1;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const BackGroundDesign(),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: width,
                  height: height * 0.07,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 8, 0, 0),
                          child: text(),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 10, 0),
                          child: InkWell(
                              onTap: () =>
                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: const DrawerScreen(),
                                    withNavBar: true,
                                  ),
                              child: icon(context)),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.6,
                  width: width,
                  child: StreamBuilder(
                    stream: fireStore,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: boxColor),
                        );
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.shopping_cart,
                                size: 60,
                                color: yellow,
                              ),
                              SizedBox(
                                height: height * 0.05,
                              ),
                              const Text(
                                'Your cart is empty!',
                                softWrap: true,
                                style: TextStyle(
                                    color: yellow,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900),
                              )
                            ],
                          ),
                        );
                      } else if (snapshot.hasData) {
                        final cartItems = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final cartItem = snapshot.data!.docs[index];
                            //  final itemId = cartItem.id;
                            //This function delete the number of items in the cart
                            void deleteItemFromCart(String itemId) {
                              FirebaseFirestore.instance
                                  .collection('Cart')
                                  .doc(FirebaseAuth.instance.currentUser!.email)
                                  .collection('Cart')
                                  .doc(itemId)
                                  .delete();
                            }

                            //This function decrements the number of items in the cart
                            void removeItemFromCart(DocumentSnapshot cartItem) {
                              final itemId = cartItem.id;
                              final newQuantity = cartItem['noOrders'] - 1;
                              if (newQuantity <= 0) {
                                deleteItemFromCart(itemId);
                              } else {
                                final oldPrice = cartItem['price'];
                                int newPrice =
                                    ((oldPrice / cartItem['noOrders']) *
                                            newQuantity)
                                        .toInt();

                                FirebaseFirestore.instance
                                    .collection('Cart')
                                    .doc(FirebaseAuth
                                        .instance.currentUser!.email)
                                    .collection('Cart')
                                    .doc(itemId)
                                    .update({
                                  'noOrders': newQuantity,
                                  'price': newPrice,
                                });
                              }
                            }

                            //This function increments the number of items in the cart
                            void addItemToCart(DocumentSnapshot cartItem) {
                              final itemId = cartItem.id;
                              final newQuantity = cartItem['noOrders'] + 1;
                              final oldPrice = cartItem['price'];
                              int newPrice =
                                  ((oldPrice / cartItem['noOrders']) *
                                          newQuantity)
                                      .toInt();

                              FirebaseFirestore.instance
                                  .collection('Cart')
                                  .doc(FirebaseAuth.instance.currentUser!.email)
                                  .collection('Cart')
                                  .doc(itemId)
                                  .update({
                                'noOrders': newQuantity,
                                'price': newPrice,
                              });
                            }

                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Card(
                                color: boxColor,
                                elevation: 16,
                                child: Row(
                                  children: [
                                    Container(
                                      height: height * 0.12,
                                      width: width * 0.24,
                                      color: boxColor,
                                      child: Image.network(
                                          snapshot.data!.docs[index]['image']),
                                    ),
                                    SizedBox(width: width * 0.05),
                                    SizedBox(
                                      height: height * 0.12,
                                      width: width * 0.2,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20),
                                              child: FittedBox(
                                                child: Text(
                                                  snapshot.data!.docs[index]
                                                      ['itemName'],
                                                  style: const TextStyle(
                                                      color: yellow,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 10),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: height * 0.01),
                                            Row(
                                              children: [
                                                const FittedBox(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: FittedBox(
                                                      child: Text(
                                                        'Rs.',
                                                        softWrap: true,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: yellow,
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                FittedBox(
                                                  child: Text(
                                                    snapshot
                                                        .data!
                                                        .docs[index]
                                                            ['originalPrice']
                                                        .toString(),
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: yellow,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: height * 0.01),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 25),
                                              child: FittedBox(
                                                child: Text(
                                                  snapshot.data!
                                                      .docs[index]['quantity']
                                                      .toString(),
                                                  softWrap: true,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: yellow,
                                                      fontSize: 10),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: SizedBox(
                                        height: height * 0.09,
                                        child: VerticalDivider(
                                          thickness: 1,
                                          color: whiteColor.withOpacity(0.7),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.12,
                                      width: width * 0.17,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const FittedBox(
                                            child: Text('Quanity',
                                                style: TextStyle(
                                                    color: whiteColor,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  removeItemFromCart(cartItem);
                                                },
                                                child: const Text('-',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: whiteColor,
                                                        fontWeight:
                                                            FontWeight.w900)),
                                              ),
                                              FittedBox(
                                                child: Text(
                                                    snapshot.data!
                                                        .docs[index]['noOrders']
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    )),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  addItemToCart(cartItem);
                                                },
                                                child: const Text('+',
                                                    style: TextStyle(
                                                        color: whiteColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w900)),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.03,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: SizedBox(
                                        height: height * 0.09,
                                        child: VerticalDivider(
                                          thickness: 1,
                                          color: whiteColor.withOpacity(0.7),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.12,
                                      width: width * 0.17,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const FittedBox(
                                            child: Text('Price',
                                                style: TextStyle(
                                                    color: whiteColor,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          FittedBox(
                                            child: Text(
                                                snapshot
                                                    .data!.docs[index]['price']
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: whiteColor,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Column(
                          children: [
                            SizedBox(height: height * 0.3),
                            const Center(
                              child: Text(
                                'Something went wrong',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: height * 0.2,
                  child: StreamBuilder(
                    stream: fireStore,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(color: boxColor));
                      } else if (snapshot.hasError) {
                        return const Text('Error loading data',
                            style: TextStyle(color: Colors.red, fontSize: 17));
                      } else {
                        num totalCartPrice = 0;
                        if (snapshot.hasData) {
                          final cartItems = snapshot.data!.docs;
                          for (var cartItem in cartItems) {
                            totalCartPrice += cartItem['price'];
                          }
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(height: height * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const FittedBox(
                                  child: Text(
                                    'Total',
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: height * 0.07,
                                  width: width * 0.35,
                                  decoration: BoxDecoration(
                                      color: yellow,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: FittedBox(
                                          child: Text(
                                            'Rs.',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      FittedBox(
                                        child: Text(
                                          '$totalCartPrice',
                                          style: const TextStyle(
                                            color: whiteColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.02),
                            SizedBox(
                              height: height * 0.065,
                              child: InkWell(
                                onTap: () {
                                  if (totalCartPrice > 0) {
                                    PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        withNavBar: false,
                                        screen: ShippingScreen(
                                            totalCartPrice: totalCartPrice));
                                  } else {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: yellow,
                                          title: const Center(
                                            child: Text("Error",
                                                style: TextStyle(
                                                  color: boxColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w900,
                                                )),
                                          ),
                                          content: const Text(
                                              'Please add something to cart',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14)),
                                          actions: <Widget>[
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                  backgroundColor: boxColor),
                                              child: const Text('OK',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w900)),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Container(
                                  width: width * 0.6,
                                  decoration: BoxDecoration(
                                      color: yellow,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: const Center(
                                    child: FittedBox(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(left: 4, right: 4),
                                        child: Text(
                                          'Proceed to Checkout',
                                          style: TextStyle(
                                            color: whiteColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.025)
                          ],
                        );
                      }
                    },
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

Widget text() {
  return const Text(
    'CART',
    style: TextStyle(
        color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
  );
}

Widget icon(BuildContext context) {
  return const Icon(Icons.menu, color: Colors.white, size: 27);
}

class Cart {
  String id;
  String image;
  String itemName;
  num price;
  int noOrders;
  num originalPrice;
  String quantity;
  Cart({
    required this.id,
    required this.image,
    required this.itemName,
    required this.price,
    required this.noOrders,
    required this.originalPrice,
    required this.quantity,
  });

  Cart copyWith({
    String? id,
    String? image,
    String? itemName,
    num? price,
    int? noOrders,
    num? originalPrice,
    String? quantity,
  }) {
    return Cart(
      id: id ?? this.id,
      image: image ?? this.image,
      itemName: itemName ?? this.itemName,
      price: price ?? this.price,
      noOrders: noOrders ?? this.noOrders,
      originalPrice: originalPrice ?? this.originalPrice,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image': image,
      'itemName': itemName,
      'price': price,
      'noOrders': noOrders,
      'originalPrice': originalPrice,
      'quantity': quantity,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      id: map['id'] as String,
      image: map['image'] as String,
      itemName: map['itemName'] as String,
      price: map['price'] as num,
      noOrders: map['noOrders'] as int,
      originalPrice: map['originalPrice'] as num,
      quantity: map['quantity'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) =>
      Cart.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Cart(id: $id, image: $image, itemName: $itemName, price: $price, noOrders: $noOrders, originalPrice: $originalPrice, quantity: $quantity)';
  }

  @override
  bool operator ==(covariant Cart other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.image == image &&
        other.itemName == itemName &&
        other.price == price &&
        other.noOrders == noOrders &&
        other.originalPrice == originalPrice &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        image.hashCode ^
        itemName.hashCode ^
        price.hashCode ^
        noOrders.hashCode ^
        originalPrice.hashCode ^
        quantity.hashCode;
  }
}
