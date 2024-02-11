


 import 'package:equatable/equatable.dart';




class SubEvent extends Equatable{
  @override

  List<Object?> get props => [];
  const SubEvent();

}

class GetUserEvent extends SubEvent{
  final int currentDirIndex;

  const GetUserEvent({required this.currentDirIndex});
}