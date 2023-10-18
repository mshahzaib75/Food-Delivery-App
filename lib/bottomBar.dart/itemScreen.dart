// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:divine/backgroundDesign/bg.dart';
import '../colors.dart';
import '../screens/drawerScreen.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key, this.originalPrice, this.noOrders = 1});

  final int? noOrders;
  final num? originalPrice;
  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  final firebase = FirebaseFirestore.instance.collection('deals').snapshots();
  final firestore = FirebaseFirestore.instance.collection('Cart');
  final fireStore1 = FirebaseFirestore.instance
      .collection('Cart')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection('Cart')
      .snapshots();
  int noOrders = 1;
  //This method is used to send data to Firestore
  void addTOCart(ItemModal itemModal) async {
    final cartItemDoc = firestore
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('Cart')
        .doc(itemModal.itemName);

    final cartItemDocSnapshot = await cartItemDoc.get();

    if (cartItemDocSnapshot.exists) {
      final currentNoOrders = cartItemDocSnapshot.data()!['noOrders'];
      final updatedNoOrders = currentNoOrders + 1;

      // Calculate the new total price
      final newPrice = calculateTotalPrice(itemModal.price, updatedNoOrders);

      cartItemDoc.update({
        'noOrders': updatedNoOrders,
        'price': newPrice, // Update the price as well
      });
    } else {
      final newPrice = calculateTotalPrice(
          itemModal.price, 1); // Always set to 1 when adding a new item
      cartItemDoc.set({
        'itemName': itemModal.itemName,
        'image': itemModal.image,
        'price': newPrice,
        'noOrders': 1,
        'originalPrice': itemModal.price,
        'quantity': itemModal.quantity,
      });
    }
  }

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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: height * 0.08,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(11, 8, 0, 0),
                      child: Text(
                        'DEALS',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 10, 0),
                      child: InkWell(
                          onTap: () {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: const DrawerScreen(),
                              withNavBar: true,
                            );
                          },
                          child: const Icon(Icons.menu,
                              color: Colors.white, size: 27)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.79,
                width: width * 0.9,
                child: StreamBuilder<dynamic>(
                  stream: firebase,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(color: boxColor));
                    } else if (snapshot.data!.docs.isNotEmpty) {
                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1, crossAxisSpacing: 5),
                        itemBuilder: (context, index) {
                          ItemModal itemModal = ItemModal.fromMap(
                              snapshot.data!.docs[index].data());
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: boxColor),
                              child: Column(
                                children: [
                                  SizedBox(
                                      height: height * 0.25,
                                      child: Image.network(
                                        itemModal.image,
                                        fit: BoxFit.cover,
                                      )),
                                  SizedBox(
                                      height: height * 0.05,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 7),
                                        child: Text(itemModal.itemName,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: whiteColor,
                                                fontWeight: FontWeight.bold)),
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text('Rs. ',
                                              style: TextStyle(
                                                  color: yellow, fontSize: 13)),
                                          Text(itemModal.price.toString(),
                                              style: const TextStyle(
                                                  color: whiteColor,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      )),
                                  InkWell(
                                    onTap: () {
                                      addTOCart(itemModal);
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          height: height * 0.05,
                                          width: width * 0.28,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(13),
                                            color: yellow,
                                          ),
                                          child: const Center(
                                              child: FittedBox(
                                            child: Text('Add to cart',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: whiteColor,
                                                    fontWeight:
                                                        FontWeight.w900)),
                                          )),
                                        ),
                                        SizedBox(height: height * 0.07),
                                        StreamBuilder(
                                          stream: fireStore1,
                                          builder: (context, snapshot) {
                                            num newtotalNoOfOrders = 0;
                                            if (snapshot.hasData) {
                                              final cartItems =
                                                  snapshot.data!.docs;

                                              for (var cartItem in cartItems) {
                                                if (cartItem['itemName'] ==
                                                    itemModal.itemName) {
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                  )
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
            ],
          ),
        )
      ],
    )));
  }
}

class ItemModal {
  String itemName;
  num price;
  String image;
  int? noOrders;
  String quantity;
  ItemModal({
    required this.itemName,
    required this.price,
    required this.image,
    this.noOrders,
    required this.quantity,
  });

  ItemModal copyWith({
    String? itemName,
    num? price,
    String? image,
    int? noOrders,
    String? quantity,
  }) {
    return ItemModal(
      itemName: itemName ?? this.itemName,
      price: price ?? this.price,
      image: image ?? this.image,
      noOrders: noOrders ?? this.noOrders,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'itemName': itemName,
      'price': price,
      'image': image,
      'noOrders': noOrders,
      'quantity': quantity,
    };
  }

  factory ItemModal.fromMap(Map<String, dynamic> map) {
    return ItemModal(
      itemName: map['itemName'] as String,
      price: map['price'] as num,
      image: map['image'] as String,
      noOrders: map['noOrders'] != null ? map['noOrders'] as int : null,
      quantity: map['quantity'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemModal.fromJson(String source) =>
      ItemModal.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItemModal(itemName: $itemName, price: $price, image: $image, noOrders: $noOrders, quantity: $quantity)';
  }

  @override
  bool operator ==(covariant ItemModal other) {
    if (identical(this, other)) return true;

    return other.itemName == itemName &&
        other.price == price &&
        other.image == image &&
        other.noOrders == noOrders &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return itemName.hashCode ^
        price.hashCode ^
        image.hashCode ^
        noOrders.hashCode ^
        quantity.hashCode;
  }
}
