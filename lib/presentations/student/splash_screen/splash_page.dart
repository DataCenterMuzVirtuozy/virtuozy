





import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:virtuozy/resourses/images.dart';
import 'package:virtuozy/utils/theme_provider.dart';

import '../../../utils/preferences_util.dart';

class SplashPage extends StatefulWidget{
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  bool _darkTheme = false;
  final bool _msk = PreferencesUtil.branchUser == 'msk';

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Center(
         child: _darkTheme?Image.asset(logoDark,width: 150.0):
         SvgPicture.asset(_msk?logo:logoMainNsk,
             width: 150.0).animate().scale(
              curve: Curves.bounceOut,
              duration: const Duration(milliseconds: 1000))),
   );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _darkTheme = context.watch<ThemeProvider>().themeStatus == ThemeStatus.dark;

  }
}