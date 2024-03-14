



 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/box_info.dart';
import 'package:virtuozy/domain/entities/transaction_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';

import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/utils/date_time_parser.dart';
import 'package:virtuozy/utils/parser_price.dart';

import '../../../components/app_bar.dart';
import '../../../utils/text_style.dart';

import 'bloc/bloc_finance.dart';
import 'bloc/event_finance.dart';
import 'bloc/state_finance.dart';

class ListTransactionsPage extends StatefulWidget{
   const ListTransactionsPage({super.key, required this.directions});

   final List<DirectionLesson> directions;


  @override
  State<ListTransactionsPage> createState() => _ListTransactionsPageState();
}

class _ListTransactionsPageState extends State<ListTransactionsPage> {


  @override
  void initState() {
   super.initState();
   context.read<BlocFinance>().add(GetListTransactionsEvent(directions: widget.directions));
  }

  String _getNameDir(int idDir,List<DirectionLesson> directions){
    try{
      return directions.firstWhere((element) => element.id == idDir).name;
    }catch (e){
      return '';
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: 'Операции по счету'.tr()),
      body: BlocConsumer<BlocFinance,StateFinance>(
        listener: (c,s){

        },

        builder: (context,state) {

          if(state.listTransactionStatus == ListTransactionStatus.loading){
            return const Center(child: CircularProgressIndicator());
          }


          if(state.transactions.isEmpty){
            return  BoxInfo(title: 'У вас нет транзакций'.tr(),
                iconData: Icons.list_alt_sharp);
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            itemCount: state.transactions.length,
              itemBuilder: (c,i){
           return ItemTransaction(
             allView: widget.directions.length>1,
             nameDir: _getNameDir(state.transactions[i].idDir, widget.directions),
             date: DateTimeParser.getDateFromApi(date: state.transactions[i].date),
               type: state.transactions[i].typeTransaction,
               time: state.transactions[i].time,
               quantity: '${state.transactions[i].typeTransaction == TypeTransaction.minusLesson?'-':'+'}'
                   '${ParserPrice.getBalance(state.transactions[i].quantity)} руб.');
          });
        }
      ),
    );
  }


}

 class ItemTransaction extends StatelessWidget{
   const ItemTransaction({super.key,
     required this.type,
     required this.time,
     required this.quantity,
     required this.date,
     required this.nameDir,
     required this.allView
      });

   final TypeTransaction type;
   final String time;
   final String date;
   final String quantity;
   final String nameDir;
   final bool allView;

   @override
   Widget build(BuildContext context) {
     return Container(
       margin: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
       padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15.0),
       decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(15.0),
           color: Theme.of(context).colorScheme.surfaceVariant
       ),
       child: Column(
         children: [
           Row(
             children: [
               Container(
                 padding: const EdgeInsets.all(5.0),
                 decoration: BoxDecoration(
                     color: colorOrange.withOpacity(0.2),
                     shape: BoxShape.circle
                 ),
                 child: Icon(Icons.payment,color: colorOrange),
               ),
               const Gap(15.0),
               Expanded(child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text(type == TypeTransaction.addBalance?
                           'Пополнение счета'.tr():
                             type == TypeTransaction.minusLesson?
                           'Списание за урок'.tr():'....',
                           style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
                       Visibility(
                         visible: allView,
                         child: Text(nameDir,
                             style: TStyle.textStyleVelaSansExtraBolt(Theme.of(context)
                                 .textTheme.displayMedium!.color!,size: 14.0)),
                       )
                     ],
                   ),
                   Row(
                     children: [
                       Icon(Icons.timelapse_rounded,color: colorBeruza,size: 10.0),
                       const Gap(3.0),
                       Text('$date/$time',style: TStyle.textStyleVelaSansRegular(colorBeruza,size: 10.0)),
                     ],
                   ),
                 ],
               )),
             ],
           ),
           const Gap(10.0),
           Row(
             crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisAlignment: MainAxisAlignment.end,
             children: [
               Text(quantity,
                   style: TStyle.textStyleVelaSansExtraBolt(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
             ],
           )
         ],
       ),
     );

   }

 }