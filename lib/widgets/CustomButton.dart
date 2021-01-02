import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({Key key,
    this.text,
    this.color = Colors.green,
    this.height = 50,
    this.width,
    this.onTap}) : super(key: key);

  final String text;
  final Color color;
  final double height;
  final double width;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(50))
        ),
        height: 50,
        child:  Center(child: Text(text)),
      ),
    );
  }
}