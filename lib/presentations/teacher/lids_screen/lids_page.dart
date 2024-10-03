

  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/box_info.dart';
import 'package:virtuozy/domain/entities/client_entity.dart';
import 'package:virtuozy/domain/entities/lids_entity.dart';
import 'package:virtuozy/presentations/teacher/lids_screen/bloc/lids_bloc.dart';
import 'package:virtuozy/presentations/teacher/lids_screen/bloc/lids_event.dart';
import 'package:virtuozy/presentations/teacher/lids_screen/bloc/lids_state.dart';
import 'package:virtuozy/utils/auth_mixin.dart';
import 'package:virtuozy/utils/date_time_parser.dart';

import '../../../components/dialogs/dialoger.dart';
import '../../../components/dialogs/sealeds.dart';
import '../../../domain/entities/lesson_entity.dart';
import '../../../resourses/colors.dart';
import '../../../utils/status_to_color.dart';
import '../../../utils/text_style.dart';
import '../clients_screen/clients_page.dart';

class LidsPage extends StatefulWidget{
  const LidsPage({super.key});

  @override
  State<LidsPage> createState() => _LidsPageState();
}

class _LidsPageState extends State<LidsPage> with AuthMixin,TickerProviderStateMixin{


   List<ClientEntity> _myLidsResult = [];
  List<ClientEntity> _myLids = [];
  List<ClientEntity> _trialLids = [];
  List<ClientEntity> _allLids = [];
   List<ClientEntity> _puLidsResult = [];
   List<ClientEntity> _allLidsResult = [];
   late ScrollController _controller;
   late Animation<double> _animation;
   late AnimationController _controllerAnim;


