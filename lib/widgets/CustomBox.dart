import 'package:flutter/material.dart';

class CustomBox extends StatelessWidget {
  CustomBox({Key key,
    this.color = Colors.green,
    this.onTap,
    this.height,
    this.child}) : super(key: key);

  final Widget child;
  final Color color;
  final GestureTapCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.white, width: 6),
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        height: height,
        child: child,
      ),
    );
  }
}
