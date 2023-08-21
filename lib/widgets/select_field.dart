import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../models/user.dart';

import 'gender_select_dialog.dart';

class SelectField extends StatelessWidget {
  const SelectField({
    Key? key,
    required this.text,
    required this.initialValue,
    this.getGender,
  }) : super(key: key);

  final String text;
  final String initialValue;
  final Function? getGender;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      fontSize: 14,
      color: initialValue == '' ? Colors.grey[400]! : Colors.white,
    );

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => GenderSelectDialog(getGender: getGender),
        );
      },
      child: Container(
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 4,
              child: Text(text, style: textStyle),
            ),
            const SizedBox(width: 50),
            Text(initialValue, style: textStyle),
          ],
        ),
      ),
    );
  }
}
