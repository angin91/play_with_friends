import 'package:flutter/material.dart';
import 'package:play_with_friends/models/Challenge.dart';

class ChallengeCard extends StatelessWidget {
  ChallengeCard({Key key,
    this.color,
    @required this.challenge
  }) : super(key: key);

  final Challenge challenge;
  final Color color;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
        height: width,
        width: width * 0.8,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end:
            Alignment(0.9, 0.0), // 10% of the width, so there are ten blinds.
            colors: [
              Colors.yellow[900],
              Colors.yellow[700]
            ], // red to yellows
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(5.0, 5.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25, top: 10),
                        child: Text(challenge.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                      )
                  ),
                  VerticalDivider(
                    indent: 5,
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("#" + challenge.number, style: TextStyle(fontWeight: FontWeight.bold),),
                  )
                ],
              ),
            ),
            Divider(
              indent: 5,
              endIndent: 5,
              color: Colors.black,
            ),
            Expanded(child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Text(challenge.challenge,
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
            ))
          ],
        )
    );
  }
}