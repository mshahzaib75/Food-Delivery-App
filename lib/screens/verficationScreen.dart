import 'package:divine/screens/bottomNavigationBar.dart';
import 'package:divine/screens/utlis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../backgroundDesign/bg.dart';
import '../colors.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, required this.verificationId});
  final String verificationId;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  TextEditingController codeController = TextEditingController();
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
                  padding: const EdgeInsets.fromLTRB(18, 12, 0, 0),
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 27,
                        color: yellow,
                      )))),
          Center(
            child: SizedBox(
              height: height * 0.5,
              child: Form(
                  key: formField,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        codeTextField(height * 0.1, width * 0.85, 'Code',
                            codeController, 'Enter a 6 digit code'),
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
                                  final credential =
                                      PhoneAuthProvider.credential(
                                          verificationId: widget.verificationId,
                                          smsCode:
                                              codeController.text.toString());
                                  try {
                                    await FirebaseAuth.instance
                                        .signInWithCredential(credential);
                                  } catch (e) {
                                    Utils().toastMessage(e.toString());
                                  }
                                  Navigator.pushNamed(
                                      context, BottomBarDesign.pageName);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: yellow,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: const Text('Verify',
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

Widget codeTextField(double height, double width, String text,
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
        if (controller.text.length != 6) {
          return 'Enter a valid code';
        }
        return null;
      },
      keyboardType: TextInputType.phone,
    ),
  );
}
