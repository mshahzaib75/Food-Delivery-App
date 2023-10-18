import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divine/backgroundDesign/bg.dart';
import 'package:divine/resuableWidget/textField.dart';
import 'package:divine/screens/utlis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static const pageName = "/SignUpScreen";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final user = FirebaseFirestore.instance.collection('SignUpUsers');
  TextEditingController emailController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  bool isPasswordType = true;
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

  RegExp name_valid =
      RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
  bool validateName(String name) {
    String _name = name.toUpperCase();
    if (name_valid.hasMatch(_name)) {
      return true;
    } else {
      return false;
    }
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
          SizedBox(
            height: height * 0.9,
            child: Center(
              child: Form(
                key: formField,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 0, 0, 25),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: yellow,
                                size: 27,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.07,
                      ),
                      register(height * 0.09),
                      emailTextField(height * 0.13, width * 0.85, 'Email',
                          emailController, 'Email'),
                      passwordTextField(height * 0.14, width * 0.85, 'Password',
                          passWordController, 'Password'),
                      nameTextField(height * 0.13, width * 0.85, 'Username',
                          firstNameController, 'Username'),
                      mobileTextField(height * 0.13, width * 0.85, 'Phone',
                          phoneNoController, 'Phone'),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 90),
                        child: signUpButton(
                            height * 0.07, width * 0.85, 'Create', () async {
                          if (formField.currentState!.validate()) {
                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: emailController.text.toString(),
                                    password:
                                        passWordController.text.toString())
                                .then((value) async {
                              Utils()
                                  .toastMessage('Account Creaed Successfully');
                              await Future.delayed(
                                  const Duration(milliseconds: 100));
                              Navigator.of(context).pop();
                            }).onError((error, stackTrace) {
                              showAlertDialog(
                                  context, 'Error', error.toString());
                            });
                            //Send the user data to Firestore
                            await user.doc(emailController.text).set({
                              'email': emailController.text,
                              'password': passWordController.text,
                              'displayName': firstNameController.text,
                              'phone': phoneNoController.text.toString()
                            });
                          }
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget signUpButton(
      double height, double width, String text, Function onTap) {
    return SizedBox(
      height: height,
      width: width,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
          onPressed: () {
            onTap();
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: yellow,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: Text(text,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16)),
        ),
      ),
    );
  }

  Widget passwordTextField(double height, double width, String text,
      TextEditingController controller, String hintText) {
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        controller: controller,
        obscureText: isPasswordType,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: const TextStyle(color: whiteColor),
        cursorColor: whiteColor,
        decoration: InputDecoration(
            labelText: text,
            prefixIcon: const Icon(Icons.lock, color: yellow),
            errorMaxLines: 2,
            errorStyle: const TextStyle(color: Colors.red, fontSize: 10),
            hintText: hintText,
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
              return 'Password should contain Capital, small letter & number & Special character ';
            }
          }
        },
        keyboardType: TextInputType.visiblePassword,
      ),
    );
  }

  Widget nameTextField(double height, double width, String text,
      TextEditingController controller, String hintText) {
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        cursorColor: whiteColor,
        style: const TextStyle(color: whiteColor),
        decoration: InputDecoration(
            errorMaxLines: 2,
            errorStyle: const TextStyle(fontSize: 10, color: Colors.red),
            hintText: hintText,
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
          if (value == null || value.isEmpty) {
            return 'Enter a name';
          } else {
            bool result = validateName(value);
            if (result) {
              return null;
            } else {
              return "Format 'Full Name'";
            }
          }
        },
        keyboardType: TextInputType.text,
      ),
    );
  }
}

Widget register(double height) {
  return SizedBox(
    height: height,
    child: const Text('Register',
        style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.w900, color: yellow)),
  );
}
