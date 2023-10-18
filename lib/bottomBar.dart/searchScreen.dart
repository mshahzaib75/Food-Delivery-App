import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divine/backgroundDesign/bg.dart';
import 'package:divine/colors.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../screens/menuDescriptionScreen.dart';
import '../screens/drawerScreen.dart';
import '../screens/menuDetailScreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<HomeModal> foodList = <HomeModal>[];
  List<HomeModal> filterList = <HomeModal>[];

  @override
  void initState() {
    super.initState();
    outerListModel();
  }

  void outerListModel() async {
    final outerfireStore =
        await FirebaseFirestore.instance.collection("drinks").get();
    for (var element in outerfireStore.docs) {
      final innerfireStore = await element.reference.collection('shakes').get();
      foodList.addAll(
          innerfireStore.docs.map((e) => HomeModal.fromMap(e.data())).toList());
    }
    foodList
        .addAll(outerfireStore.docs.map((e) => HomeModal.fromMap(e.data())));
    filterList.addAll(foodList);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    // Check if filterList is empty and the searchController text is empty
    bool isNoSearchResults =
        filterList.isEmpty && searchController.text.isEmpty;
    bool noSearchResults =
        filterList.isEmpty && searchController.text.isNotEmpty;
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const BackGroundDesign(),
          SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                width: width,
                height: height * 0.07,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                          padding: EdgeInsets.fromLTRB(10, 8, 0, 0),
                          child: Text(
                            'SEARCH',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900),
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 10, 0),
                        child: InkWell(
                            onTap: () =>
                                PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  screen: const DrawerScreen(),
                                  withNavBar: true,
                                ),
                            child: const Icon(Icons.menu,
                                color: Colors.white, size: 27)),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                  height: height * 0.08,
                  width: width * 0.8,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 18, 10, 0),
                    child: TextField(
                      controller: searchController,
                      cursorColor: whiteColor,
                      autocorrect: true,
                      style: const TextStyle(color: whiteColor),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          filterList = foodList.where((element) {
                            return element.itemName
                                .toLowerCase()
                                .contains(value.toLowerCase());
                          }).toList();
                        } else {
                          filterList.clear();
                        }
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: yellow,
                          hintText: 'Search',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w500, color: whiteColor),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: yellow),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: yellow),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: yellow),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                    ),
                  )),
              SizedBox(
                  height: height * 0.69,
                  width: width * 0.95,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(7, 35, 7, 0),
                      child: isNoSearchResults
                          ? Container(
                              color: boxColor,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(12, 12, 0, 0),
                                      child: Text(
                                        'Recent Searches',
                                        style: TextStyle(
                                          color: whiteColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 150),
                                  Center(
                                      child: Icon(Icons.search,
                                          size: 50, color: whiteColor)),
                                  Center(
                                    child: Text(
                                      'No recent searches',
                                      style: TextStyle(
                                          fontSize: 15, color: whiteColor),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : noSearchResults
                              ? Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 20),
                                      child: Text(
                                        'Woops...No record found!',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: whiteColor,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.6,
                                      child: Container(
                                        color: boxColor,
                                        child: const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    12, 12, 0, 0),
                                                child: Text(
                                                  'Recent Searches',
                                                  style: TextStyle(
                                                    color: whiteColor,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 150),
                                            Center(
                                                child: Icon(Icons.search,
                                                    size: 50,
                                                    color: whiteColor)),
                                            Center(
                                              child: Text(
                                                'No recent searches',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: whiteColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: filterList.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio: 2 / 3,
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 5),
                                  itemBuilder: (context, index) {
                                    HomeModal homeModal = filterList[index];

                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              PageRouteBuilder(
                                                  pageBuilder: ((context,
                                                          animation,
                                                          secondaryAnimation) =>
                                                      DescriptionScreen(
                                                        originalPrice:
                                                            homeModal.price,
                                                        quantity:
                                                            homeModal.quantity,
                                                        description: homeModal
                                                            .description,
                                                        id: homeModal.id,
                                                        itemName:
                                                            homeModal.itemName,
                                                        price: homeModal.price,
                                                        image: homeModal.image,
                                                      )),
                                                  transitionDuration:
                                                      const Duration(
                                                          seconds: 1),
                                                  reverseTransitionDuration:
                                                      const Duration(
                                                          seconds: 1)));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: boxColor),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                flex: 6,
                                                child: Hero(
                                                  flightShuttleBuilder:
                                                      (flightContext,
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
                                                  child: Text(
                                                      homeModal.itemName,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: whiteColor,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const FittedBox(
                                                        child: Text('Rs. ',
                                                            style: TextStyle(
                                                                color: yellow,
                                                                fontSize: 13)),
                                                      ),
                                                      FittedBox(
                                                        child: Text(
                                                            homeModal.price
                                                                .toString(),
                                                            style: const TextStyle(
                                                                color:
                                                                    whiteColor,
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
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
                                                  child: FittedBox(
                                                    child: Text('Add to cart',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: whiteColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900)),
                                                  ),
                                                )),
                                              ),
                                              SizedBox(height: height * 0.01)
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ))),
              SizedBox(height: height * 0.05)
            ]),
          )
        ],
      ),
    ));
  }
}
