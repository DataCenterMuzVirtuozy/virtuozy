


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/utils/url_launch.dart';

import '../resourses/images.dart';

class TeacherContacts extends StatelessWidget{
  const TeacherContacts({super.key, required this.contacts, required this.size});

  final List<dynamic> contacts;
  final double size;

  @override
  Widget build(BuildContext context) {

   return                  SizedBox(
     height: size,
     child: Row(

       mainAxisAlignment: MainAxisAlignment.end,
       children: [
         Visibility(
             visible: contacts.isNotEmpty&&(contacts[0] as String).isNotEmpty,
             child: InkWell(
               child: Icon(Icons.phone,color: colorOrange,size: size-5),
               onTap: () async {
                //await UrlLaunch.tel(tel: contacts[0]);
               },
             )),
         const Gap(5.0),
         Visibility(
             visible: contacts.length>1&&(contacts[1] as String).isNotEmpty,
             child: InkWell(
               child: Image.asset(whatsapp),
               onTap: () async {
                //await UrlLaunch.url('https://wa.clck.bar/${contacts[1]}');
               },
             )),
         const Gap(5.0),
         Visibility(
             visible: contacts.length>2&&  (contacts[2] as String).isNotEmpty,
             child: InkWell(
               child: Padding(
                 padding: const EdgeInsets.all(2.0),
                 child: Image.asset(telegram),
               ),
               onTap: () async {
                 //await UrlLaunch.url('https://t.me/${contacts[2]}');
               },
             ))


       ],
     ),
   );

  }




}