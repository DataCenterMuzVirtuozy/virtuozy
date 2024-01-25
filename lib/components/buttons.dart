


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/utils/text_style.dart';

// ignore: must_be_immutable
class SubmitButton extends StatelessWidget {

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
  Widget build(BuildContext context) {

    colorFill ??= colorOrange;

    return SizedBox(
      height: 50,
      width: width,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(colorFill!),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius!),
                )
            )
        ),
        onPressed: onTap,
        child: Text(
          textButton!,
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
            side:  BorderSide(color: colorOrange),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: (){

      },
          child:  Text(
          textButton!,
          textAlign: TextAlign.center,
      style: TStyle.textStyleVelaSansBold(colorOrange,size: 15.0))),
    );

  }

}