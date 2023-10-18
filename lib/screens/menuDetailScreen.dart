// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:divine/backgroundDesign/bg.dart';
import 'package:divine/colors.dart';
import 'drawerScreen.dart';
import 'menuDescriptionScreen.dart';

// ignore: must_be_immutable
class HomeDetailScreen extends StatefulWidget {
  HomeDetailScreen({required this.id, super.key});
  static const pageName = "/HomeDetailScreen";

  String id;
  @override
  State<HomeDetailScreen> createState() => _HomeDetailScreenState();
}

class _HomeDetailScreenState extends State<HomeDetailScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    String id = widget.id.trim();
    final fireStore = FirebaseFirestore.instance
        .collection("drinks")
        .doc(id)
        .collection("shakes")
        .snapshots();
    final firebase = FirebaseFirestore.instance
        .collection('drinks')
        .doc(id)
        .collection('appBarName')
        .snapshots();
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          const BackGroundDesign(),
          Column(
            children: [
              SizedBox(
                  height: height * 0.07,
                  width: width,
                  //Fetch the Appbar name from Firestore
                  child: StreamBuilder(
                    stream: firebase,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: boxColor,
                        ));
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            AppBar appBar = AppBar.fromMap(
                                snapshot.data!.docs[index].data());
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(11, 8, 0, 0),
                                    child: Text(
                                      appBar.itemName,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 8, 10, 0),
                                    child: InkWell(
                                        onTap: () {
                                          PersistentNavBarNavigator
                                              .pushNewScreen(
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
                  )),
              SizedBox(
                height: height * 0.8,
                width: width,
                child: SingleChildScrollView(
                  //Fetch the ItemsDetail from Firestore
                  child: StreamBuilder(
                    stream: fireStore,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: Column(
                          children: [
                            SizedBox(
                              height: height * 0.4,
                            ),
                            const CircularProgressIndicator(color: boxColor),
                          ],
                        ));
                      } else if (snapshot.data!.docs.isNotEmpty) {
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 2 / 3,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5),
                          itemBuilder: (context, index) {
                            HomeModal homeModal = HomeModal.fromMap(
                                snapshot.data!.docs[index].data());

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(PageRouteBuilder(
                                      pageBuilder: ((context, animation,
                                              secondaryAnimation) =>
                                          DescriptionScreen(
                                            originalPrice: homeModal.price,
                                            quantity: homeModal.quantity,
                                            description: homeModal.description,
                                            id: homeModal.id,
                                            itemName: homeModal.itemName,
                                            price: homeModal.price,
                                            image: homeModal.image,
                                          )),
                                      transitionDuration:
                                          const Duration(seconds: 1),
                                      reverseTransitionDuration:
                                          const Duration(seconds: 1)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: boxColor),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Hero(
                                          flightShuttleBuilder: (flightContext,
                                              animation,
                                              flightDirection,
                                              fromHeroContext,
                                              toHeroContext) {
                                            final Widget toHero =
                                                toHeroContext.widget;
                                            return RotationTransition(
                                              turns: animation,
                                              child: toHero,
                                            );
                                          },
                                          tag: homeModal.image,
                                          child: Image.network(
                                            homeModal.image,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4, right: 4),
                                        child: FittedBox(
                                          child: Text(homeModal.itemName,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: whiteColor,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text('Rs. ',
                                                  style: TextStyle(
                                                      color: yellow,
                                                      fontSize: 13)),
                                              Text(homeModal.price.toString(),
                                                  style: const TextStyle(
                                                      color: whiteColor,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          )),
                                      Container(
                                        height: height * 0.04,
                                        width: width * 0.25,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(13),
                                          color: const Color.fromARGB(
                                              255, 225, 205, 18),
                                        ),
                                        child: const Center(
                                            child: FittedBox(
                                          child: Text('Add to cart',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: whiteColor,
                                                  fontWeight: FontWeight.w900)),
                                        )),
                                      ),
                                      SizedBox(height: height * 0.01)
                                    ],
                                  ),
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
              ),
            ],
          )
        ],
      ),
    ));
  }
}

class HomeModal {
  String image;
  String id;
  String itemName;
  num price;
  String description;
  String quantity;
  HomeModal({
    required this.image,
    required this.id,
    required this.itemName,
    required this.price,
    required this.description,
    required this.quantity,
  });

  HomeModal copyWith({
    String? image,
    String? id,
    String? itemName,
    num? price,
    String? description,
    String? quantity,
  }) {
    return HomeModal(
      image: image ?? this.image,
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      price: price ?? this.price,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image': image,
      'id': id,
      'itemName': itemName,
      'price': price,
      'description': description,
      'quantity': quantity,
    };
  }

  factory HomeModal.fromMap(Map<String, dynamic> map) {
    return HomeModal(
      image: map['image'] as String,
      id: map['id'] as String,
      itemName: map['itemName'] as String,
      price: map['price'] as num,
      description: map['description'] as String,
      quantity: map['quantity'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeModal.fromJson(String source) =>
      HomeModal.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HomeModal(image: $image, id: $id, itemName: $itemName, price: $price, description: $description, quantity: $quantity)';
  }

  @override
  bool operator ==(covariant HomeModal other) {
    if (identical(this, other)) return true;

    return other.image == image &&
        other.id == id &&
        other.itemName == itemName &&
        other.price == price &&
        other.description == description &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return image.hashCode ^
        id.hashCode ^
        itemName.hashCode ^
        price.hashCode ^
        description.hashCode ^
        quantity.hashCode;
  }
}

class AppBar {
  String id;
  String itemName;
  AppBar({
    required this.id,
    required this.itemName,
  });

  AppBar copyWith({
    String? id,
    String? itemName,
  }) {
    return AppBar(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'itemName': itemName,
    };
  }

  factory AppBar.fromMap(Map<String, dynamic> map) {
    return AppBar(
      id: map['id'] as String,
      itemName: map['itemName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppBar.fromJson(String source) =>
      AppBar.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AppBar(id: $id, itemName: $itemName)';

  @override
  bool operator ==(covariant AppBar other) {
    if (identical(this, other)) return true;

    return other.id == id && other.itemName == itemName;
  }

  @override
  int get hashCode => id.hashCode ^ itemName.hashCode;
}
