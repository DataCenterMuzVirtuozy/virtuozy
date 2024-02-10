


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/components/box_info.dart';
import 'package:virtuozy/components/calendar.dart';
import 'package:virtuozy/components/dialogs/dialoger.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/presentations/subscription_screen/bloc/sub_bloc.dart';
import 'package:virtuozy/presentations/subscription_screen/bloc/sub_event.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/router/paths.dart';
import 'package:virtuozy/utils/auth_mixin.dart';

import '../../components/buttons.dart';
import '../../components/dialogs/sealeds.dart';
import '../../components/drawing_menu_selected.dart';
import '../../utils/text_style.dart';
import 'bloc/sub_state.dart';

class SubscriptionPage extends StatefulWidget{

  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage>{
  int _selIndexDirection = 0;

  List<String> _listDirection =  [];


  @override
  void initState() {
    super.initState();
    context.read<SubBloc>().add(GetUserEvent());
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  @override
  Widget build(BuildContext context) {



   return BlocConsumer<SubBloc,SubState>(
     listener: (c,s){

     },
     builder: (context,state) {

       _listDirection = state.userEntity.directions.map((e) => e.name).toList();

       if(state.userEntity.userStatus.isModeration || state.userEntity.userStatus.isModeration){
         return Center(
           child: BoxInfo(
               buttonVisible: state.userEntity.userStatus.isNotAuth,
               title: state.userEntity.userStatus.isModeration?'Ваш аккаунт на модерации'.tr():'Абонементы недоступны'.tr(),
               description: state.userEntity.userStatus.isModeration?'На период модерации работа с абонементами недоступна'.tr():
               'Для работы с абонементами необходимо авторизироваться'.tr(),
               iconData: CupertinoIcons.music_note_list),
         );
       }


       if(_listDirection.isEmpty){
         return Center(
           child: BoxInfo(
               buttonVisible:false,
               title: 'Список пуст'.tr(),
               description: 'У вас нет направлений обучения'.tr(),
               iconData: CupertinoIcons.music_note_list),
         );
       }


       return Padding(
         padding: const EdgeInsets.symmetric(horizontal: 20.0),
         child: SingleChildScrollView(
           child: Column(
             children: [
               //todo local
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
                 child: DrawingMenuSelected(items: _listDirection,
                   onSelected: (index){
                     setState(() {
                       _selIndexDirection = index;
                     });
                 },),
               ),
               const Gap(10.0),
                Calendar(lessons: state.userEntity.directions[_selIndexDirection].lessons),
               const Gap(10.0),
               Column(
                 children: List.generate(_listDirection.length, (index) {
                  return  ItemSubscription(direction: _selIndexDirection==3?'':
                  _listDirection[_selIndexDirection]);
                 }),
               ),
               const Gap(10.0),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
                 child: Column(
                   children: [
                     SizedBox(
                       height: 40.0,
                       child: SubmitButton(
                         onTap: (){
                           Dialoger.showBottomMenu(title:'Урок',context: context,
                           content: ConfirmLesson());
                         },
                         colorFill: Theme.of(context).colorScheme.tertiary,
                      borderRadius: 10.0,
                      textButton: 'Подтвердите прохождение урока'.tr(),
                       ),
                     ),
                     const Gap(10.0),
                     SizedBox(
                       height: 40.0,
                       child: OutLineButton(
                         onTap: (){

                         },
                         borderRadius: 10.0,
                         textButton: 'Получить бонусный урок'.tr(),
                       ),
                     ),
                   ],
                 ),
               )
             ],
           ),
         ),
       );
     }
   );
  }
}


 class ItemSubscription extends StatelessWidget{
  const ItemSubscription({super.key,
  required this.direction});

  final String direction;

  @override
  Widget build(BuildContext context) {
    return            Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(20.0),
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //todo local
          Text('Баланс абонемента'.tr(),
              style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context).textTheme.displayMedium!.color!,
              size: 18.0)),
          const Gap(5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //todo local
              Text('Вокал',style:TStyle.textStyleVelaSansMedium(colorGrey,size: 16.0)),
              Text('2 урока осталось',style:TStyle.textStyleVelaSansMedium(colorGrey,size: 14.0)),
            ],
          ),
          const Gap(5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle
                ),
                child: Icon(CupertinoIcons.money_rubl_circle,color: colorWhite,size: 25.0,),),
              const Gap(5.0),
              Row(
                children: [
                  Text('8999',style:TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 25.0)),
                  Icon(CupertinoIcons.money_rubl,color: Theme.of(context).iconTheme.color,size: 30.0,)
                ],
              ),
            ],
          ),
          const Gap(10.0),
          SizedBox(
            height: 40.0,
            child: SubmitButton(
              textButton: 'Пополнить'.tr(),
              onTap: () {
                GoRouter.of(context).push(pathPay,extra: direction);
              }
            ),
          )
        ],
      ),
    );

  }

 }

