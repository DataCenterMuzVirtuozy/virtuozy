

 import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:virtuozy/domain/entities/subway_entity.dart';

class EditProfileEntity{

   final File? fileImageUrl;
   final String sex;
   final String dateBirth;
   final bool hasKind;
   final String urlAva;
   final String aboutMe;
   final String whoFindTeem;
   final List<SubwayEntity> subways;

   const EditProfileEntity({
     required this.whoFindTeem,
     required this.aboutMe,
     required this.subways,
     required this.urlAva,
    required this.fileImageUrl,
    required this.sex,
    required this.dateBirth,
    required this.hasKind,
  });


   factory EditProfileEntity.unknown(){
     return const EditProfileEntity(fileImageUrl: null, sex: '', dateBirth: '', hasKind: false, urlAva: '', subways: [], aboutMe: '', whoFindTeem: '');
   }

  EditProfileEntity copyWith({
    File? fileImageUrl,
    String? sex,
    String? dateBirth,
    bool? hasKind,
    String? urlAva,
    List<SubwayEntity>? subways,
    String? aboutMe,
    String? whoFindTeem

  }) {
    return EditProfileEntity(
      whoFindTeem: whoFindTeem??this.whoFindTeem,
      aboutMe: aboutMe??this.aboutMe,
      subways: subways??this.subways,
      fileImageUrl: fileImageUrl ?? this.fileImageUrl,
      sex: sex ?? this.sex,
      dateBirth: dateBirth ?? this.dateBirth,
      hasKind: hasKind ?? this.hasKind,
      urlAva: urlAva??this.urlAva,
    );
  }
}