import 'package:flutter/material.dart';

class CustomBox extends StatelessWidget {
  CustomBox({Key key,
    this.text,
    this.color = Colors.green,
    this.onTap,
    this.icon}) : super(key: key);

  final IconData icon;
  final String text;
  final Color color;
  final GestureTapCallback onTap;

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
        height: 100,
        child:  Row(
          children: [
            Expanded(
                flex: 3,
                child: Center(
                    child: Text(text,
                      style: TextStyle(
                        color: Colors.brown[400],
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                      ),
                    )
                )
            ),
            Expanded(
                flex: 1,
                child: Icon(icon, color: Colors.brown[400],)
            )
          ],
        ),
      ),
    );
  }
}