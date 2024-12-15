



import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/domain/user_cubit.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_bloc.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/utils/auth_mixin.dart';
import 'package:virtuozy/utils/preferences_util.dart';

import '../resourses/images.dart';
import '../utils/text_style.dart';
import '../utils/theme_provider.dart';

class TitlePage extends StatefulWidget{
  const TitlePage({super.key, required this.title});

  final String title;

  @override
  State<TitlePage> createState() => _TitlePageState();
}

class _TitlePageState extends State<TitlePage> with AuthMixin{

  bool _darkTheme = false;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _darkTheme = context.watch<ThemeProvider>().themeStatus == ThemeStatus.dark;

  }


  @override
  Widget build(BuildContext context) {




   return Row(
     mainAxisAlignment: MainAxisAlignment.end,
     children: [
       Container(
         decoration: BoxDecoration(
           //color: backgroundCard(context),
           borderRadius: BorderRadius.circular(10)
         ),
         child: Stack(
           children: [
             user.branchName == 'msk'?Image.asset(icLogoRec,
                 width: 25.0):SvgPicture.asset(logoNsk,width: 25,),
             Padding(
               padding: const EdgeInsets.only(left: 30),
               child: Text(widget.title,style: TStyle.textStyleGaretHeavy(textColorBlack(context),size: 18),),
             ),
           ],
         ),
       ),
     ],
   );
  }
}

