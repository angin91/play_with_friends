import 'package:flutter/material.dart';

class CustomSelectionBox extends StatelessWidget {
  CustomSelectionBox({Key key,
    this.color,
    this.selectedColor,
    this.selected = false,
    this.onTap,
    this.height,
    this.circular = 5.0,
    this.child}) : super(key: key);

  final Widget child;
  final Color color;
  final Color selectedColor;
  final bool selected;
  final GestureTapCallback onTap;
  final double height;
  final double circular;

  @override
  Widget build(BuildContext context) {
    if(selected){
      return GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(circular),
          child: Container(
            margin: const EdgeInsets.only(bottom: 6.0, right: 6.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(circular)),
              border: Border.all(color: selectedColor)
            ),
            height: height,
            child: child,
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(circular),
        child: Container(
          margin: const EdgeInsets.only(bottom: 6.0, right: 6.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(circular)),
          ),
          height: height,
          child: child,
        ),
      ),
    );
  }
}
