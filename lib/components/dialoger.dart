


 import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/components/text_fields.dart';
import 'package:virtuozy/resourses/colors.dart';

import '../utils/text_style.dart';
import 'buttons.dart';


 sealed class DialogsContent{}


 class ConfirmLesson extends DialogsContent{
   static build({required BuildContext context}){
     return const StepsConfirmLesson();
   }
 }




class Dialoger{

   static void showActionMaterialSnackBar(
       {required VoidCallback onAction,
         required BuildContext context,
         required String title,
         String textAction = 'OK'}) {
     ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           backgroundColor: colorWhite,
           behavior: SnackBarBehavior.floating,
           content: Text(
             title,
             style: TStyle.textStyleVelaSansRegular(colorOrange)
           ),
           action: SnackBarAction(
             textColor: colorOrange,
             label: textAction,
             onPressed: () {
               onAction.call();
             },
           ),
         ));
   }

   static void showMessage(String message) {
     Fluttertoast.showToast(
       msg: message,
       textColor: colorBlack,
       backgroundColor: colorWhite,
       fontSize: 14.0,
       gravity: ToastGravity.CENTER,
     );
   }

   static void showBottomMenu({required BuildContext context,required DialogsContent content}){

     final body = switch(content){
       ConfirmLesson()=>ConfirmLesson.build(context: context)
     };

     showBottomSheet(
         enableDrag: false,
         backgroundColor: Colors.transparent,
         context: context, builder: (_){
       return  BackdropFilter(
         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 5),
         child: Container(
           padding: const EdgeInsets.only(
                  right: 10.0,
                  left: 10.0,
                  top: 10.0),
              decoration: BoxDecoration(
         color: colorWhite,
         borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
         ),
           child: body,
         ),
       );
     });
   }




}





  class StepsConfirmLesson extends StatefulWidget{
  const StepsConfirmLesson({super.key});

  @override
  State<StepsConfirmLesson> createState() => _StepsConfirmLessonState();
}

class _StepsConfirmLessonState extends State<StepsConfirmLesson> {

