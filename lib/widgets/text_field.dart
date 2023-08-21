import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.textInputType,
    this.isPassword,
    this.textColor,
  }) : super(key: key);

  final Function onChanged;
  final TextEditingController controller;
  final String hintText;
  final TextInputType? textInputType;
  final bool? isPassword;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        onChanged: (value) {
          onChanged(hintText, value);
        },
        keyboardType: textInputType,
        controller: controller,
        obscureText: isPassword != null && isPassword!,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 14,
        ),
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          errorBorder: InputBorder.none,
        ),
      ),
    );
  }
}
