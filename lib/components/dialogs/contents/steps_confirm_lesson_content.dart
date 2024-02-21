


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/presentations/subscription_screen/bloc/sub_bloc.dart';
import 'package:virtuozy/presentations/subscription_screen/bloc/sub_event.dart';
import 'package:virtuozy/presentations/subscription_screen/bloc/sub_state.dart';

import '../../../di/locator.dart';
import '../../../resourses/colors.dart';
import '../../../utils/text_style.dart';
import '../../buttons.dart';

final currentDayNotifi = locator.get<ValueNotifier<int>>();

class StepsConfirmLesson extends StatefulWidget{
  const StepsConfirmLesson({super.key, required this.lesson,
    required this.directions, required this.listNotAcceptLesson,
  required this.allViewDirection});

  final Lesson lesson;
  final List<DirectionLesson> directions;
  final List<Lesson> listNotAcceptLesson;
  final bool allViewDirection;


  @override
  State<StepsConfirmLesson> createState() => _StepsConfirmLessonState();
}

class _StepsConfirmLessonState extends State<StepsConfirmLesson> {

  final List<double> _heightBody = [270.0,180.0,270.0,300.0];
  late PageController _pageController;
  late TextEditingController _editingControllerReview;
  double _rating=  5.0;
  int _stepIndex = 0;
  late Lesson _lesson;



  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _editingControllerReview = TextEditingController();
    _lesson = widget.lesson;
    if(widget.listNotAcceptLesson.length>1){
      _heightBody.insert(0, 250.0);
    }
  }


  @override
  void dispose() {
    super.dispose();
    _editingControllerReview.dispose();
    _pageController.dispose();
  }


  DirectionLesson _getDirectionByLesson({required Lesson lessonEntity}){
    return widget.directions.firstWhere((element) => element.name == lessonEntity.nameDirection);
  }

  @override
  Widget build(BuildContext context) {

        return AnimatedContainer(
          height: _heightBody[_stepIndex],
          duration: const Duration(milliseconds: 700),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: [
                    if(widget.listNotAcceptLesson.length>1)...{
                      step_0(lessonsNotAccept: widget.listNotAcceptLesson,
                      next: (l){
                        _pageController.animateToPage(1, duration: const Duration(milliseconds: 700), curve: Curves.ease);
                        setState(() {
                           _lesson = l;
                          _stepIndex = 1;
                        });
                      })
                    },
                    step_1(
                        next: (){
                      _pageController.animateToPage(widget.listNotAcceptLesson.length==1?1:2,
                          duration: const Duration(milliseconds: 700), curve: Curves.ease);
                      setState(() {
                        _stepIndex = widget.listNotAcceptLesson.length==1?1:2;
                      });
                    }, lesson: _lesson,
                        direction: _getDirectionByLesson(lessonEntity: _lesson),
                        context: context),
                    step_2(negative: (value){
                      setState(() {
                        if(value){
                          _rating = -1;
                          _stepIndex = widget.listNotAcceptLesson.length==1?3:4;
                          _pageController.jumpToPage(_stepIndex);
                        }else{
                          _stepIndex = widget.listNotAcceptLesson.length==1?2:3;
                          _pageController.animateToPage(_stepIndex,
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.ease);
                        }

                      });
                    }),
                    step_3(next: (){
                      if(_rating<=2.0&&_rating>0.0){
                        setState(() {
                          _stepIndex = widget.listNotAcceptLesson.length==1?3:4;
                          _pageController.animateToPage(_stepIndex,
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.ease);
                        });

                      }else{
                        currentDayNotifi.value = 0;
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


  Widget step_0({required List<Lesson> lessonsNotAccept,required Function next,}){

    return SingleChildScrollView(
      child: Column(
         children: [
           ...List.generate(widget.listNotAcceptLesson.length, (index) {
             return ItemNotAcceptLesson(
               allViewDirection: widget.allViewDirection,
               lesson: widget.listNotAcceptLesson[index],
               next: (lesson) {
                 next.call(lesson);
             },);
           })
         ],
      ),
    );
  }




  Widget step_1({required VoidCallback next,
    required BuildContext context,
    required Lesson lesson,
    required DirectionLesson direction}) => SingleChildScrollView(
    child: Column(
          children: [
        Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month, color: Theme.of(context).textTheme.displayMedium!.color!, size: 15.0),
                    const Gap(5.0),
                    Text(lesson.date,
                        style: TStyle.textStyleVelaSansMedium(
                            Theme.of(context).textTheme.displayMedium!.color!, size: 16.0)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.timelapse_rounded, color: Theme.of(context).textTheme.displayMedium!.color!, size: 15.0),
                    const Gap(5.0),
                    Text(lesson.timePeriod,
                        style: TStyle.textStyleVelaSansMedium(
                            Theme.of(context).textTheme.displayMedium!.color!, size: 16.0)),
                  ],
                ),
              ],
            ),
            const Gap(10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Кабинет №',
                    style: TStyle.textStyleVelaSansMedium(colorGrey, size: 16.0)),
                Text('${lesson.idAuditory}',
                    style: TStyle.textStyleVelaSansMedium(colorGrey, size: 16.0)),
              ],
            ),
            const Gap(10.0),
            Text(lesson.nameTeacher,
                style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!, size: 18.0)),
            const Gap(10.0),
            Text(direction.name,
                style: TStyle.textStyleVelaSansMedium(colorGrey, size: 16.0)),
            const Gap(20.0),
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
    child: BlocConsumer<SubBloc,SubState>(
      listener: (c,s){
        if(s.subStatus == SubStatus.confirm){
          negative.call(false);
        }
      },
      builder: (context,state) {

        if(state.subStatus == SubStatus.confirmation){
          return  Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Center(child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(strokeWidth: 1.5),
                const Gap(20.0),
                Text('Подтверждаем урок...'.tr(),style: TStyle.textStyleVelaSansRegular(colorOrange),),
              ],
            )),
          );
        }
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius:  BorderRadius.circular(10.0)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Урок состоялся?'.tr(),
                      style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 20.0)),
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
                            context.read<SubBloc>().add(AcceptLessonEvent(direction: _getDirectionByLesson(lessonEntity: _lesson),
                                lesson: _lesson));
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
        );
      }
    ),
  );

  Widget step_3({required VoidCallback next}) => SingleChildScrollView(
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius:  BorderRadius.circular(10.0)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Спасибо, что подтвердили урок!'.tr(),
                  style: TStyle.textStyleVelaSansMedium(Theme.of(context).textTheme.displayMedium!.color!,size: 18.0)),
              const Gap(10.0),
              Text('Оцените, как прошло занятие'.tr(),
                  style: TStyle.textStyleVelaSansMedium(colorGrey,size: 16.0)),
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
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius:  BorderRadius.circular(10.0)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(_rating<2.0&&_rating>0.0?'Сожалеем, что урок вам \nне понравился'.tr():
              'Расскажите о причине, по которой урок не состоялся'.tr(),
                  textAlign: TextAlign.center,
                  style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 18.0)),
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
                style: TextStyle(color: Theme.of(context).textTheme.displayMedium!.color!),
                cursorColor: colorBeruza,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.background,
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
              currentDayNotifi.value = 0;
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


