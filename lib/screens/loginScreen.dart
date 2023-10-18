import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divine/backgroundDesign/bg.dart';
import 'package:divine/colors.dart';
import 'package:divine/screens/phoneScreen.dart';
import 'package:divine/screens/resetScreen.dart';
import 'package:divine/screens/signupScreen.dart';
import 'package:divine/screens/utlis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../resuableWidget/button.dart';
import '../resuableWidget/textField.dart';
import 'bottomNavigationBar.dart';

class DivineApp extends StatefulWidget {
  const DivineApp({Key? key}) : super(key: key);
  static const pageName = "/DivineApp";

  @override
  State<DivineApp> createState() => _DivineAppState();
}

class _DivineAppState extends State<DivineApp> {
  bool isRemember = false;
  bool isPasswordType = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  GlobalKey<FormState> formField = GlobalKey<FormState>();
  RegExp pass_valid =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  bool validatePassword(String pass) {
    String _password = pass.trim();
    if (pass_valid.hasMatch(_password)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> loadUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      emailController.text = preferences.getString('savedEmail') ?? '';
      passWordController.text = preferences.getString('savedPassword') ?? '';
    });
  }

  Future<void> savedUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (isRemember) {
      //save data to shared prefernces
      preferences.setString('savedEmail', emailController.text);
      preferences.setString('savedPassword', passWordController.text);
    } else {
      //remove the data from shared prefrences
      preferences.remove('savedEmail');
      preferences.remove('savedPassword');
    }
  }

  Future<void> storeUserGoogleData(UserCredential userCredential) async {
    final user = userCredential.user;
    if (user != null) {
      final users = FirebaseFirestore.instance.collection('GoogleUsersData');
      await users.doc(user.email).set({
        'email': user.email,
        'displayName': user.displayName,
        'image': user.photoURL,
        'phone': user.phoneNumber.toString()
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passWordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference user =
        FirebaseFirestore.instance.collection('UserData');
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          const BackGroundDesign(),
          SingleChildScrollView(
            child: Center(
              child: Form(
                key: formField,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * 0.13,
                    ),
                    SizedBox(
                      height: height * 0.1,
                      width: width * 0.5,
                      child: FittedBox(
                        child: AnimatedTextKit(
                          animatedTexts: [
                            WavyAnimatedText('Divine',
                                speed: const Duration(milliseconds: 500),
                                textStyle: const TextStyle(
                                    color: yellow,
                                    fontSize: 46,
                                    fontWeight: FontWeight.w600)),
                          ],
                          displayFullTextOnTap: true,
                          repeatForever: true,
                          totalRepeatCount: 3,
                          pause: const Duration(milliseconds: 300),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    emailTextField(height * 0.13, width * 0.85, 'Email',
                        emailController, 'Email'),
                    passWordTextField(height * 0.13, width * 0.85, 'Password',
                        passWordController, 'Password'),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    clickButton(height * 0.07, width * 0.85, 'Log In',
                        () async {
                      if (formField.currentState!.validate()) {
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: emailController.text.toString(),
                                password: passWordController.text.toString())
                            .then((value) {
                          Utils().toastMessage('User Login Successfully');
                          //  Utils().toastMessage(value.user!.email.toString());
                          FirebaseFirestore.instance
                              .collection('SignUpUsers')
                              .doc(FirebaseAuth.instance.currentUser!.email)
                              .update({'password': passWordController.text});
                          user.doc(emailController.text).set({
                            'email': emailController.text,
                            'password': passWordController.text
                          });
                          FirebaseFirestore.instance
                              .collection('UserData')
                              .doc(FirebaseAuth.instance.currentUser!.email)
                              .update({'password': passWordController.text});
                          Navigator.of(context)
                              .pushNamed(BottomBarDesign.pageName);
                        }).onError((error, stackTrace) {
                          Utils().toastMessage(error.toString());
                        });
                        //Store the data to Firestore

                        //Update the password
                      }
                    }),
                    SizedBox(height: height * 0.02),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return const ResetScreen();
                            },
                          ));
                        },
                        child: Align(
                            alignment: Alignment.center,
                            child:
                                forgetButton(height * 0.035, width, context))),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: width * 0.1,
                        ),
                        rememberButton(height * 0.03, width * 0.5),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 7),
                            child: checkBox(height * 0.03, width * 0.2)),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    orLine(height * 0.035, width * 0.85),
                    SizedBox(
                      width: width * 0.3,
                      height: height * 0.075,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: height * 0.04,
                            width: width * 0.095,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, PhoneScreen.pageName);
                              },
                              child: const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/phone.jpeg'),
                                radius: 10,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.04,
                            width: width * 0.095,
                            child: InkWell(
                              onTap: () async {
                                try {
                                  final GoogleSignInAccount?
                                      googleSignInAccount =
                                      await GoogleSignIn().signIn();
                                  if (googleSignInAccount != null) {
                                    GoogleSignInAuthentication
                                        googleSignInAuthentication =
                                        await googleSignInAccount
                                            .authentication;
                                    final AuthCredential authCredential =
                                        GoogleAuthProvider.credential(
                                            accessToken:
                                                googleSignInAuthentication
                                                    .accessToken,
                                            idToken: googleSignInAuthentication
                                                .idToken);

                                    final UserCredential userCredential =
                                        await FirebaseAuth.instance
                                            .signInWithCredential(
                                                authCredential);
                                    await storeUserGoogleData(userCredential);
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return const BottomBarDesign();
                                      },
                                    ));
                                  }
                                } on FirebaseAuthException catch (e) {
                                  throw e;
                                }
                              },
                              child: const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/google1.jpg'),
                                radius: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text(height * 0.045, width * 0.45),
                        SizedBox(width: width * 0.03),
                        createButton(height * 0.045, width * 0.3, context),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
  }

  Widget checkBox(double height, double width) {
    return SizedBox(
      height: height,
      width: width,
      child: Checkbox(
        activeColor: yellow,
        onChanged: (value) {
          setState(() {
            isRemember = value!;
          });
          savedUserData();
        },
        value: isRemember,
        focusColor: yellow,
        side: const BorderSide(color: Colors.white),
      ),
    );
  }

  Widget createButton(double height, double width, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(SignUpScreen.pageName);
      },
      child: const Text('Create Now',
          style: TextStyle(
              fontSize: 15,
              color: yellow,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w800,
              decorationColor: yellow)),
    );
  }

  Widget passWordTextField(double height, double width, String text,
      TextEditingController controller, String hintText) {
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: isPasswordType,
        style: const TextStyle(color: whiteColor),
        cursorColor: whiteColor,
        decoration: InputDecoration(
            labelText: text,
            errorMaxLines: 2,
            errorStyle: const TextStyle(fontSize: 10, color: Colors.red),
            hintText: hintText,
            prefixIcon: const Icon(Icons.lock, color: yellow),
            hintStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500),
            labelStyle: const TextStyle(color: whiteColor),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: whiteColor),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: whiteColor),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            suffixIcon: IconButton(
              icon: isPasswordType
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
              color: yellow,
              onPressed: () {
                setState(() {
                  isPasswordType = !isPasswordType;
                });
              },
            ),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Enter Password';
          } else if (controller.text.length <= 4) {
            return 'Password is too short';
          } else {
            bool result = validatePassword(value);
            if (result) {
              return null;
            } else {
              return 'Password should contain Capital, small letter & number & Special charcter';
            }
          }
        },
        keyboardType: TextInputType.visiblePassword,
      ),
    );
  }
}

Widget forgetButton(double height, double width, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).pushNamed(ResetScreen.pageName);
    },
    child: const Padding(
      padding: EdgeInsets.only(left: 20),
      child: Text('Forget Password?',
          style: TextStyle(
            color: whiteColor,
            fontWeight: FontWeight.w800,
          )),
    ),
  );
}

Widget rememberButton(double height, double width) {
  return const Text('Remember me?',
      style: TextStyle(
        color: whiteColor,
        fontWeight: FontWeight.w800,
      ));
}

Widget orLine(double height, double width) {
  return SizedBox(
    height: height,
    width: width,
    child: Row(children: <Widget>[
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 11.0, right: 10.0),
            child: const Divider(
              color: Colors.white,
              height: 50,
            )),
      ),
      const Text(
        "OR",
        style: TextStyle(
          color: whiteColor,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 11.0),
            child: const Divider(
              color: Colors.white,
              height: 50,
            )),
      ),
    ]),
  );
}

Widget text(double height, double width) {
  return const Text("Don't have an account?",
      style: TextStyle(
        color: whiteColor,
        fontWeight: FontWeight.w800,
      ));
}
