

 import 'package:equatable/equatable.dart';

class EventFinance extends Equatable{
  @override
  List<Object?> get props => [];

  const EventFinance();
}


class GetListSubscriptionsEvent extends EventFinance{
  final String nameDirection;

  const GetListSubscriptionsEvent({
    required this.nameDirection,
  });
}