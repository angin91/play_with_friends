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
      height: height,
      width: width,
      child: svgPicture
    );
  }
}