  @override
  void initState() {
    super.initState();
    _controllerAnim = AnimationController(
      duration: const Duration(milliseconds:300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 60, end: 0).animate(_controllerAnim);
    super.initState();
    _controller = ScrollController();
    _controller.addListener(() {
      if (_controller.position.userScrollDirection == ScrollDirection.forward) {
        _controllerAnim.reverse();
      } else if (_controller.position.userScrollDirection ==
          ScrollDirection.reverse) {
        _controllerAnim.forward();
      }
    });
    context.read<LidsBloc>().add(GetListEvent(idTeacher: teacher.id));

  }

  @override
  void dispose() {
    _controllerAnim.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleSearchMyLids(String input) {
    _myLidsResult.clear();
    _puLidsResult.clear();
    _allLidsResult.clear();

    _puLidsResult = _trialLids.where((element) => element.name.toLowerCase().contains(input.toLowerCase())).toList();
     _allLidsResult = _allLids.where((element) => element.name.toLowerCase().contains(input.toLowerCase())).toList();
   _myLidsResult = _myLids.where((element) => element.name.toLowerCase().contains(input.toLowerCase())).toList();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LidsBloc,LidsState>(
        listener: (c,s){
          _myLids = s.lidsMy;
          _allLids = s.lids;
          _trialLids = s.lidsTrial;


          if(_myLidsResult.isEmpty){
            for(var e in _myLids){
              _myLidsResult.add(e);
            }

          }

          if(_allLidsResult.isEmpty){
            for(var e in _allLids){
              _allLidsResult.add(e);
            }

          }

          if(_puLidsResult.isEmpty){
            for(var e in _trialLids){
              _puLidsResult.add(e);
            }
          }
        },
        builder: (context,state) {

          if(state.status.isError){
            return Center(
              child: BoxInfo(title: 'Ошибка загрузки данных'.tr(), iconData: Icons.error),
            );
          }

          if(state.status.isLoading){
            return Center(
              child: CircularProgressIndicator(color: colorOrange),
            );
          }
          return DefaultTabController(
              length: 3,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (BuildContext context, Widget? child) {
                        return SizedBox(
                          height: _animation.value,
                          child: SearchClients(
                            open: _animation.value>40.0,
                            onChange: (d) {
                              setState(() {
                                _handleSearchMyLids(d);
                              });
                            },
                          ),
                        );
                      },

                    ),
                    TabBar(
                      isScrollable: true,
                      tabs: [
                        Text('Мои Лиды'.tr(),style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
                        Text('ПУ - Назначен'.tr(),style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
                        Text('Все'.tr(),style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: TabBarView(
                        children: [
                      ListView(
                        controller: _controller,
                        padding: const EdgeInsets.only(bottom: 90,top: 10),
                      children: [
                        if(_myLids.isEmpty)...{

                          Padding(
                            padding:  EdgeInsets.only(top:
                            MediaQuery.of(context).size.height/4),
                            child:                                   BoxInfo(
                                title: 'Список лидов пуст'.tr(),
                                iconData: Icons.list_rounded)
                            ,
                          )

                        }else...{
                          if(_myLidsResult.isNotEmpty)...{
                            ...List.generate(_myLidsResult.length, (index) {
                              return ItemMyLids(lid: _myLidsResult[index]);
                            })
                          }else...{
                            Padding(
                              padding:  EdgeInsets.only(top:
                              MediaQuery.of(context).size.height/4),
                              child:                                   BoxInfo(
                                  title: 'Нет подходящих результатов'.tr(),
                                  iconData: Icons.list_rounded)
                              ,
                            )
                          }

                        }



                      ],
                    ),
                    ListView(
                      controller: _controller,
                      padding: const EdgeInsets.only(bottom: 90,top: 10),
                      children: [
                        if(_trialLids.isEmpty)...{
                          Padding(
                            padding:  EdgeInsets.only(top:
                            MediaQuery.of(context).size.height/4),
                            child:                                   BoxInfo(
                                title: 'Список лидов пуст'.tr(),
                                iconData: Icons.list_rounded)
                            ,
                          )
                        }else...{

                          if(_puLidsResult.isNotEmpty)...{
                            ...List.generate(_puLidsResult.length, (index) {
                              return ItemTrialLids(lid: _puLidsResult[index]);
                            })
                          }else...{
                            Padding(
                              padding:  EdgeInsets.only(top:
                              MediaQuery.of(context).size.height/4),
                              child:                                   BoxInfo(
                                  title: 'Нет подходящих результатов'.tr(),
                                  iconData: Icons.list_rounded)
                              ,
                            )
                          }

                        }
                      ],
                    ),
                    ListView(
                      controller: _controller,
                      padding: const EdgeInsets.only(bottom: 90,top: 10),
                      children: [
                        if(_allLids.isEmpty)...{
                          Padding(
                            padding:  EdgeInsets.only(top:
                            MediaQuery.of(context).size.height/4),
                            child:                                   BoxInfo(
                                title: 'Список лидов пуст'.tr(),
                                iconData: Icons.list_rounded)
                            ,
                          )
                        }else...{

                          if(_allLidsResult.isNotEmpty)...{
                            ...List.generate(_allLidsResult.length, (index) {
                              return ItemLids(lid: _allLidsResult[index]);
                            })
                          }else...{
                            Padding(
                              padding:  EdgeInsets.only(top:
                              MediaQuery.of(context).size.height/4),
                              child:                                   BoxInfo(
                                  title: 'Нет подходящих результатов'.tr(),
                                  iconData: Icons.list_rounded)
                              ,
                            )
                          }

                        }

                      ],
                    )

                        ],

                      ),
                    ),
                  ],
                ),
              )


          );
        }
      ),
    );

  }
}

// class SearchClients extends StatelessWidget{
//   const SearchClients({super.key, required this.onChange});
//
//   final Function onChange;
//
//   @override
//   Widget build(BuildContext context) {
//    return           Padding(
//      padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 15),
//      child: TextField(
//        keyboardType: TextInputType.text,
//        textAlign: TextAlign.start,
//        onChanged: (d){
//          onChange.call(d);
//        },
//        style: TextStyle(
//            color: Theme.of(context).textTheme.displayMedium!.color!),
//        cursorColor: colorBeruza,
//        decoration: InputDecoration(
//            filled: true,
//            fillColor: Theme.of(context).colorScheme.background,
//            hintText: 'Поиск'.tr(),
//            //prefixIcon: const Icon(Icons.search),
//            hintStyle:
//            TStyle.textStyleVelaSansMedium(colorGrey.withOpacity(0.4),size: 16),
//            contentPadding: const EdgeInsets.only(
//                left: 20, right: 20, top: 12, bottom: 12),
//            enabledBorder: OutlineInputBorder(
//              borderRadius: BorderRadius.circular(10.0),
//              borderSide: BorderSide(
//                color: colorGrey,
//                width: 1.0,
//              ),
//            ),
//            focusedBorder: OutlineInputBorder(
//              borderRadius: BorderRadius.circular(10.0),
//              borderSide: BorderSide(
//                color: colorBeruza,
//                width: 1.0,
//              ),
//            )),
//      ),
//    );
//   }
//
// }

class ItemMyLids extends StatelessWidget{
  const ItemMyLids({super.key, required this.lid});

