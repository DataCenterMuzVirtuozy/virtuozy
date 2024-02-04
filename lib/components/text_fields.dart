


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/utils/text_style.dart';

class PhoneField extends StatelessWidget {
  const PhoneField({Key? key, required this.controller,this.activate = true,
    required this.textInputFormatter, required this.onChange}) : super(key: key);
  final TextEditingController controller;
  final TextInputFormatter textInputFormatter;
  final bool activate;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        onChanged: (text){
          onChange.call(text);
        },
        inputFormatters: [textInputFormatter],
        readOnly: activate,
        maxLines: 1,
        keyboardType: TextInputType.phone,
        textAlign: TextAlign.start,
        controller: controller,
        style: TextStyle(color: colorBlack),
        decoration: InputDecoration(
            filled: true,
            fillColor: colorPink.withOpacity(0.5),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Icon(Icons.phone,color: colorGrey),
            ),
            hintText: 'Номер телефона'.tr(),
            hintStyle: TStyle.textStyleVelaSansRegular(colorGrey,size: 14.0),
            contentPadding:const EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 20),
            enabledBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                color: colorPink,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                color: colorOrange,
                width: 1.0,
              ),
            )),
      ),
    );
  }
}


class CustomField extends StatelessWidget {
   CustomField(
      {Key? key,
        required this.controller,
        required this.textHint,
         this.iconData,
        this.sizeTextHint = 16,
        this.maxLines = 1,
        this.heightBody = 50.0,
        this.borderRadius=50.0,
        this.activate = true,
        this.textInputType = TextInputType.emailAddress,
        required this.fillColor,
        this.textCapitalization})
      : super(key: key);
  final TextEditingController controller;
  final String textHint;
   IconData? iconData;
  final double sizeTextHint;
  final int maxLines;
  final double heightBody;
  final double borderRadius;
  final Color fillColor;
  final bool activate;
  final TextInputType textInputType;
  final TextCapitalization? textCapitalization;

  @override
  Widget build(BuildContext context) {



    return SizedBox(
      height: heightBody,
      child: TextField(
        readOnly: activate,
        textCapitalization: textCapitalization==null?
        TextCapitalization.none:textCapitalization!,
        maxLines: maxLines,
        keyboardType: textInputType,
        textAlign: TextAlign.start,
        controller: controller,
        style: TextStyle(color: colorBlack),
        decoration: InputDecoration(
            filled: true,
            fillColor: fillColor,
            suffixIcon: iconData != null?Padding(
              padding: const EdgeInsets.all(14.0),
              child: Icon(iconData,color: colorGrey),
            ):null,
            hintText: textHint.tr(),
            hintStyle: TStyle.textStyleVelaSansRegular(colorGrey,size: 14.0),
            contentPadding:const EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 20),
            enabledBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: colorPink,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: colorOrange,
                width: 1.0,
              ),
            )),
      ),
    );
  }
}

class PassFieldLogin extends StatefulWidget {
  const PassFieldLogin({Key? key, required this.controller,required this.textHint}) : super(key: key);
  final TextEditingController controller;
  final String textHint;

  @override
  State<PassFieldLogin> createState() => _PassFieldLoginState();
}

class _PassFieldLoginState extends State<PassFieldLogin> {
  bool _isVisiblePass=true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        maxLines: 1,
        obscureText: _isVisiblePass,
        keyboardType: TextInputType.visiblePassword,
        textAlign: TextAlign.start,
        controller: widget.controller,
        style: TextStyle(color: colorBlack),
        decoration: InputDecoration(
            filled: true,
            fillColor: colorWhite,
            suffixIcon: GestureDetector(
              onTap: (){
                setState(() {
                  if(_isVisiblePass){
                    _isVisiblePass=false;
                  }else{
                    _isVisiblePass=true;
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: _isVisiblePass?Icon(Icons.lock_outline,color: colorGrey):
                Icon(Icons.lock_open,color: colorGrey),
              ),
            ),
            hintText: widget.textHint.tr(),
            hintStyle: TStyle.textStyleVelaSansBold(colorGrey),
            contentPadding:const EdgeInsets.only(left: 20,right: 20,top: 12,bottom: 12),
            enabledBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                color: colorPink,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                color: colorOrange,
                width: 1.0,
              ),
            )),
      ),
    );
  }
}