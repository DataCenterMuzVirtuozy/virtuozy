

  import 'package:equatable/equatable.dart';


 enum LidsStatus{
   loading,
   loaded,
   error,
   unknown
 }

 extension LidsStatusExt on LidsStatus{
   bool get isLoading => this == LidsStatus.loading;
   bool get isLoaded => this == LidsStatus.loaded;
   bool get isError => this == LidsStatus.error;
   bool get iUnknown => this == LidsStatus.unknown;
 }

class LidsState extends Equatable{

  final String error;
  final LidsStatus status;


  const LidsState({required this.error, required this.status});
  factory LidsState.unknown(){
    return const LidsState(error: '', status: LidsStatus.unknown);
  }

  LidsState copyWith({String? error,LidsStatus? status}){
    return LidsState(error: error??this.error, status: status??this.status);
  }

  @override
  List<Object?> get props => [status,error];

}