import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({
    Key? key,
    required this.size,
  }) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'app icon',
      child: Container(
        height: size,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icons/appLogo.png'),
          ),
        ),
      ),
    );
  }
}

class MyImageIcon extends StatelessWidget {
  const MyImageIcon({
    Key? key,
    required this.icon,
    this.color,
    this.size,
    this.isGif,
  }) : super(key: key);

  final String icon;
  final Color? color;
  final double? size;
  final bool? isGif;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? 15,
      height: size ?? 15,
      decoration: BoxDecoration(
        image: color != null
            ? null
            : DecorationImage(
                image: AssetImage(
                    'assets/icons/$icon.${isGif != null && isGif! ? 'gif' : 'png'}'),
                fit: BoxFit.contain,
              ),
      ),
      child: color != null
          ? ImageIcon(
              AssetImage(
                  'assets/icons/$icon.${isGif != null && isGif! ? 'gif' : 'png'}'),
              color: color,
            )
          : null,
    );
  }
}
