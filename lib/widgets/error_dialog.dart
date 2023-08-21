import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    Key? key,
    required this.title,
    required this.text,
    this.isContinue,
  }) : super(key: key);

  final String title;
  final String text;
  final bool? isContinue;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoAlertDialog(
            title: Text(title),
            content: SingleChildScrollView(child: Text(text)),
            actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.purple[900],
                    ),
                  ),
                ),
              ])
        : AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(child: Text(text)),
            actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.purple[900],
                    ),
                  ),
                ),
              ]);
  }
}
