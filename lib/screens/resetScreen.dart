import 'package:divine/backgroundDesign/bg.dart';
import 'package:divine/resuableWidget/textField.dart';
import 'package:divine/screens/utlis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../colors.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({Key? key}) : super(key: key);
  static const pageName = "/ResetScreen";

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formField = GlobalKey<FormState>();
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
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: iconBack(height * 0.05, width * 0.2, context),
            ),
          ),
          Center(
            child: SizedBox(
              height: height * 0.5,
              child: Form(
                  key: formField,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Forgot Your Password',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: yellow)),
                        emailTextField(height * 0.1, width * 0.85, 'Email',
                            emailController, 'Enter a valid email'),
                        SizedBox(
                          height: height * 0.08,
                          width: width * 0.7,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (formField.currentState!.validate()) {
                                  FirebaseAuth.instance
                                      .sendPasswordResetEmail(
                                          email:
                                              emailController.text.toString())
                                      .then((value) {
                                    showAlertDialog(context, 'Info',
                                        'Password reset request sent, you will receive a recovery link within a few seconds');
                                  }).onError((error, stackTrace) {
                                    showAlertDialog(
                                        context, 'Error', error.toString());
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: yellow,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: const Text('Retrieve Password',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      fontSize: 16)),
                            ),
                          ),
                        )
                      ])),
            ),
          ),
        ],
      ),
    ));
  }
}

Widget iconBack(double height, double width, BuildContext context) {
  return SizedBox(
    height: height,
    width: width,
    child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          color: yellow,
          size: 27,
        )),
  );
}
