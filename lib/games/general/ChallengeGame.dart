import 'dart:convert';

import 'package:play_with_friends/models/Challenge.dart';
import 'package:play_with_friends/widgets/ChallengeCard.dart';
import 'package:play_with_friends/widgets/CostumButton.dart';
import 'package:play_with_friends/widgets/CostumDeckCard.dart';
import 'package:swipeable_card/swipeable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "dart:math";
import 'package:play_with_friends/Helper.dart';
import 'package:wakelock/wakelock.dart';

class ChallengeGame extends StatefulWidget {
  ChallengeGame({Key key,}) : super(key: key);

  @override
  _ChallengeGameState createState() => _ChallengeGameState();
}

class _ChallengeGameState extends State<ChallengeGame> with WidgetsBindingObserver {
  Helper helper;
  final _random = new Random();
  List<ChallengeCard> cards = new List<ChallengeCard>();
  int currentCardIndex = 0;
  Future load;

  @override
  void initState() {
    super.initState();
    helper = new Helper();
    load = setChallenges();
  }

  setChallenges() async {
    List<Challenge> challenges;
    var s = await helper.getFileData("resource/challenges/challenges");
    var jsonChallenges = jsonDecode(s)['challenges'] as List;
    challenges = jsonChallenges.map((jsonChallenge) => Challenge.fromJson(jsonChallenge)).toList();
    challenges.forEach((challenge) {
      cards.add(
          ChallengeCard(
              challenge: challenge
          )
      );
    });
    cards.shuffle(_random);
  }

  @override
  Widget build(BuildContext context) {
    SwipeableWidgetController _cardController = SwipeableWidgetController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Challenge game"),
        elevation: 0,
      ),
      backgroundColor: const Color.fromRGBO(229, 229, 229, 1),
      body: SafeArea(
        child: FutureBuilder(
          future: load,
          builder:  (BuildContext context, AsyncSnapshot snapshot) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                if (currentCardIndex < cards.length)
                  SwipeableWidget(
                    cardController: _cardController,
                    animationDuration: 200,
                    horizontalThreshold: 0.85,
                    scrollSensitivity: 4.5,
                    child: cards[currentCardIndex],
                    nextCards: <Widget>[
                      // show next card
                      // if there are no next cards, show nothing
                      if (!(currentCardIndex + 1 >= cards.length))
                        Align(
                          alignment: Alignment.center,
                          child: cards[currentCardIndex + 1],
                        ),
                    ],
                    onLeftSwipe: () => swipeLeft(),
                    onRightSwipe: () => swipeRight(),
                  )
                else
                // if the deck is complete, add a button to reset deck
                  Center(
                    child: FlatButton(
                      child: Text("Reset deck", style: TextStyle(fontSize: 30)),
                      onPressed: () => setState(() => currentCardIndex = 0),
                    ),
                  ),

                // only show the card controlling buttons when there are cards
                // otherwise, just hide it
                if (currentCardIndex < cards.length)
                  cardControllerRow(_cardController),
              ],
            );
          },
        ),
      ),
    );
  }

  void swipeLeft() {
    print("left");

    // NOTE: it is your job to change the card
    setState(() {
      currentCardIndex++;
    });
  }

  void swipeRight() {
    print("right");
    setState(() {
      currentCardIndex++;
    });
  }

  Widget cardControllerRow(SwipeableWidgetController cardController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              color: Colors.yellow[800],
              onTap: () {
                if(currentCardIndex >= 1) setState(() => currentCardIndex--);
              },
              text: "Back",
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              color: Colors.yellow[800],
              onTap: () => cardController.triggerSwipeRight(),
              text: "Next",
            ),
          ),
        ),
      ],
    );
  }

  getRule(url) async {
    var text = await helper.getFileData(url);

    showModalBottomSheet(context: context, builder: (context) {
      return Container(
        height: MediaQuery.of(context).copyWith().size.height * 0.70,
        color: Colors.transparent,
        child: new Container(
            decoration: new BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0))),
            child: new Center(
              child: new Text(text, textAlign: TextAlign.center,),
            )),
      );
    }, isScrollControlled: true);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}
