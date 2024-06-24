

  import 'package:equatable/equatable.dart';
import 'package:virtuozy/domain/entities/client_entity.dart';

import '../../../../domain/entities/lids_entity.dart';


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
  final List<ClientEntity> lids;
  final List<ClientEntity> lidsMy;
  final List<ClientEntity> lidsTrial;

  const LidsState( {required this.error, required this.status,required this.lids,required this.lidsMy,required this.lidsTrial});
  factory LidsState.unknown(){
    return const LidsState(error: '', status: LidsStatus.unknown,lids: [],lidsMy: [],lidsTrial: []);
  }

  LidsState copyWith({String? error,LidsStatus? status,List<ClientEntity>? lids,
  List<ClientEntity>? lidsMy,
  List<ClientEntity>? lidsTrial}){
    return LidsState(error: error??this.error, status: status??this.status,lids: lids??this.lids,
    lidsTrial: lidsTrial??this.lidsTrial,
    lidsMy: lidsMy??this.lidsMy);
  }

  @override
  List<Object?> get props => [status,error,lids,lidsMy,lidsTrial];

}