



 import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/resourses/colors.dart';

import '../../../components/buttons.dart';
import '../../../utils/text_style.dart';

 class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

   @override
   _UserProfilePageState createState() => _UserProfilePageState();
 }

 class _UserProfilePageState extends State<UserProfilePage> {
   // User data variables
   String name = "";
   String gender = "";
   bool hasChildren = false;

   // Image picker for avatar
   //final ImagePicker _picker = ImagePicker();

   // Functions to pick and update avatar
   Future<void> _pickImage() async {
     // final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
     // if (pickedFile != null) {
     //   setState(() {
     //     // Update image path (replace with your image loading logic)
     //     // ...
     //   });
     //}
   }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       //appBar: AppBarCustom(title: 'Профиль'.tr(),),
       body: SingleChildScrollView(
         padding: const EdgeInsets.only(top: 40,right: 20,left: 20),
         child: Stack(
           alignment: Alignment.topCenter,
           children: [
             Align(
               alignment: Alignment.centerLeft,
               child: IconButton(onPressed: (){
                 Navigator.pop(context);
               },
                 icon: Icon(Platform.isAndroid?Icons.arrow_back_rounded:
                 Icons.arrow_back_ios_new_rounded),),
             ),
             const BodyInfoUser(),
             GestureDetector(
               onTap: _pickImage,
               child: Stack(
                 children: [
                   Container(
                     decoration: BoxDecoration(
                         shape: BoxShape.circle,
                         color: colorOrange
                     ),
                     padding: const EdgeInsets.all(2),
                     child: const CircleAvatar(
                       radius: 50.0,
                       backgroundImage: NetworkImage(
                         // Replace with your image URL or path
                         "https://www.kino-teatr.ru/acter/photo/0/8/57680/931617.jpg",
                       ),
                     ),
                   ),
                   Positioned(
                     bottom: 0,
                     right: 0,
                     child: Container(
                       padding: const EdgeInsets.all(5),
                       decoration: BoxDecoration(
                         shape: BoxShape.circle,
                         color: colorOrange
                       ),
                       child: Icon(Icons.edit,color: Theme.of(context).iconTheme.color,),
                     ),
                   ),
                 ],
               ),
             ),

           ],
         ),
       ),
     );
   }
 }


   class BodyInfoUser extends StatefulWidget{
  const BodyInfoUser({super.key});

  @override
  State<BodyInfoUser> createState() => _BodyInfoUserState();
}

