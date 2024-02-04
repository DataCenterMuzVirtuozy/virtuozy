



 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:virtuozy/resourses/images.dart';

class SplashPage extends StatelessWidget{
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Center(
         child: SvgPicture.asset(logo, width: 150.0).animate().scale(
              curve: Curves.bounceOut,
              duration: const Duration(milliseconds: 1000))),
   );
  }

}