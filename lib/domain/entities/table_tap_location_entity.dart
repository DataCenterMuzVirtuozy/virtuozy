

 class TableTapLocation{

   final int y;
   final int x;

   TableTapLocation({required this.y, required this.x});


   factory TableTapLocation.unknown(){
     return TableTapLocation(y: 0, x: 0);
   }

   TableTapLocation copyWith(
   {
     int? y,
     int? x
 }
       ){

   return TableTapLocation(y: y??this.y, x: x??this.x);

   }
}