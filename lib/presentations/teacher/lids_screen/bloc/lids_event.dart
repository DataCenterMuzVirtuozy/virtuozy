

  import 'package:equatable/equatable.dart';

class LidsEvent extends Equatable{

  @override
  // TODO: implement props
  List<Object?> get props => [];

  const LidsEvent();
}


 class GetListEvent extends LidsEvent{
  final int idTeacher;

  const GetListEvent({required this.idTeacher});
}