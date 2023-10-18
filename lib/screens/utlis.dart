import 'package:divine/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: boxColor,
        textColor: whiteColor,
        fontSize: 16.0);
  }
}

Future<void> showAlertDialog(
  BuildContext context,
  String text,
  String text1,
) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: yellow,
        title: Center(
          child: Text(text,
              style: const TextStyle(
                  color: boxColor, fontWeight: FontWeight.bold, fontSize: 22)),
        ),
        content: Text(text1,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14)),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(backgroundColor: boxColor),
            child: const Text('Ok',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
