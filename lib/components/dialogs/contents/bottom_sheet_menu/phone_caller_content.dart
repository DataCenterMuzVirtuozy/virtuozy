

  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../resourses/colors.dart';
import '../../../../resourses/images.dart';
import '../../../../utils/text_style.dart';

class PhoneCallerContent extends StatefulWidget{
  const PhoneCallerContent({super.key, required this.phone});

  final String phone;

  @override
  State<PhoneCallerContent> createState() => _PhoneCallerContentState();
}

class _PhoneCallerContentState extends State<PhoneCallerContent> {

  final List<String> _pathsIcon = [telegram, whatsapp];
  final List<String> _titles = ['Telegram','WhatsApp','Позвонить'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          ...List.generate(3, (index) {
                return InkWell(
                  onTap: () async {
                    await _launchUrl(
                        _getUrl(index, widget.phone));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        index==2?const Icon(Icons.phone):Image.asset(
                          _pathsIcon[index],
                          width: 30,
                          height: 30,
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
        ],
      ),
    );

  }

  String _getUrl( int index, String phone) {
    final p = phone.split('+')[1];
    print(p);
    if(index==0){
      return  'https://t.me//$p';
    }
   return '';
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}