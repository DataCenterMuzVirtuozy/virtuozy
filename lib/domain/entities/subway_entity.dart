

 class SubwayEntity{

   final String name;

   const SubwayEntity({
    required this.name,
  });

   factory SubwayEntity.unknown(){
     return const SubwayEntity(name: '');
   }
}