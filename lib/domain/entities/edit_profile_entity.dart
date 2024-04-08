

 import 'dart:io';

import 'package:flutter/foundation.dart';

class EditProfileEntity{

   final File? fileImageUrl;
   final String sex;
   final String dateBirth;
   final bool hasKind;
   final String urlAva;

   const EditProfileEntity({
     required this.urlAva,
    required this.fileImageUrl,
    required this.sex,
    required this.dateBirth,
    required this.hasKind,
  });


   factory EditProfileEntity.unknown(){
     return const EditProfileEntity(fileImageUrl: null, sex: '', dateBirth: '', hasKind: false, urlAva: '');
   }

  EditProfileEntity copyWith({
    File? fileImageUrl,
    String? sex,
    String? dateBirth,
    bool? hasKind,
    String? urlAva
  }) {
    return EditProfileEntity(
      fileImageUrl: fileImageUrl ?? this.fileImageUrl,
      sex: sex ?? this.sex,
      dateBirth: dateBirth ?? this.dateBirth,
      hasKind: hasKind ?? this.hasKind,
      urlAva: urlAva??this.urlAva,
    );
  }
}