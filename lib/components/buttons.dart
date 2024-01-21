


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/utils/text_style.dart';

class SubmitButton extends StatelessWidget {

  final VoidCallback? onTap;
  final String? textButton;
  final double? width;



  const SubmitButton({Key? key,
    this.onTap,
    this.textButton='OK',
    this.width=double.infinity
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: width,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(colorOrange),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
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