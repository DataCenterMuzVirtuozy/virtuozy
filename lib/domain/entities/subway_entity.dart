

 class SubwayEntity{

   final String name;
   final String color;


   const SubwayEntity({
     required this.color,
    required this.name,
  });

   factory SubwayEntity.unknown(){
     return const SubwayEntity(name: '',color: '');
   }
}