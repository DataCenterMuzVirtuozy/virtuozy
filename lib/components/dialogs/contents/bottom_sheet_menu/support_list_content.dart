import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/utils/auth_mixin.dart';
import 'package:virtuozy/utils/text_style.dart';

import '../../../../resourses/images.dart';
import '../../../../resourses/strings.dart';

enum TypeMessager { telegram, whatsapp }

class SupportListContent extends StatefulWidget {
  const SupportListContent({super.key, required this.typeMessager});

  final TypeMessager typeMessager;

  @override
  State<SupportListContent> createState() => _SupportListContentState();
}

class _SupportListContentState extends State<SupportListContent>
    with AuthMixin {
  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  final List<String> _pathsIcon = [telegram, whatsapp];

  String _getUrl(TypeMessager typeMessager, int index, String idFilial) {
    if (idFilial == 'Москва') {
      if (TypeMessager.telegram == typeMessager) {
        return listSupportUrlTelegramMSK[index];
      } else {
        return listSupportUrlWhatsappMSK[index];
      }
    } else {
      if (TypeMessager.telegram == typeMessager) {
        return listSupportUrlTelegramNSK[index];
      } else {
        return listSupportUrlWhatsappNSK[index];
      }
    }
  }

  String _getTitle(TypeMessager typeMessager, int index, String idFilial) {
    if (idFilial == 'msk') {
      if (TypeMessager.telegram == typeMessager) {
        return listSupportTelegramMSK[index];
      } else {
        return listSupportWhatsappMSK[index];
      }
    } else {
      if (TypeMessager.telegram == typeMessager) {
        return listSupportUrlTelegramNSK[index];
      } else {
        return listSupportWhatsappNSK[index];
      }
    }
  }

  int _getLength(TypeMessager typeMessager, String idFilial) {
    if (idFilial == 'msk') {
      if (TypeMessager.telegram == typeMessager) {
        return listSupportTelegramMSK.length;
      } else {
        return listSupportWhatsappMSK.length;
      }
    } else {
      if (TypeMessager.telegram == typeMessager) {
        return listSupportTelegramNSK.length;
      } else {
        return listSupportWhatsappNSK.length;
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          ...List.generate(_getLength(widget.typeMessager, user.branchName),
              (index) {
            return InkWell(
              onTap: () async {
                await _launchUrl(
                    _getUrl(widget.typeMessager, index, user.branchName));
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      _pathsIcon[
                          widget.typeMessager == TypeMessager.telegram ? 0 : 1],
                      width: 40,
                      height: 40,
                    ),
                    const Gap(10),
                    Expanded(
                      child: Text(
                        _getTitle(widget.typeMessager, index, user.branchName),
                        style: TStyle.textStyleVelaSansBold(
                            textColorBlack(
                              context,
                            ),
                            size: 16),
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
}
