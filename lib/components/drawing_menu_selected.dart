




import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:virtuozy/resourses/colors.dart';

import '../utils/text_style.dart';

class DrawingMenuSelected extends StatefulWidget{
  const DrawingMenuSelected({super.key,required this.items,
    required this.onSelected});


  final List<String> items;
  final Function onSelected;

  @override
  State<DrawingMenuSelected> createState() => _DrawingMenuSelectedState();
}

class _DrawingMenuSelectedState extends State<DrawingMenuSelected> with TickerProviderStateMixin{

  bool isDraw = false;
  late final AnimationController animationController;
  late final Animation<double> animationHeight;
  late final Animation<double> animationOpacity;
  late final Animation<double> animationBorder;
  late final ValueNotifier<String> changeTextNotifier;



  @override
  void initState() {
    super.initState();


  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    animationController=AnimationController(vsync: this,duration: const Duration(milliseconds: 300));
    animationHeight=Tween<double>(begin: 40.0,end:_heightCalculate(widget.items.length)).animate(animationController);
    animationOpacity=Tween<double>(begin: 0.0,end: 0.1).animate(animationController);
    animationBorder=Tween<double>(begin: 0.0,end: 1.0).animate(animationController);
    changeTextNotifier=ValueNotifier(widget.items[0]);

  }

  @override
  void dispose() {
    animationController.dispose();
    changeTextNotifier.dispose();
    super.dispose();
  }

  double _heightCalculate(int indexItems){
    return 58.0+(38*indexItems);
  }

  @override
  Widget build(BuildContext context) {
    return  Stack(
      alignment: Alignment.topCenter,
      children: [
        AnimatedBuilder(
            animation: animationHeight,
            builder: (_,child){
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: double.infinity,
                height: animationHeight.value,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: colorGrey.withOpacity(animationOpacity.value)
                ),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height:50.0),
                      ...List.generate(widget.items.length, (index){
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: GestureDetector(
                            onTap: (){
                              changeTextNotifier.value=widget.items[index];
                              widget.onSelected.call(index);
                              animationController.reverse();
                            },
                            child: Container(
                              color: Colors.transparent,
                              width: double.infinity,
                              height:30.0,
                              child: Row(
                                children: [
                                  Text(widget.items[index],style:
                                  TStyle.textStyleVelaSansMedium(colorBlack.withOpacity(0.5),size: 18.0)),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                ),


              );
            }),
        GestureDetector(
          onTap: (){
            if(isDraw){
              isDraw=false;
              animationController.reverse();
            }else{
              isDraw=true;
              animationController.forward();
            }

          },
          child: AnimatedBuilder(
              animation: animationOpacity,
              builder: (context,child) {
                return Container(
                    padding: const EdgeInsets.only(right: 26.0,
                        left:  26.0),
                    height: 50.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: colorBeruzaLight.withOpacity(animationOpacity.value),width: 1.5),
                        borderRadius: BorderRadius.circular(10.0),
                        color: colorBeruzaLight
                    ),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ValueListenableBuilder<String>(
                          builder: (context,value,child) {
                            return Text(value,
                                style:  TStyle.textStyleGaretHeavy(colorBlack,size: 18.0));
                          },
                          valueListenable: changeTextNotifier,
                        ),
                        RotatedBox(
                            quarterTurns: 1,
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: colorGrey,
                              size: 16.0,
                            )),
                      ],
                    ));
              }
          ),
        ),
      ],
    );
  }
}