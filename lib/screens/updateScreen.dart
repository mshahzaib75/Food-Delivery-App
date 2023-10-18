import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divine/resuableWidget/button.dart';
import 'package:divine/screens/utlis.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../backgroundDesign/bg.dart';
import '../colors.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

Future<DocumentSnapshot<Map<String, dynamic>>> getData() async {
  return await FirebaseFirestore.instance
      .collection('SignUpUsers')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .get();
}

Map<String, dynamic> userData = {};

class _UpdateScreenState extends State<UpdateScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
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

  updateUserDetails() {
    FirebaseFirestore.instance
        .collection('SignUpUsers')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update({
      'email': emailController.text,
      'displayName': nameController.text,
      'password': passController.text,
      'phone': phoneController.text.toString()
    }).then((value) {
      Utils().toastMessage('Data updated successfully');
    });
  }

  updateDetails() {
    FirebaseFirestore.instance
        .collection('UserData')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update({
      'password': passController.text,
      'email': emailController.text,
    });
  }

  Future<void> loadUserData() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await getData();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data()!;
      setState(() {
        emailController.text = data['email'];
        nameController.text = data['displayName'];
        passController.text = data['password'];
        phoneController.text = data['phone'];

        userData = snapshot.data()!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

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
          SingleChildScrollView(
            child: SizedBox(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 7, 10, 0),
                      child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 27,
                            color: yellow,
                          )),
                    ),
                  ),
                  SizedBox(height: height * 0.06),
                  const FittedBox(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Text('UPDATE PERSONAL DETAILS',
                          style: TextStyle(
                              fontSize: 18,
                              color: yellow,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(18, 20, 10, 0),
                    child: Text(
                        'You can access and modify your personal details  (name, biling address, telephone number etc.) in   order to facilitate your future purchases and to  notify us of any change in your contact details',
                        style: TextStyle(
                          fontSize: 14,
                          color: whiteColor,
                        )),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Form(
                      key: formField,
                      child: Column(
                        children: [
                          emailUpdateField(height * 0.08, width * 0.8,
                              userData['email'].toString(), emailController),
                          userNameUpdateField(
                              height * 0.08,
                              width * 0.8,
                              userData['displayName'].toString(),
                              nameController),
                          passwordUpdateField(height * 0.08, width * 0.8,
                              userData['password'].toString(), passController),
                          phoneUpdateField(height * 0.08, width * 0.8,
                              userData['phone'].toString(), phoneController),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  clickButton(height * 0.06, width * 0.4, 'Update', () {
                    if (formField.currentState!.validate()) {
                      //Update the fields
                      updateDetails();
                      updateUserDetails();
                    }
                  })
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }

  Widget userNameUpdateField(
    double height,
    double width,
    String value,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        cursorColor: whiteColor,
        textAlign: TextAlign.start,
        controller: controller,
        decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            border: const UnderlineInputBorder(),
            labelText: 'Username',
            labelStyle: const TextStyle(
              fontSize: 18,
              color: yellow,
              fontWeight: FontWeight.w900,
            ),
            hintStyle: const TextStyle(color: Colors.white),
            hintText: value,
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white))),
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
      ),
    );
  }

  Widget passwordUpdateField(
    double height,
    double width,
    String value,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        cursorColor: whiteColor,
        textAlign: TextAlign.start,
        controller: controller,
        decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            border: const UnderlineInputBorder(),
            labelText: 'Password',
            labelStyle: const TextStyle(
              fontSize: 19,
              color: yellow,
              fontWeight: FontWeight.w900,
            ),
            hintStyle: const TextStyle(color: Colors.white),
            hintText: value,
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white))),
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
      ),
    );
  }

  Widget emailUpdateField(
    double height,
    double width,
    String value,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        cursorColor: whiteColor,
        textAlign: TextAlign.start,
        controller: controller,
        decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            border: const UnderlineInputBorder(),
            labelText: 'Email',
            labelStyle: const TextStyle(
              fontSize: 19,
              color: yellow,
              fontWeight: FontWeight.w900,
            ),
            hintStyle: const TextStyle(color: Colors.white),
            hintText: value,
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white))),
        validator: (email) {
          if (email != null && !EmailValidator.validate(email)) {
            return 'Enter a valid email';
          }
          return null;
        },
      ),
    );
  }

  Widget phoneUpdateField(
    double height,
    double width,
    String value,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        cursorColor: whiteColor,
        textAlign: TextAlign.start,
        controller: controller,
        decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            border: const UnderlineInputBorder(),
            labelText: 'Phone',
            labelStyle: const TextStyle(
              fontSize: 19,
              color: yellow,
              fontWeight: FontWeight.w900,
            ),
            hintStyle: const TextStyle(color: Colors.white),
            hintText: value,
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white))),
        validator: (value) {
          bool phoneValid =
              RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value!);
          if (value.isEmpty) {
            return 'Enter phone number';
          } else if (!phoneValid && controller.text.length != 11) {
            return 'Enter valid phone number';
          }
          return null;
        },
        keyboardType: TextInputType.phone,
      ),
    );
  }
}
