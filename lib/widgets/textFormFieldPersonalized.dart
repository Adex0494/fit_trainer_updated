import 'package:flutter/material.dart';
class TextFormFieldPersonalized extends StatelessWidget {
  
  const TextFormFieldPersonalized({
    @required this.controller,
    @required this.theLabelText,
    @required this.bottomPadding,
    @required this.isTextObscure,
  });

  final TextEditingController controller;
  final String theLabelText;
  final double bottomPadding;
  final bool isTextObscure;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: TextFormField(
        style: TextStyle(color: Colors.black, fontSize: 17,),
        controller: controller,
        cursorColor: Color.fromRGBO(242, 36, 36, 1),
        obscureText: isTextObscure,
        decoration: InputDecoration(
            //fillColor: Color.fromRGBO(242, 36, 36, 1),
            labelText: theLabelText,
            labelStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent, width: 2),
              borderRadius: BorderRadius.circular(5.0),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent),
              borderRadius: BorderRadius.circular(5.0),
            )),
        onChanged: (value) {
          //when Usuario text changes...
        },
      ),
    );
  }
}