import 'package:divine/screens/utlis.dart';
import 'package:divine/screens/verficationScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../backgroundDesign/bg.dart';
import '../colors.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});
  static const pageName = '/PhoneScreen';
  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  TextEditingController phoneNoController = TextEditingController();
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
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                child: SizedBox(
                    height: height * 0.05,
                    width: width * 0.19,
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          size: 27,
                          color: yellow,
                        )))),
          ),
          Center(
            child: SizedBox(
              height: height * 0.5,
              child: Form(
                  key: formField,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        mobile1TextField(height * 0.1, width * 0.85, 'Phone',
                            phoneNoController, 'Phone'),
                        SizedBox(
                          height: height * 0.08,
                          width: width * 0.7,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (formField.currentState!.validate()) {
                                  FirebaseAuth.instance.verifyPhoneNumber(
                                    phoneNumber: phoneNoController.text,
                                    timeout: const Duration(seconds: 60),
                                    verificationCompleted:
                                        (PhoneAuthCredential credential) async {
                                      await FirebaseAuth.instance
                                          .signInWithCredential(credential);
                                    },
                                    verificationFailed:
                                        (FirebaseAuthException e) {
                                      Utils().toastMessage(e.toString());
                                    },
                                    codeSent: (String verificationId,
                                        int? resendToken) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) {
                                          return VerificationScreen(
                                            verificationId: verificationId,
                                          );
                                        },
                                      ));
                                    },
                                    codeAutoRetrievalTimeout: (e) {
                                      Utils().toastMessage(e.toString());
                                    },
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: yellow,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: const Text('Next',
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

Widget mobile1TextField(double height, double width, String text,
    TextEditingController controller, String hintText) {
  return SizedBox(
    height: height,
    width: width,
    child: TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: whiteColor,
      autocorrect: true,
      style: const TextStyle(color: whiteColor),
      decoration: InputDecoration(
          hintText: hintText,
          errorMaxLines: 2,
          errorStyle: const TextStyle(fontSize: 10, color: Colors.red),
          hintStyle:
              const TextStyle(fontWeight: FontWeight.w500, color: whiteColor),
          labelText: text,
          labelStyle: const TextStyle(color: whiteColor),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: whiteColor),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: whiteColor),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter mobile number';
        } else if (controller.text.length != 13) {
          return "Format '+923293921123'";
        }
        return null;
      },
      keyboardType: TextInputType.phone,
    ),
  );
}
