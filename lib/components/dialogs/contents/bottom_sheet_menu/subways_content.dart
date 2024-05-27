import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/dialogs/dialoger.dart';
import 'package:virtuozy/presentations/student/profile_screen/bloc/profile_bloc.dart';
import 'package:virtuozy/presentations/student/profile_screen/bloc/profile_event.dart';
import 'package:virtuozy/presentations/student/profile_screen/bloc/profile_state.dart';
import 'package:virtuozy/utils/auth_mixin.dart';

import '../../../../resourses/colors.dart';
import '../../../../utils/text_style.dart';

class SubwaysContent extends StatefulWidget {
  const SubwaysContent({super.key});

  @override
  State<SubwaysContent> createState() => _SubwaysContentState();
}

class _SubwaysContentState extends State<SubwaysContent> with AuthMixin {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height - 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicWidth(
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: colorPink,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: colorOrange,
                      size: 16,
                    ),
                    const Gap(5),
                    Text(
                      user.branchName,
                      style:
                          TStyle.textStyleVelaSansBold(colorOrange, size: 16),
                    )
                  ],
                ),
              ),
            ),
            const Gap(20),
            SizedBox(
              height: 50,
              child: TextField(
                onChanged: (text) {
                  context.read<ProfileBloc>().add(GetSubwaysEvent(query: text));
                },
                //inputFormatters: [textInputFormatter],
                //readOnly: readOnly,
                maxLines: 1,
                //keyboardType: TextInputType.phone,
                textAlign: TextAlign.start,
                //controller: controller,
                style: TextStyle(
                    color: Theme.of(context).textTheme.displayMedium!.color!),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.background,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Icon(Icons.directions_subway, color: colorGrey),
                    ),
                    hintText: 'Введите станцию метро'.tr(),
                    hintStyle:
                        TStyle.textStyleVelaSansRegular(colorGrey, size: 14.0),
                    contentPadding: const EdgeInsets.only(
                        left: 20, right: 20, top: 15, bottom: 20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: colorPink,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: colorOrange,
                        width: 1.0,
                      ),
                    )),
              ),
            ),
            Expanded(
                child:
                    BlocConsumer<ProfileBloc, ProfileState>(listener: (c, s) {
              if (s.findSubwaysStatus == FindSubwaysStatus.error) {
                Dialoger.showMessage(s.error);
              }
            }, builder: (context, state) {
              if (state.findSubwaysStatus == FindSubwaysStatus.loading) {
                return Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Center(
                            child:
                                CircularProgressIndicator(color: colorOrange)),
                      ],
                    ));
              }

              if (state.subways.isEmpty) {
                return Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Center(
                            child: Text('Список станций пуст'.tr(),
                                style:
                                    TStyle.textStyleVelaSansMedium(colorGrey))),
                      ],
                    ));
              }

              return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  itemCount: state.subways.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          context.read<ProfileBloc>().add(
                              AddSubwayEvent(subway: state.subways[index]));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.subway,
                                color: textColorBlack(context), size: 17),
                            const Gap(10),
                            Expanded(
                              child: Text('ст. ${state.subways[index].name}',
                                  style: TStyle.textStyleVelaSansRegular(
                                      textColorBlack(context),
                                      size: 16)),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }))
          ],
        ),
      ),
    );
  }
}
