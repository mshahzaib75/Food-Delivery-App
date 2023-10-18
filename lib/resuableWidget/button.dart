import 'package:flutter/material.dart';

import '../colors.dart';

Widget clickButton(double height, double width,String text,  Function onTap) {
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
            style:
                const TextStyle(fontWeight: FontWeight.w900, color: Colors.white,fontSize: 16)),
      ),
    ),
  );
}
