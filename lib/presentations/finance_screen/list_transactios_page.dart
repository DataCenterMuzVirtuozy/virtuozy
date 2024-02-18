



 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/box_info.dart';
import 'package:virtuozy/domain/entities/transaction_entity.dart';
import 'package:virtuozy/presentations/finance_screen/bloc/bloc_finance.dart';
import 'package:virtuozy/presentations/finance_screen/bloc/event_finance.dart';
import 'package:virtuozy/presentations/finance_screen/bloc/state_finance.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/utils/parser_price.dart';

import '../../components/app_bar.dart';
import '../../utils/text_style.dart';

class ListTransactionsPage extends StatefulWidget{
   const ListTransactionsPage({super.key});

  @override
  State<ListTransactionsPage> createState() => _ListTransactionsPageState();
}

class _ListTransactionsPageState extends State<ListTransactionsPage> {


  @override
  void initState() {
   super.initState();
   context.read<BlocFinance>().add(GetListTransactionsEvent());
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
           return ItemTransaction(type: state.transactions[i].typeTransaction,
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
     required this.quantity
      });

   final TypeTransaction type;
   final String time;
   final String quantity;

   @override
   Widget build(BuildContext context) {
     return Container(
       margin: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
       padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15.0),
       decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(15.0),
           color: colorBeruzaLight
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
                   Text(type == TypeTransaction.addBalance?
                       'Пополнение счета'.tr():
                         type == TypeTransaction.minusLesson?
                       'Списание за урок'.tr():'....',
                       style: TStyle.textStyleVelaSansBold(colorBlack,size: 14.0)),
                   Row(
                     children: [
                       Icon(Icons.timelapse_rounded,color: colorBeruza,size: 10.0),
                       const Gap(3.0),
                       Text(time,style: TStyle.textStyleVelaSansRegular(colorBeruza,size: 10.0)),
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
               Text(quantity,style: TStyle.textStyleVelaSansExtraBolt(colorBlack,size: 14.0)),
             ],
           )
         ],
       ),
     );

   }

 }