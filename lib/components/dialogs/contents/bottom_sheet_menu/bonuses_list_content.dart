import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/utils/auth_mixin.dart';

import '../../../../domain/entities/user_entity.dart';
import '../../../../resourses/colors.dart';
import '../../../../router/paths.dart';
import '../../../../utils/text_style.dart';

class BonusesListContent extends StatefulWidget {
  const BonusesListContent({super.key, required this.bonuses});

  final List<BonusEntity> bonuses;

  @override
  State<BonusesListContent> createState() => _BonusesListContentState();
}

class _BonusesListContentState extends State<BonusesListContent>
    with AuthMixin {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...List.generate(widget.bonuses.length, (index) {
            return ItemBonus(
                bonus: widget.bonuses[index], directions: user.directions);
          })
        ],
      ),
    );
  }
}

class ItemBonus extends StatelessWidget {
  const ItemBonus({super.key, required this.bonus, required this.directions});

  final BonusEntity bonus;
  final List<DirectionLesson> directions;

  DirectionLesson _getDirectionByBonus(
      {required BonusEntity bonus, required List<DirectionLesson> directions}) {
    return directions
        .firstWhere((element) => element.name == bonus.nameDirection);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).push(pathDetailBonus, extra: [
          bonus,
          _getDirectionByBonus(bonus: bonus, directions: directions)
        ]);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Theme.of(context).colorScheme.surfaceVariant),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 47.0),
              child: Text(bonus.title,
                  style: TStyle.textStyleVelaSansExtraBolt(
                      Theme.of(context).textTheme.displayMedium!.color!,
                      size: 18.0)),
            ),
            const Gap(5.0),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      color: colorOrange.withOpacity(0.2),
                      shape: BoxShape.circle),
                  child: Icon(Icons.electric_bolt, color: colorOrange),
                ),
                const Gap(15.0),
                Expanded(
                    child: Text(bonus.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TStyle.textStyleVelaSansRegular(colorGrey,
                            size: 14.0))),
              ],
            ),
            const Gap(10.0),
            Align(
              alignment: Alignment.centerRight,
              child: Text('Подробнее...'.tr(),
                  style:
                      TStyle.textStyleVelaSansMedium(colorBeruza, size: 13.0)),
            )
          ],
        ),
      ),
    );
  }
}
