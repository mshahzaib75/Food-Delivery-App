import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divine/backgroundDesign/bg.dart';
import 'package:divine/colors.dart';
import 'package:divine/modelClass/itemPage.dart';
import 'package:divine/modelClass/itemPagePic.dart';
import 'package:divine/screens/menuDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../screens/drawerScreen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final firestore =
      FirebaseFirestore.instance.collection('picture').snapshots();
  final firebase = FirebaseFirestore.instance.collection('drinks').snapshots();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var widthh = size.width;
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
                height: height * 0.3,
                width: widthh,
                child: StreamBuilder<dynamic>(
                  stream: firestore,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: boxColor,
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return Stack(
                        children: [
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1),
                            itemBuilder: (context, index) {
                              Picture picture = Picture.fromMap(
                                  snapshot.data.docs[index].data());
                              return SizedBox(
                                  child: Image.network(
                                picture.image,
                                fit: BoxFit.cover,
                              ));
                            },
                          ),
                          Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 5, 0),
                                  child: IconButton(
                                      onPressed: () {
                                        PersistentNavBarNavigator.pushNewScreen(
                                          context,
                                          screen: const DrawerScreen(),
                                          withNavBar: true,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.menu,
                                        size: 27,
                                        color: yellow,
                                      ))))
                        ],
                      );
                    } else {
                      return const Text(
                        'Something went wrong',
                        style: TextStyle(color: Colors.red, fontSize: 17),
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                height: height * 0.1,
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('DIVINE',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: whiteColor)),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('Range',
                          style: TextStyle(
                              fontSize: 17,
                              color: yellow,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic)),
                    ),
                    Expanded(
                      child: Container(
                          margin:
                              const EdgeInsets.only(left: 45.0, right: 15.0),
                          child: const Divider(
                            color: Colors.white,
                            thickness: 2,
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height,
                width: widthh,
                child: StreamBuilder<dynamic>(
                  stream: firebase,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(color: boxColor));
                    } else if (snapshot.hasData) {
                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 4 / 5,
                                crossAxisCount: 2,
                                crossAxisSpacing: 5),
                        itemBuilder: (context, index) {
                          Product product =
                              Product.fromMap(snapshot.data.docs[index].data());
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return HomeDetailScreen(id: product.id);
                                  },
                                ));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: boxColor),
                                child: Column(
                                  children: [
                                    Expanded(
                                        flex: 6,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 3),
                                          child: Image.network(product.image),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Text(product.name,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: whiteColor,
                                                fontWeight: FontWeight.bold))),
                                    Expanded(
                                        flex: 1,
                                        child: Text(product.range,
                                            style: const TextStyle(
                                                color: yellow,
                                                fontSize: 12,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Text(
                        'Something went wrong',
                        style: TextStyle(color: Colors.red, fontSize: 17),
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