class _BodyInfoUserState extends State<BodyInfoUser> {




  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return              Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 50),
          padding: const EdgeInsets.only(right: 20,left: 20,top: 70,bottom: 20),
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(20.0)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile picture with edit button
             Center(
               child: Text('Иванов Иван Иванович',
               textAlign: TextAlign.center,
               style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 18),),
             ),
               Center(child: Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 100),
                 child: Divider(color: colorGrey),
               )),
              const Gap(10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Пол:',style: TStyle.textStyleVelaSansMedium(colorGrey,size: 16),),
                  //todo если не указан то выбор через меню
                  Text('Мужской',
                    style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 18),),
                ],
              ),
              const Gap(10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Дата рождения:',style: TStyle.textStyleVelaSansMedium(colorGrey,size: 16),),
                  //todo если не указан то выбор через меню
                  Text('12.03.1989',
                    style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 18),),
                ],
              ),
              const Gap(10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Дата регистрации:',style: TStyle.textStyleVelaSansMedium(colorGrey,size: 16),),
                  Text('12.03.1989',
                    style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 18),),
                ],
              ),
              const Gap(10.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Наличие детей:',style: TStyle.textStyleVelaSansMedium(colorGrey,size: 16),),
                  const Gap(10.0),
                  const SelectKidsMenu()
                ],
              ),
              const Gap(20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ближайшая Станция метро - Работа',style: TStyle.textStyleVelaSansMedium(colorGrey,size: 16),),
                  Text('ст. Пушкинская',
                    style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 18),),
                ],
              ),
              const Gap(10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ближайшая Станция метро - Проживание',style: TStyle.textStyleVelaSansMedium(colorGrey,size: 16),),
                  Text('ст. Пушкинская',
                    style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 18),),
                ],
              ),
              const Gap(10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text('Кого ищу себе в группу (в напарники, в бенд)?',style: TStyle.textStyleVelaSansMedium(colorGrey,size: 16),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ищу вокалиста',
                        style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 18),),
                      Icon(Icons.edit,color: colorGrey,size: 16,)
                    ],
                  ),
                ],
              ),

              const Gap(30.0),
              SizedBox(
                height: 40.0,
                child: SubmitButton(
                    textButton: 'Сохранить изменения'.tr(),
                    onTap: () {

                    }
                ),
              )

            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Theme.of(context).colorScheme.surfaceVariant
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 47.0),
                child: Text('Внимание!',style: TStyle.textStyleVelaSansExtraBolt(Theme.of(context).textTheme.displayMedium!.color!,size: 18.0)),
              ),
              const Gap(5.0),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: colorOrange.withOpacity(0.2),
                        shape: BoxShape.circle
                    ),
                    child: Icon(Icons.electric_bolt,color: colorOrange),
                  ),
                  const Gap(15.0),
                  Expanded(child: Text('Заполни карточку целиком - получи БОНУСНЫЙ УРОК!',
                      style: TStyle.textStyleVelaSansRegular(colorGrey,size: 14.0))),
                ],
              ),

            ],
          ),
        )
      ],
    );
  }
}


 class SelectKidsMenu extends StatefulWidget{
   const SelectKidsMenu({super.key});

   @override
   State<SelectKidsMenu> createState() => _SelectKidsMenuState();
 }

 class _SelectKidsMenuState extends State<SelectKidsMenu> {

   final List<String> itemsKids = [
     'Да',
     'Нет',
   ];
   String? selectedValueKids;


   @override
   void initState() {
     super.initState();
     selectedValueKids = itemsKids[0];
   }

   @override
   Widget build(BuildContext context) {
     return DropdownButtonHideUnderline(
       child: DropdownButton2<String>(
         isExpanded: true,
         hint:  Text(selectedValueKids!,
             textAlign: TextAlign.center,
             style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context)
                 .textTheme.displayMedium!.color!,size: 13.0)),
         items: itemsKids
             .map((String item) => DropdownMenuItem<String>(
           value: item,
           child: Text(
             item,
             style: TStyle.textStyleVelaSansExtraBolt(Theme.of(context)
                 .textTheme.displayMedium!.color!,size: 13.0),
             overflow: TextOverflow.ellipsis,
           ),
         ))
             .toList(),
         value: selectedValueKids,
         onChanged: (value) {
           setState(() {
             selectedValueKids = value;
           });
         },
         buttonStyleData: ButtonStyleData(
           width: 75,
           padding:const EdgeInsets.symmetric(horizontal: 13.0),
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(20.0),
             color:Theme.of(context).colorScheme.surfaceVariant,
           ),
           //elevation: 2,
         ),
         iconStyleData:  IconStyleData(
           icon: const Icon(
             Icons.arrow_drop_down_rounded,
           ),
           iconSize: 18,
           iconEnabledColor: colorGrey,
           iconDisabledColor: Theme.of(context)
               .textTheme.displayMedium!.color!,
         ),
         dropdownStyleData: DropdownStyleData(
           maxHeight: 300,
           width: 75,
           elevation: 0,
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(20.0),
             color: colorGrey,
           ),
           offset: const Offset(0,-10),
           scrollbarTheme: ScrollbarThemeData(
             radius: const Radius.circular(40),
             thickness: MaterialStateProperty.all(6),
             thumbVisibility: MaterialStateProperty.all(true),
           ),
         ),
         menuItemStyleData: const MenuItemStyleData(
           height: 30,
           padding: EdgeInsets.only(left: 14, right: 14),
         ),
       ),
     );
   }
 }
