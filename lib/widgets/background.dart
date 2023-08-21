import 'package:flutter/material.dart';

class MyBackground extends StatelessWidget {
  const MyBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            const Color.fromARGB(255, 17, 17, 17),
            Color.fromARGB(255, 22, 22, 22),
          ],
        ),
      ),
    );
  }
}
