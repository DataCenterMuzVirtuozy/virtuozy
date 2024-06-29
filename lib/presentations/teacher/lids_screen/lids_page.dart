

  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class LidsPage extends StatefulWidget{
  const LidsPage({super.key});

  @override
  State<LidsPage> createState() => _LidsPageState();
}

class _LidsPageState extends State<LidsPage> with AuthMixin{


  final List<ClientEntity> _myLidsResult = [];
  List<ClientEntity> _myLids = [];
  List<ClientEntity> _trialLids = [];
  List<ClientEntity> _allLids = [];
  final List<ClientEntity> _puLidsResult = [];
  final List<ClientEntity> _allLidsResult = [];


  @override
  void initState() {
    super.initState();

    context.read<LidsBloc>().add(GetListEvent(idTeacher: teacher.id));

  }

  @override
  void dispose() {

    super.dispose();
  }

  void _handleSearchMyLids(String input) {
    _myLidsResult.clear();
    _puLidsResult.clear();
    _allLidsResult.clear();
    for (var str in _trialLids) {
      if (str.name.toLowerCase().contains(input.toLowerCase())) {
        setState(() {
          _puLidsResult.add(str);
        });
      }
    }
    for (var str in _allLids) {
      if (str.name.toLowerCase().contains(input.toLowerCase())) {
        setState(() {
          _allLidsResult.add(str);
        });
      }
    }
    for (var str in _myLids) {
      if (str.name.toLowerCase().contains(input.toLowerCase())) {
        setState(() {
          _myLidsResult.add(str);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LidsBloc,LidsState>(
        listener: (c,s){},
        builder: (context,state) {

           _myLids = state.lidsMy;
           _allLids = state.lids;
           _trialLids = state.lidsTrial;

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
                    SearchClients(
                      onChange: (d){
                          setState(() {
                            _handleSearchMyLids(d);
                          });
                      },
                    ),
                    TabBar(
                      //controller: _tabController,
                      isScrollable: true,
                      tabs: [
                        Text('Мои Лиды'.tr(),style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
                        Text('ПУ - Назначен'.tr(),style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
                        Text('Все'.tr(),style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height-200,
                        child: TabBarView(
                          children: [
                        ListView(
                        children: [
                          if(_myLidsResult.isEmpty)...{
                            ...List.generate(_myLids.length, (index) {
                              return ItemMyLids(lid: _myLids[index]);
                            })
                          }else...{
                            ...List.generate(_myLidsResult.length, (index) {
                              return ItemMyLids(lid: _myLidsResult[index]);
                            })
                          }



                        ],
                      ),
                      ListView(
                        children: [

                          if(_puLidsResult.isEmpty)...{
                            ...List.generate(_trialLids.length, (index) {
                              return ItemMyLids(lid: _trialLids[index]);
                            })
                          }else...{
                            ...List.generate(_puLidsResult.length, (index) {
                              return ItemTrialLids(lid: _puLidsResult[index]);
                            })
                          }
                        ],
                      ),
                      ListView(
                        children: [
                          if(_allLidsResult.isEmpty)...{
                            ...List.generate(_allLids.length, (index) {
                              return ItemMyLids(lid: _allLids[index]);
                            })
                          }else...{
                            ...List.generate(_allLidsResult.length, (index) {
                              return ItemLids(lid: _allLidsResult[index]);
                            })
                          }

                        ],
                      )

                          ],

                        ),
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

class SearchClients extends StatelessWidget{
  const SearchClients({super.key, required this.onChange});

  final Function onChange;

  @override
  Widget build(BuildContext context) {
   return           Padding(
     padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 15),
     child: TextField(
       keyboardType: TextInputType.text,
       textAlign: TextAlign.start,
       onChanged: (d){
         onChange.call(d);
       },
       style: TextStyle(
           color: Theme.of(context).textTheme.displayMedium!.color!),
       cursorColor: colorBeruza,
       decoration: InputDecoration(
           filled: true,
           fillColor: Theme.of(context).colorScheme.background,
           hintText: 'Поиск'.tr(),
           prefixIcon: const Icon(Icons.search),
           hintStyle:
           TStyle.textStyleVelaSansMedium(colorGrey.withOpacity(0.4),size: 16),
           contentPadding: const EdgeInsets.only(
               left: 20, right: 20, top: 12, bottom: 12),
           enabledBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(10.0),
             borderSide: BorderSide(
               color: colorGrey,
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
     ),
   );
  }

}

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
              args: lid,
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
                args: lid,
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
                args: lid,
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
                        color:  StatusToColor.getColor(
                            lessonStatus: lid.dateLestLesson.isNotEmpty?lid.statusLastLesson:lid.statusNearLesson),
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