  final ClientEntity lid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap:(){
          Dialoger.showModalBottomMenu(
              title: lid.name,
              args: [lid,true],
              blurred: true,
              content: DetailsClient());

        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person,color: colorGreen,size: 18.0),
                    const Gap(3.0),
                    Text(lid.name,
                        style:TStyle.textStyleVelaSansBold(colorGrey,size: 16.0)),
                  ],
                ),
                Text(lid.nameDir,
                    style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context).textTheme.displayMedium!.color!,
                        size: 14.0))
              ],
            ),
            const Gap(8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Дата создания: ',
                    style:TStyle.textStyleOpenSansRegular(colorGrey,size: 12.0)),
                Text('${DateTimeParser.getDateFromApi(date: lid.dateCreate)}',
                    style:TStyle.textStyleVelaSansBold(colorGrey,size: 12.0)),
              ],
            ),
            const Gap(8),
            Divider(color: colorGrey),
          ],
        ),
      ),
    );

  }

}

  class ItemTrialLids extends StatelessWidget{
    const ItemTrialLids({super.key, required this.lid});
    final ClientEntity lid;
    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap:(){
            Dialoger.showModalBottomMenu(
                title: lid.name,
                args:   [lid,true],
                blurred: true,
                content: DetailsClient());
          },
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person,color: colorGreen,size: 18.0),
                      const Gap(3.0),
                      Text(lid.name,
                          style:TStyle.textStyleVelaSansBold(colorGrey,size: 16.0)),
                    ],
                  ),
                  const Gap(10),
                  Text(lid.nameDir,
                      style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context).textTheme.displayMedium!.color!,
                          size: 14.0))
                ],
              ),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Дата создания: ',
                      style:TStyle.textStyleOpenSansRegular(colorGrey,size: 12.0)),
                  Text('${DateTimeParser.getDateFromApi(date: lid.dateCreate)}',
                      style:TStyle.textStyleVelaSansBold(colorGrey,size: 12.0)),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Дата ПУ: ',
                      style:TStyle.textStyleOpenSansRegular(colorGrey,size: 12.0)),
                  Text('${DateTimeParser.getDateFromApi(date: lid.dateNearLesson)}/${lid.timeNearLesson}',
                      style:TStyle.textStyleVelaSansBold(colorGrey,size: 12.0)),
                ],
              ),
              const Gap(8),
              Divider(color: colorGrey),
            ],
          ),
        ),
      );

    }

  }

  class ItemLids extends StatelessWidget{
    const ItemLids({super.key, required this.lid});
    final ClientEntity lid;
    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap:(){
            Dialoger.showModalBottomMenu(
                title: lid.name,
                args: [lid,true],
                blurred: true,
                content: DetailsClient());
          },
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Icon(Icons.person,color: colorGreen,size: 18.0),
                      ),
                      const Gap(3.0),
                      SizedBox(
                        width: 210,
                        child: Text(lid.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:TStyle.textStyleVelaSansBold(colorGrey,size: 16.0)),
                      ),
                    ],
                  ),
                  const Gap(15),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: colorGreyLight
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                        child: Row(
                          children: [
                            Icon(Icons.location_on_outlined,size: 10,color:
                            Theme.of(context).textTheme.displayMedium!.color!),
                            const Gap(2),
                            Text(lid.idSchool,
                                style:TStyle.textStyleVelaSansMedium(Theme.of(context).textTheme.displayMedium!.color!,
                                    size: 10.0)),
                          ],
                        ),
                      ),
                      const Gap(10),
                      Text(lid.nameDir,
                          style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context).textTheme.displayMedium!.color!,
                              size: 14.0)),
                    ],
                  )
                ],
              ),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Дата создания: ',
                      style:TStyle.textStyleOpenSansRegular(colorGrey,size: 12.0)),
                  Text('${DateTimeParser.getDateFromApi(date: lid.dateCreate)}',
                      style:TStyle.textStyleVelaSansBold(colorGrey,size: 12.0)),
                ],
              ),
              Visibility(
                visible: lid.status == ClientStatus.trial,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Дата ПУ: ',
                        style:TStyle.textStyleOpenSansRegular(colorGrey,size: 12.0)),
                    Text('${DateTimeParser.getDateFromApi(date:
                   lid.dateNearLesson)}/${lid.timeNearLesson}',
                        style:TStyle.textStyleVelaSansBold(colorGrey,size: 12.0)),
                  ],
                ),
              ),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lid.dateLestLesson.isNotEmpty?'Дата последнего урока: ':'Дата ближ. урока: ',
                          style:TStyle.textStyleOpenSansRegular(colorGrey,size: 12.0)),
                      Text('${DateTimeParser.getDateFromApi(date: //todo time last lesson
                      lid.dateLestLesson.isNotEmpty?lid.dateLestLesson:lid.dateNearLesson)}/${lid.timeNearLesson}',
                          style:TStyle.textStyleVelaSansBold(textColorBlack(context),size: 12.0)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                    decoration:  BoxDecoration(
                        color:  Colors.amber, //todo color from status lesson
                        //StatusToColor.getColor(
                           // lesson: lid.),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color:  lid.dateLestLesson.isNotEmpty&&lid.statusLastLesson.isComplete||lid.statusLastLesson.isPlanned
                                ? textColorBlack(context)
                                : Colors.transparent)
                    ),
                    child: Text(
                        StatusToColor.getNameStatus(lid.dateLestLesson.isNotEmpty?lid.statusLastLesson:lid.statusNearLesson),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TStyle.textStyleVelaSansBold(Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .color!,
                            size: 10.0)),
                  )

                ],
              ),
              Divider(color: colorGrey),
            ],
          ),
        ),
      );

    }

  }