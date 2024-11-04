




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:virtuozy/resourses/colors.dart';

import '../utils/text_style.dart';

class DrawingMenuSelected extends StatefulWidget{
  const DrawingMenuSelected({super.key,required this.items,
    required this.onSelected,  this.initTitle = ''});


  final List<String> items;
  final String initTitle;
  final Function onSelected;

  @override
  State<DrawingMenuSelected> createState() => _DrawingMenuSelectedState();
}

class _DrawingMenuSelectedState extends State<DrawingMenuSelected> with TickerProviderStateMixin{

  bool isDraw = false;
  late final AnimationController animationController;
  late  Animation<double> animationHeight;
  late final Animation<double> animationOpacity;
  late final Animation<double> animationBorder;
  late final ValueNotifier<String> changeTextNotifier;
  final GlobalKey _textKey = GlobalKey();
  late Size textSize;
  double _itemBox = 40.0;
  List<String> _items = [];




  @override
  void initState() {
    super.initState();
    _items = widget.items;
    final itemsTitle = _items.isEmpty?'':_items[_items.length-1];
    final title = widget.initTitle.isEmpty?itemsTitle:widget.initTitle;
    animationController=AnimationController(vsync: this,duration: const Duration(milliseconds: 300));
    animationHeight=Tween<double>(begin: 40.0,end:_heightCalculate(widget.items.length,40.0)).animate(animationController);
    animationOpacity=Tween<double>(begin: 0.0,end: 0.1).animate(animationController);
    animationBorder=Tween<double>(begin: 0.0,end: 1.0).animate(animationController);
    changeTextNotifier=ValueNotifier(title);
    WidgetsBinding.instance.addPostFrameCallback((_) => getSizeAndPosition());
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();


  }

  @override
  void dispose() {
    animationController.dispose();
    changeTextNotifier.dispose();
    super.dispose();
  }


  getSizeAndPosition() {
    RenderBox? cardBox = _textKey.currentContext!.findRenderObject() as RenderBox?;
    textSize = cardBox!.size;
    setState(() {
     double i = textSize.height<50.0?14.0:28.0;
     _itemBox =  textSize.height + i;
     animationHeight= Tween<double>(
         begin: _itemBox,
         end: _heightCalculate(_items.length, _itemBox))
         .animate(animationController);
   });
  }

  double _heightCalculate(int indexItems,double sizeText){
    final s = _items.length == 2?25.0:15.0;
    return (sizeText*indexItems)+40.0;
        //+(s*indexItems);
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
                       SizedBox(height: _itemBox+10),
                      ...List.generate(_items.length, (index){
                        return GestureDetector(
                          onTap: (){
                            isDraw = false;
                            changeTextNotifier.value=_items[index];
                            widget.onSelected.call(index);
                            animationController.reverse();
                          },
                          child: Container(
                            color: Colors.transparent,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            //height:30.0,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(_items[index],
                                      maxLines: 2,
                                      style:
                                  TStyle.textStyleVelaSansMedium(colorGrey,
                                      size: 18.0)),
                                ),
                              ],
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
            if(_items.length>1){
              if(isDraw){
                isDraw=false;
                animationController.reverse();
              }else{
                isDraw=true;
                animationController.forward();
              }
            }

          },
          child: AnimatedBuilder(
              animation: animationOpacity,
              builder: (context,child) {
                return Container(
                    padding: const EdgeInsets.only(right: 26.0,
                        top: 10.0,
                        bottom: 10.0,
                        left:  26.0),

                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: colorBeruzaLight.withOpacity(animationOpacity.value),width: 1.5),
                        borderRadius: BorderRadius.circular(10.0),
                        color: Theme.of(context).colorScheme.surfaceContainerHighest
                    ),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ValueListenableBuilder<String>(
                          builder: (context,value,child) {
                            return Expanded(
                              child: Text(value,
                                  key: _textKey,
                                  maxLines: 2,
                                  style:  TStyle.textStyleVelaSansExtraBolt(Theme.of(context).textTheme.displayMedium!.color!,
                                      size: 18.0))
                            );
                          },
                          valueListenable: changeTextNotifier,
                        ),
                        Visibility(
                          visible: _items.length>1,
                          child: RotatedBox(
                              quarterTurns: isDraw?3:1,
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: colorGrey,
                                size: 16.0,
                              )),
                        ),
                      ],
                    ));
              }
          ),
        ),
      ],
    );
  }
}