

  import 'package:virtuozy/domain/entities/subway_entity.dart';

class SubwayModel {


    final String name;
    final String color;


    const SubwayModel({
      required this.name,
      required this.color
    });

   static Map<String, dynamic> toMap({required SubwayEntity subwayEntity}) {
      return {
        'value': subwayEntity.name,
        'color': subwayEntity.color,
      };
    }


    factory SubwayModel.fromMap(Map<String, dynamic> map) {
      // String color = '';
      // if (map['color'] == null) {
      //   color = map['data']['color']??'';
      // } else {
      //   color = map['color'] as String;
      // }
      return SubwayModel(
        color: map['color']??'',
        name: map['value']??'',
      );
    }
  }