  final List<double> _heightBody = [270.0,180.0,270.0,350.0];
  late PageController _pageController;
  late TextEditingController _editingControllerReview;
  double _rating=  5.0;
  int _stepIndex = 0;


  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _editingControllerReview = TextEditingController();
  }


  @override
  void dispose() {
    super.dispose();
    _editingControllerReview.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return AnimatedContainer(
      height: _heightBody[_stepIndex],
      duration: const Duration(milliseconds: 700),
      child: Column(
        children: [
          Container(
            height: 45.0,
            padding: const EdgeInsets.only(top: 5.0,right: 15.0,left: 20.0),
            decoration: BoxDecoration(
                color: colorGreenLight,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(20.0),topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(10.0),bottomRight: Radius.circular(10.0))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Урок',style: TStyle.textStyleGaretHeavy(colorWhite,size: 18.0),),
                InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close_rounded,color: colorWhite)),

              ],
            ),
          ),
          const Gap(10.0),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                step_1(next: (){
                  _pageController.animateToPage(1, duration: const Duration(milliseconds: 700), curve: Curves.ease);
                  setState(() {
                    _stepIndex = 1;
                  });
                }),
                step_2(negative: (value){
                  setState(() {
                    if(value){
                      _rating = -1;
                      _stepIndex = 3;
                      _pageController.jumpToPage(_stepIndex);
                    }else{
                      _stepIndex = 2;
                      _pageController.animateToPage(_stepIndex,
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.ease);
                    }

                  });
                }),
                step_3(next: (){
                  if(_rating<=2.0&&_rating>0.0){
                    setState(() {
                      _stepIndex = 3;
                      _pageController.animateToPage(_stepIndex,
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.ease);
                    });

                  }else{
                    Navigator.pop(context);
                    //todo send reviews
                  }

                }),
                step_4()
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget step_1({required VoidCallback next}) => SingleChildScrollView(
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          width: double.infinity,
          decoration: BoxDecoration(
              color: colorBeruzaLight,
              borderRadius:  BorderRadius.circular(10.0)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Среда, 1 ноября, 10:00 - 10:55',style: TStyle.textStyleVelaSansMedium(colorBlack,size: 18.0)),
              const Gap(10.0),
              Text('Кабинет №2338',style: TStyle.textStyleVelaSansMedium(colorGrey,size: 16.0)),
              const Gap(10.0),
              Text('Иванов Иван Иванович',style: TStyle.textStyleVelaSansMedium(colorGrey,size: 16.0)),
              const Gap(10.0),
              Text('Вокал',style: TStyle.textStyleVelaSansMedium(colorGrey,size: 16.0)),
            ],
          ),
        ),

        const Gap(10.0),
        SizedBox(
          height: 40.0,
          child: SubmitButton(
            onTap: (){
              next.call();
            },
            borderRadius: 10.0,
            textButton: 'Подтвердить урок'.tr(),
          ),
        )

      ],
    ),
  );
  Widget step_2({required Function negative}) => SingleChildScrollView(
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          width: double.infinity,
          decoration: BoxDecoration(
              color: colorBeruzaLight,
              borderRadius:  BorderRadius.circular(10.0)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Урок состоялся?'.tr(),
                  style: TStyle.textStyleVelaSansBold(colorBlack,size: 20.0)),
              const Gap(20.0),
              SizedBox(
                height: 30.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SubmitButton(
                      width: 100.0,
                      onTap: (){
                         negative.call(true);
                      },
                      textButton: 'Нет'.tr(),
                    ),
                    const Gap(10.0),
                    SubmitButton(
                      width: 100.0,
                      onTap: (){
                         negative.call(false);
                      },
                      textButton: 'Да'.tr(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),

      ],
    ),
  );

  Widget step_3({required VoidCallback next}) => SingleChildScrollView(
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          width: double.infinity,
          decoration: BoxDecoration(
              color: colorBeruzaLight,
              borderRadius:  BorderRadius.circular(10.0)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Спасибо, что подтвердили урок!'.tr(),style: TStyle.textStyleVelaSansMedium(colorBlack,size: 18.0)),
              const Gap(10.0),
              Text('Оцените, как прошло занятие'.tr(),style: TStyle.textStyleVelaSansMedium(colorGrey,size: 16.0)),
              const Gap(20.0),
              RatingBar.builder(
                initialRating: 5,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding:const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: colorYellow,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });


                },
              ),
            ],
          ),
        ),

        const Gap(10.0),
        SizedBox(
          height: 40.0,
          child: SubmitButton(
            onTap: (){
              next.call();
            },
            borderRadius: 10.0,
            textButton: 'Отправить отзыв'.tr(),
          ),
        )

      ],
    ),
  );


  Widget step_4() => SingleChildScrollView(
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
          width: double.infinity,
          decoration: BoxDecoration(
              color: colorBeruzaLight,
              borderRadius:  BorderRadius.circular(10.0)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(_rating<2.0&&_rating>0.0?'Сожалеем, что урок вам \nне понравился'.tr():
              'Расскажите о причине, по которой урок не состоялся'.tr(),
                  textAlign: TextAlign.center,
                  style: TStyle.textStyleVelaSansBold(colorBlack,size: 18.0)),
              const Gap(10.0),
              Visibility(
                visible: _rating<2.0&&_rating>0.0,
                  child: Text('Расскажите, что пошло не так'.tr(),
                      style: TStyle.textStyleVelaSansMedium(colorGrey,size: 16.0))),
              const Gap(20.0),
              TextField(
                maxLines: 3,
                textAlign: TextAlign.start,
                controller: _editingControllerReview,
                style: TextStyle(color: colorBlack),
                cursorColor: colorBeruza,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: colorWhite,
                    hintText: 'Ваш комментарий'.tr(),
                    hintStyle: TStyle.textStyleVelaSansMedium(colorGrey.withOpacity(0.4)),
                    contentPadding:const EdgeInsets.only(left: 20,right: 20,top: 12,bottom: 12),
                    enabledBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: colorBeruzaLight,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: colorBeruza,
                        width: 1.0,
                      ),
                    )),
              )

            ],
          ),
        ),

            const Gap(10.0),
        SizedBox(
          height: 40.0,
          child: SubmitButton(
            onTap: (){
              Navigator.pop(context);
              //todo send rewiev
            },
            borderRadius: 10.0,
            textButton: 'Отправить комментарий'.tr(),
          ),
        )

      ],
    ),
  );



}


