import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:divine/backgroundDesign/bg.dart';
import 'package:divine/colors.dart';
import 'package:divine/resuableWidget/button.dart';
import 'package:divine/screens/utlis.dart';
import 'package:url_launcher/url_launcher.dart';
import '../resuableWidget/textField.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);
  static const pageName = "/ContactScreen";

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  GlobalKey<FormState> formField = GlobalKey<FormState>();
  _launchUrl(String url) async {
    Uri _url = Uri.parse(url);
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Cannot Launch $_url';
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
    final user = FirebaseFirestore.instance.collection('Complain');
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, right: 10),
                        child: iconBack(height * 0.05, width * 0.2, context),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    const FittedBox(
                      child: Text('Conatct Us',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: yellow)),
                    ),
                    SizedBox(height: height * 0.01),
                    const Icon(Icons.location_on_outlined,
                        color: whiteColor, size: 50),
                    SizedBox(height: height * 0.01),
                    const FittedBox(
                      child: Text('Head Office',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: yellow)),
                    ),
                    SizedBox(height: height * 0.01),
                    const FittedBox(
                      child: Text('Address: 14 A, E-2, Gulberg 3, Lahore PK',
                          style: TextStyle(color: whiteColor)),
                    ),
                    SizedBox(height: height * 0.01),
                    const FittedBox(
                      child: Text('Email: info@divine.com.pk',
                          style: TextStyle(color: whiteColor)),
                    ),
                    SizedBox(height: height * 0.01),
                    const Icon(Icons.headphones, color: whiteColor, size: 50),
                    SizedBox(height: height * 0.01),
                    const FittedBox(
                      child: Text('Customer Service Department',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: yellow)),
                    ),
                    SizedBox(height: height * 0.01),
                    const FittedBox(
                      child: Text('Contact: 42111722477',
                          style: TextStyle(color: whiteColor)),
                    ),
                    SizedBox(height: height * 0.01),
                    const FittedBox(
                      child: Text('Email: info@divine.com.pk',
                          style: TextStyle(color: whiteColor)),
                    ),
                    SizedBox(height: height * 0.01),
                    const FittedBox(
                      child: Text('Send Us A Message',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: yellow)),
                    ),
                    SizedBox(height: height * 0.03),
                    emailTextField(height * 0.12, width * 0.85, 'Email',
                        emailController, 'Email'),
                    nameTextField(height * 0.12, width * 0.85, 'Username',
                        nameController, 'Username'),
                    mobileTextField(height * 0.12, width * 0.85, 'Phone',
                        mobileController, 'Phone'),
                    textField(
                        height * 0.12,
                        width * 0.85,
                        'Subject',
                        "Subject is required",
                        false,
                        subjectController,
                        'Subject'),
                    textField(
                        height * 0.12,
                        width * 0.85,
                        'Message',
                        'Minimum 10 Characters Required*',
                        false,
                        messageController,
                        'Message'),
                    clickButton(height * 0.06, width * 0.4, 'Send', () async {
                      if (formField.currentState!.validate()) {
                        Utils().toastMessage('Message Send Successfully');
                      }
                      //To send the data to FireStore
                      await user
                          .doc(FirebaseAuth.instance.currentUser!.email)
                          .set({
                        'email': emailController.text,
                        'name': nameController.text,
                        'mobile': int.parse(mobileController.text),
                        'subject': subjectController.text,
                        'message': messageController.text
                      });
                    }),
                    SizedBox(height: height * 0.02),
                    const Text('Follow Us On',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: yellow)),
                    SizedBox(
                      height: height * 0.1,
                      width: width * 0.6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              _launchUrl(
                                  'https://www.linkedin.com/in/muneeza-muneer-70ab9627a/');
                            },
                            child: const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/image.png'),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _launchUrl(
                                  'https://instagram.com/call_me_munizay?utm_source=qr&igshid=MzNlNGNkZWQ4Mg%3D%3D');
                            },
                            child: const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/insta.jpeg')),
                          ),
                          InkWell(
                            onTap: () {
                              _launchUrl(
                                  'https://twitter.com/muneeza_muneer?t=y0YbVH-OpFAprKXC8Itp9A&s=09');
                            },
                            child: const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/twitter.png')),
                          ),
                          InkWell(
                            onTap: () {
                              _launchUrl(
                                  'https://www.facebook.com/muneeza.muneer.7');
                            },
                            child: const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/fb.png')),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }

  void showToast(BuildContext context, double height, double width) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Container(
            height: 40,
            width: double.infinity,
            color: boxColor.withOpacity(0.3),
            child: const Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: FittedBox(
                    child: Text(
                      'Success',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: FittedBox(child: Text('Message Sent Successfully')))
              ],
            )),
        behavior: SnackBarBehavior.floating,
        backgroundColor: boxColor,
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

Widget textField(double height, double width, String text, String textReq,
    bool isNumberType, TextEditingController controller, String hintText) {
  return SizedBox(
    height: height,
    width: width,
    child: TextFormField(
      controller: controller,
      autocorrect: true,
      cursorColor: whiteColor,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(color: whiteColor),
      decoration: InputDecoration(
          hintText: hintText,
          errorMaxLines: 2,
          errorStyle: const TextStyle(color: Colors.red, fontSize: 10),
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
          return textReq;
        }
        return null;
      },
      keyboardType: isNumberType ? TextInputType.phone : TextInputType.text,
    ),
  );
}
