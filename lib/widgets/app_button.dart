import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color,
  });

  final Function onPressed;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      height: 50,
      width: size.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color ?? Colors.purple[900]!,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          onPressed();
        },
        child: Container(
          alignment: Alignment.center,
          height: 50,
          width: size.width,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
