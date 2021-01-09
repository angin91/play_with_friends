import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:play_with_friends/models/deck_card.dart';

class CustomDeckCard extends StatelessWidget {
  CustomDeckCard({Key key,
    this.deckCard
  }) : super(key: key);

  final DeckCard deckCard;

  @override
  Widget build(BuildContext context) {
    var svgPicture = SvgPicture.asset(deckCard.url, fit: BoxFit.fill,);
    double width = MediaQuery.of(context).size.width * 0.6;
    double height = MediaQuery.of(context).size.height * 0.5;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: Offset(0, 4.0), //(x,y)
            blurRadius: 4.0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: Offset(0, 2.0), //(x,y)
            blurRadius: 4.0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(2.0, 8.0), //(x,y)
            blurRadius: 12.0,
          ),
        ]
      ),
      height: height,
      width: width,
      child: svgPicture
    );
  }
}