


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/utils/text_style.dart';

// ignore: must_be_immutable
class SubmitButton extends StatefulWidget {

  final VoidCallback? onTap;
  final String? textButton;
  final double? width;
  final double? borderRadius;
   Color? colorFill;



   SubmitButton({Key? key,
    this.onTap,
    this.textButton='OK',
     this.borderRadius = 50.0,
    this.width=double.infinity,
    this.colorFill
  }):super(key: key);

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {


  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 50,
      width: widget.width,
      child: ElevatedButton(
        autofocus: true,
        style: ButtonStyle(
          splashFactory: InkRipple.splashFactory,
            overlayColor: MaterialStateProperty.resolveWith(
                  (states) {
                return states.contains(MaterialState.pressed)
                    ? Theme.of(context).colorScheme.secondary.withOpacity(0.2)
                    : Theme.of(context).colorScheme.secondary;
              },
            ),
            backgroundColor: widget.colorFill==null?
            MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.secondary):
            MaterialStateProperty.all<Color>(widget.colorFill!),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius!),
                )
            )
        ),
        onPressed: widget.onTap,
        child: Text(
          widget.textButton!,
          textAlign: TextAlign.center,
          style: TStyle.textStyleVelaSansBold(colorWhite,size: 15.0)
        ),
      ),
    );
  }
}
class OutLineButton extends StatelessWidget{
  const OutLineButton(
      {super.key, this.onTap, this.textButton,
  this.width=double.infinity , this.borderRadius});

  final VoidCallback? onTap;
  final String? textButton;
  final double? width;
  final double? borderRadius;


  @override
  Widget build(BuildContext context) {



    return SizedBox(
      width: width,
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side:  BorderSide(color: Theme.of(context).colorScheme.secondary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: (){

      },
          child:  Text(
          textButton!,
          textAlign: TextAlign.center,
      style: TStyle.textStyleVelaSansBold(Theme.of(context).colorScheme.secondary,
          size: 15.0))),
    );

  }

}