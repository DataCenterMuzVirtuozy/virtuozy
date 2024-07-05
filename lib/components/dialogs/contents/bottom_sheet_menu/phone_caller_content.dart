

  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../resourses/colors.dart';
import '../../../../resourses/images.dart';
import '../../../../utils/text_style.dart';
import '../../dialoger.dart';

class PhoneCallerContent extends StatefulWidget{
  const PhoneCallerContent({super.key, required this.phone});

  final String phone;

  @override
  State<PhoneCallerContent> createState() => _PhoneCallerContentState();
}

class _PhoneCallerContentState extends State<PhoneCallerContent> {

  final List<String> _pathsIcon = [whatsapp,telegram];
  final List<String> _titles = ['WhatsApp','Telegram','Позвонить'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          ...List.generate(3, (index) {
                return InkWell(
                  onTap: () async {
                    if(index==2){
                      await _launchUrlTel(tel: _getUrl(index,widget.phone));
                      return;
                    }
                    await _launchUrl(
                        _getUrl(index,widget.phone));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        index==2?const Icon(Icons.phone):Image.asset(
                          _pathsIcon[index],
                          width: index==0?30:25,
                          height:index==0?30:25,
                        ),
                        const Gap(10),
                        Expanded(
                          child: Text(
                            _titles[index],
                            style: TStyle.textStyleVelaSansBold(
                                textColorBlack(
                                  context,
                                ),
                                size: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
          const Gap(30)
        ],
      ),
    );

  }

  String _getUrl( int index, String phone) {
    final p = phone.split('+')[1];

    if(index==2){
      return phone;
    }

    if(index == 0){
      return  'https://wa.me/${phone}?call';
    }

    if(index==1){
      return  'https://t.me/$phone';
    }
   return '';
  }

  Future<void> _launchUrlTel({required String tel}) async {
    final Uri url = Uri(
        scheme:'tel',
        path: tel);
    if (!await launchUrl(url)) {
      Dialoger.showToast('Ошибка вызова'.tr());
    }
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}