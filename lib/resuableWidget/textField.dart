import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../colors.dart';

Widget mobileTextField(double height, double width, String text,
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
          prefixIcon: const Icon(
            Icons.phone,
            color: yellow,
          ),
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

Widget emailTextField(double height, double width, String text,
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
          hintText: hintText,
          errorMaxLines: 2,
          prefixIcon: const Icon(Icons.email, color: yellow),
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
      validator: (email) {
        if (email != null && !EmailValidator.validate(email)) {
          return 'Enter a valid email';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
    ),
  );
}
