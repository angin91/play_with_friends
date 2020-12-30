import 'package:flutter/material.dart';

class CustomBox extends StatelessWidget {
  CustomBox({Key key,
    this.linearColor1,
    this.linearColor2,
    this.onTap,
    this.height,
    this.child}) : super(key: key);

  final Widget child;
  final Color linearColor1;
  final Color linearColor2;
  final GestureTapCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          margin: const EdgeInsets.only(bottom: 6.0, right: 6.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end:
              Alignment(0.9, 0.0), // 10% of the width, so there are ten blinds.
              colors: [
                linearColor1,
                linearColor2
              ], // red to yellows
            ),
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(5.0, 5.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          height: height,
          child: child,
        ),
      ),
    );
  }
}
