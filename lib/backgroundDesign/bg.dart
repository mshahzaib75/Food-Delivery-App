import 'package:flutter/material.dart';
import '../colors.dart';

class BackGroundDesign extends StatelessWidget {
  const BackGroundDesign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
       return 
     Stack(
        children: [
    Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/background.jpeg'),
            fit: BoxFit.fill),
      ),
      child: DecoratedBox(decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.bottomLeft,end:Alignment.topRight,colors: [
          bg1Color.withOpacity(0.4),
          bg2Color.withOpacity(0.5),
  
        ])
      )),
    ),

        ],
    
    );
  }
}