class ItemNotAcceptLesson extends StatefulWidget{
  const ItemNotAcceptLesson(
      {super.key,
      required this.lesson,
      required this.next,
        required this.allViewDirection
      });

  final Lesson lesson;
  final Function next;
  final bool allViewDirection;

  @override
  State<ItemNotAcceptLesson> createState() => _ItemNotAcceptLessonState();
}

class _ItemNotAcceptLessonState extends State<ItemNotAcceptLesson> {


  final currentDayNotifi = locator.get<ValueNotifier<int>>();

  @override
  Widget build(BuildContext context) {
   return Container(
     margin:  const EdgeInsets.only(right: 10.0,left: 10.0,bottom: 10.0),
     padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
     decoration: BoxDecoration(
       color: Theme.of(context).colorScheme.surfaceVariant,
       borderRadius: BorderRadius.circular(10.0)
     ),
     child: Row(
       crossAxisAlignment: CrossAxisAlignment.center,
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
         Row(
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             Container(
               width: 8.0,
               height: 8.0,
               decoration: BoxDecoration(
                   shape: BoxShape.circle,
                   color: colorGreen
               ),
             ),
             const Gap(10.0),
             Column(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   children: [
                     Text(widget.lesson.date,
                         style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 16.0)),
                     Visibility(
                         visible: widget.allViewDirection,
                         child: Text(' - ${widget.lesson.nameDirection}',
                             style: TStyle.textStyleVelaSansRegular(colorGrey,size: 12.0))),
                   ],
                 ),
                 Text(widget.lesson.timePeriod,style: TStyle.textStyleVelaSansRegular(colorGrey,size: 12.0)),

               ],
             ),
           ],
         ),
         IconButton(
           onPressed: (){
             currentDayNotifi.value = _getIntCurrentDay(widget.lesson.date);
             widget.next.call(widget.lesson);

           },
           icon: Icon(Icons.navigate_next_rounded,
               color: colorOrange,size: 30.0),
         ),
       ],
     ),
   );
  }

  int _getIntCurrentDay(String date){
    return DateFormat('yyyy-MM-dd').parse(date).day;
  }
}


