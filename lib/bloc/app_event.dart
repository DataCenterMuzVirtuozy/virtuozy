
part of 'app_bloc.dart';

 class AppEvent extends Equatable{

  @override
  List<Object?> get props => [];

  const AppEvent();
}

 class InitAppEvent extends AppEvent{}
class ObserveNetworkEvent extends AppEvent{}
class CheckNetworkEvent extends AppEvent{
 final StatusNetwork statusNetwork;
 const CheckNetworkEvent({required this.statusNetwork});
}


