


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/utils/text_style.dart';

class PhoneField extends StatelessWidget {
  const PhoneField({Key? key, required this.controller,this.readOnly = false,
    required this.textInputFormatter, required this.onChange}) : super(key: key);
  final TextEditingController controller;
  final TextInputFormatter textInputFormatter;
  final bool readOnly;
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
        readOnly: readOnly,
        maxLines: 1,
        keyboardType: TextInputType.phone,
        textAlign: TextAlign.start,
        controller: controller,
        style: TextStyle(color: Theme.of(context).textTheme.displayMedium!.color!),
        decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.background,
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


class CustomField extends StatefulWidget {
   CustomField(
      {Key? key,
        required this.controller,
        required this.textHint,
         this.iconData,
        this.sizeTextHint = 16,
        this.maxLines = 1,
        this.heightBody = 50.0,
        this.borderRadius=50.0,
        this.readOnly = false,
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
  final bool readOnly;
  final TextInputType textInputType;
  final TextCapitalization? textCapitalization;

  @override
  State<CustomField> createState() => _CustomFieldState();
}


class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class _CustomFieldState extends State<CustomField> {
  @override
  Widget build(BuildContext context) {



    return SizedBox(
      height: widget.heightBody,
      child: TextField(
        readOnly: widget.readOnly,
        textCapitalization: widget.textCapitalization==null?
        TextCapitalization.words:widget.textCapitalization!,
        maxLines: widget.maxLines,
        keyboardType: widget.textInputType,
        textAlign: TextAlign.start,
        controller: widget.controller,
          // inputFormatters: [
          //   UpperCaseTextFormatter(),
          // ],
        style: TextStyle(color: Theme.of(context).textTheme.displayMedium!.color!),
        decoration: InputDecoration(

            filled: true,
            fillColor:  Theme.of(context).colorScheme.background,
            suffixIcon: widget.iconData != null?Padding(
              padding: const EdgeInsets.all(14.0),
              child: Icon(widget.iconData,color: colorGrey),
            ):null,
            hintText: widget.textHint.tr(),
            hintStyle: TStyle.textStyleVelaSansRegular(colorGrey,size: 14.0),
            contentPadding:const EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 20),
            enabledBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: colorPink,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
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
        style: TextStyle(color: Theme.of(context).textTheme.displayMedium!.color!),
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



 class TextEdit extends StatefulWidget{
  const TextEdit({super.key, required this.controller, required this.onChanged});


  final TextEditingController controller;
  final Function onChanged;


  @override
  State<TextEdit> createState() => _TextEditState();
}

class _TextEditState extends State<TextEdit> {
  late FocusNode focusNode;


  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        focusNode: focusNode,
        maxLines: null,
        enabled: true,
        onChanged: (text){
          widget.onChanged.call(text);
        },
        textAlign: TextAlign.start,
        controller: widget.controller,
        style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 18),
        decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: (){
                if(!focusNode.hasFocus){
                  focusNode.requestFocus();
                }
              },
              icon: Icon(Icons.edit,color: colorGrey,size: 20),
            ),
            filled: true,
            fillColor:  Colors.transparent,
            hintText: '',
            hintStyle: TStyle.textStyleVelaSansRegular(colorGrey,size: 14.0),
            contentPadding:const EdgeInsets.only(right: 0,top: 0),
            enabledBorder:  const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 1.0,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 1.0,
              ),
            )),
      ),
    );
  }
}