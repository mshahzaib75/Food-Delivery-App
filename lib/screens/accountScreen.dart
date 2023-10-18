import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divine/screens/loginScreen.dart';
import 'package:divine/screens/updateScreen.dart';
import 'package:divine/screens/utlis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../backgroundDesign/bg.dart';
import '../colors.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  static const pageName = '/AccountScreen';

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

Future<DocumentSnapshot<Map<String, dynamic>>> getData() async {
  return await FirebaseFirestore.instance
      .collection('SignUpUsers')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .get();
}

Future<void> deleteUser() async {
  try {
    //Delete user data from Firestore
    String userEmail = FirebaseAuth.instance.currentUser!.email!;
    await FirebaseFirestore.instance
        .collection('SignUpUsers')
        .doc(userEmail)
        .delete();

    //Delete user data from Firebase Authentication
    User user = FirebaseAuth.instance.currentUser!;
    await user.delete();
    Utils().toastMessage('User Deleted Successfully');
  } catch (e) {
    Utils().toastMessage(e.toString());
  }
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          const BackGroundDesign(),
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 7, 10, 0),
                  child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 27,
                        color: yellow,
                      )),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(6, 9, 0, 0),
                  child: Text('My Account',
                      style: TextStyle(
                          fontSize: 20,
                          color: whiteColor,
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 80, 0, 0),
            child: SizedBox(
              height: height * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  container(height * 0.08, width * 0.9, context, 'Email'),
                  container2(height * 0.08, width * 0.9, context, 'Username'),
                  container1(height * 0.08, width * 0.9, context, 'Password'),
                  container3(height * 0.08, width * 0.9, context, 'Mobile No'),
                  delete(height * 0.08, width * 0.9, context)
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}

Widget container(
    double height, double width, BuildContext context, String text1) {
  return Container(
    color: boxColor,
    width: width,
    height: height,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Center(
            child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.06,
              ),
              FittedBox(
                child: Text(text1,
                    style: const TextStyle(
                      fontSize: 14,
                      color: yellow,
                      fontWeight: FontWeight.w500,
                    )),
              ),
              FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        var data = snapshot.data!.data();
                        return FittedBox(
                          child: Text(
                            data!['email'],
                            style: const TextStyle(
                                fontSize: 14, color: whiteColor),
                          ),
                        );
                      } else {
                        return const FittedBox(
                          child: Text(
                            'No Data',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w900),
                          ),
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
                      return const FittedBox(
                        child: Text(
                          'Something went wrong',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w900),
                        ),
                      );
                    }
                  })
            ],
          ),
        )),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: InkWell(
            onTap: () {
              PersistentNavBarNavigator.pushNewScreen(context,
                  screen: const UpdateScreen(), withNavBar: false);
            },
            child: const Icon(
              Icons.edit_note_rounded,
              size: 27,
              color: yellow,
            ),
          ),
        )
      ],
    ),
  );
}

Widget container1(
    double height, double width, BuildContext context, String text1) {
  return Container(
    color: boxColor,
    width: width,
    height: height,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Center(
            child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.06,
              ),
              FittedBox(
                child: Text(text1,
                    style: const TextStyle(
                      fontSize: 14,
                      color: yellow,
                      fontWeight: FontWeight.w500,
                    )),
              ),
              FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        var data = snapshot.data!.data();
                        return FittedBox(
                          child: Text(
                            data!['password'],
                            style: const TextStyle(
                                fontSize: 14, color: whiteColor),
                          ),
                        );
                      } else {
                        return const FittedBox(
                          child: Text(
                            'No Data',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w900),
                          ),
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
                      return const FittedBox(
                        child: Text(
                          'Something went wrong',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w900),
                        ),
                      );
                    }
                  })
            ],
          ),
        )),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: InkWell(
            onTap: () {
              PersistentNavBarNavigator.pushNewScreen(context,
                  screen: const UpdateScreen(), withNavBar: false);
            },
            child: const Icon(
              Icons.edit_note_rounded,
              size: 27,
              color: yellow,
            ),
          ),
        )
      ],
    ),
  );
}

Widget container2(
    double height, double width, BuildContext context, String text1) {
  return Container(
    color: boxColor,
    width: width,
    height: height,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Center(
            child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.06,
              ),
              FittedBox(
                child: Text(text1,
                    style: const TextStyle(
                      fontSize: 14,
                      color: yellow,
                      fontWeight: FontWeight.w500,
                    )),
              ),
              FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        var data = snapshot.data!.data();
                        return FittedBox(
                          child: Text(
                            data!['displayName'].toString(),
                            style: const TextStyle(
                                fontSize: 14, color: whiteColor),
                          ),
                        );
                      } else {
                        return const FittedBox(
                          child: Text(
                            'No Data',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w900),
                          ),
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
                      return const FittedBox(
                        child: Text(
                          'Something went wrong',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w900),
                        ),
                      );
                    }
                  })
            ],
          ),
        )),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: InkWell(
            onTap: () {
              PersistentNavBarNavigator.pushNewScreen(context,
                  screen: const UpdateScreen(), withNavBar: false);
            },
            child: const Icon(
              Icons.edit_note_rounded,
              size: 27,
              color: yellow,
            ),
          ),
        )
      ],
    ),
  );
}

Widget container3(
    double height, double width, BuildContext context, String text1) {
  return Container(
    color: boxColor,
    width: width,
    height: height,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Center(
            child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.06,
              ),
              FittedBox(
                child: Text(text1,
                    style: const TextStyle(
                      fontSize: 14,
                      color: yellow,
                      fontWeight: FontWeight.w500,
                    )),
              ),
              FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        var data = snapshot.data!.data();
                        return FittedBox(
                          child: Text(
                            data!['phone'].toString(),
                            style: const TextStyle(
                                fontSize: 14, color: whiteColor),
                          ),
                        );
                      } else {
                        return const FittedBox(
                          child: Text(
                            'No Data',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w900),
                          ),
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
                      return const FittedBox(
                        child: Text(
                          'Something went wrong',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w900),
                        ),
                      );
                    }
                  })
            ],
          ),
        )),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: InkWell(
            onTap: () {
              PersistentNavBarNavigator.pushNewScreen(context,
                  screen: const UpdateScreen(), withNavBar: false);
            },
            child: const Icon(
              Icons.edit_note_rounded,
              size: 27,
              color: yellow,
            ),
          ),
        )
      ],
    ),
  );
}

Widget delete(
  double height,
  double width,
  BuildContext context,
) {
  return InkWell(
    onTap: () {},
    child: Container(
      width: width,
      height: height,
      color: boxColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "Proceed if you want to delete\n your account ",
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.w900, fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: yellow,
                      title: const Center(
                        child: FittedBox(
                          child: Text("DELETE",
                              style: TextStyle(
                                color: boxColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              )),
                        ),
                      ),
                      content: const Text(
                          'If you want to delete your account then press Yes',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                      actions: <Widget>[
                        TextButton(
                          style:
                              TextButton.styleFrom(backgroundColor: boxColor),
                          child: const FittedBox(
                            child: Text('Yes',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900)),
                          ),
                          onPressed: () {
                            deleteUser();
                            Future.delayed(const Duration(milliseconds: 100));
                            Navigator.pushNamedAndRemoveUntil(
                                context, DivineApp.pageName, (route) => false);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Icon(
                Icons.delete,
                size: 25,
                color: yellow,
              ),
            ),
          )
        ],
      ),
    ),
  );
}
