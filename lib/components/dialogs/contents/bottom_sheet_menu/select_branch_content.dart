import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/router/paths.dart';
import 'package:virtuozy/utils/preferences_util.dart';

import '../../../../presentations/auth_screen/bloc/auth_bloc.dart';
import '../../../../presentations/auth_screen/bloc/auth_event.dart';
import '../../../../resourses/colors.dart';
import '../../../../utils/text_style.dart';
import '../../../buttons.dart';

class SelectBranchContent extends StatefulWidget {
  const SelectBranchContent({super.key});

  @override
  State<SelectBranchContent> createState() => _SelectBranchContentState();
}

class _SelectBranchContentState extends State<SelectBranchContent> {
  final List<String> _branchs = ['Москва', 'Новосибирск'];
  int selIndex = -1;



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          ...List.generate(2, (index) {
            return ItemBranch(
                branch: _branchs[index],
                onSelect: (value) {
                  setState(() {
                    selIndex = value;

                  });
                },
                index: index,
                selected: index == selIndex);
          }),
          const Gap(10.0),
          Visibility(
            visible: selIndex > -1,
            child: OutLineButton(
              onTap: () {
                context
                    .read<AuthBloc>()
                    .add(CompleteSinIgEvent(branch: _branchs[selIndex]));
                GoRouter.of(context).pushReplacement(pathSuccessSendSMS);
              },
              textButton: 'Завершить регистрацию'.tr(),
            ).animate().fadeIn(),
          ),
        ],
      ),
    );
  }
}

class ItemBranch extends StatelessWidget {
  const ItemBranch(
      {super.key,
      required this.branch,
      required this.onSelect,
      required this.index,
      required this.selected});

  final String branch;
  final Function onSelect;
  final int index;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onSelect.call(index);
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: colorOrange.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(Icons.location_on_outlined, color: colorOrange),
          ),
          const Gap(15.0),
          Expanded(
              child: Text(branch,
                  style: TStyle.textStyleVelaSansBold(
                      Theme.of(context).textTheme.displayMedium!.color!,
                      size: 14.0))),
          Checkbox(
              activeColor: colorPink,
              value: selected,
              onChanged: (sel) {
                onSelect.call(index);
              })
        ],
      ),
    );
  }
}
