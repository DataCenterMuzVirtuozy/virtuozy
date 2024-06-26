


  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/domain/entities/document_entity.dart';
import 'package:virtuozy/presentations/student/document_screen/bloc/docs_bloc.dart';
import 'package:virtuozy/presentations/student/document_screen/bloc/docs_event.dart';

import '../../../../resourses/colors.dart';
import '../../../../utils/text_style.dart';

class AcceptDocumentsContent extends StatefulWidget{
  const AcceptDocumentsContent({super.key, required this.docs});

  final List<DocumentEntity> docs;

  @override
  State<AcceptDocumentsContent> createState() => _AcceptDocumentsContentState();
}

class _AcceptDocumentsContentState extends State<AcceptDocumentsContent> {


  List<String> _names = [];
  @override
  void initState() {
    super.initState();

    _names = widget.docs.map((e) => e.name).toList();
  }



  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.check_box_outlined,color: Theme.of(context).textTheme.displayMedium!.color!,size: 40.0),
          const SizedBox(height: 15.0),
          Text('Подтвердить документ?'.tr(),
              textAlign:TextAlign.center,
              style:TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 18.0)),
          const SizedBox(height: 5.0),
          Text('Данное подтверждение означает ваше ознакомление и согласие с данными документами:'.tr(),
              textAlign:TextAlign.center,
              style:TStyle.textStyleVelaSansRegular(Theme.of(context).textTheme.displayMedium!.color!,size: 16.0)),
          Text(_names.toString().replaceFirst('[', '').replaceFirst(']', ''),
              textAlign:TextAlign.center,
              style:TStyle.textStyleVelaSansRegular(Theme.of(context).textTheme.displayMedium!.color!,size: 16.0)),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Отмена'.tr(),
                      textAlign: TextAlign.center,
                      style: TStyle.textStyleVelaSansBold(
                          Theme.of(context).textTheme.displayMedium!.color!,
                          size: 16.0))),
              const Gap(5.0),
              TextButton(
                onPressed: () {
                  context.read<DocsBloc>().add(const AcceptDocumentsEvent());
                  Navigator.pop(context);
                },
                child: Text('Подтвердить'.tr(),
                    textAlign: TextAlign.center,
                    style:
                    TStyle.textStyleVelaSansBold(colorRed,size: 16.0)),)
            ],
          )
        ],
      ),
    );

  }


}