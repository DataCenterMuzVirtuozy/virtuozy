


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/utils/url_launch.dart';

import '../resourses/images.dart';

class TeacherContacts extends StatelessWidget{
  const TeacherContacts({super.key, required this.contacts});

  final List<dynamic> contacts;

  @override
  Widget build(BuildContext context) {
   return                  Row(

     mainAxisAlignment: MainAxisAlignment.end,
     children: [
       Visibility(
           visible: (contacts[0] as String).isNotEmpty,
           child: IconButton(
             icon: Icon(Icons.phone,color: colorOrange),
             onPressed: () async {
              await UrlLaunch.tel(tel: contacts[0]);
             },
           )),
       Visibility(
           visible:  (contacts[1] as String).isNotEmpty,
           child: IconButton(
             icon: Image.asset(whatsapp,width: 30,height: 30,),
             onPressed: () async {
              await UrlLaunch.url(contacts[1]);
             },
           )),
       Visibility(
           visible:  (contacts[2] as String).isNotEmpty,
           child: IconButton(
             icon: Image.asset(telegram,width: 25,height: 25,),
             onPressed: () async {
               await UrlLaunch.url(contacts[2]);
             },
           ))


     ],
   );

  }




}