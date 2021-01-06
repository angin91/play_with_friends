import 'dart:convert';

import 'package:play_with_friends/models/challenge.dart';
import 'package:play_with_friends/models/custom_icons.dart';
import 'package:play_with_friends/widgets/challenge_card.dart';
import 'package:play_with_friends/widgets/custom_box.dart';
import 'package:styled_text/styled_text.dart';
import 'package:swipeable_card/swipeable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "dart:math";
import 'package:play_with_friends/helper.dart';

class ChallengeGame extends StatefulWidget {
  ChallengeGame({Key key, this.players}) : super(key: key);

  final List<String> players;

  @override
  _ChallengeGameState createState() => _ChallengeGameState();
}

class _ChallengeGameState extends State<ChallengeGame> with WidgetsBindingObserver {
  Helper helper;
  final _random = new Random();
  Color _color = Colors.yellow[800];
  List<ChallengeCard> cards = new List<ChallengeCard>();
  int currentCardIndex = 0;
  Future load;
  List<String> players;
  List<String> doneChallenges = new List<String>();

  @override
  void initState() {
    super.initState();
    players = widget.players;
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
              challenge: challenge, player: getRandomPlayer(),
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
        actions: [
          GestureDetector(
            child: Icon(
              CustomIcons.help_circled,
              color: _color,
            ),
            onTap: () => getRule("resource/rules/challenge_game_rules_swe"),
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(241, 233, 218, 1),
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
                    onLeftSwipe: () => swipe(),
                    onRightSwipe: () => swipe(),
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

  void swipe() {
    Challenge challenge = cards[currentCardIndex].challenge;
    setState(() {
      if(challenge.duration > 1 && challenge.duration + currentCardIndex <= cards.length && !doneChallenges.contains(challenge.number)){
        cards.insert(currentCardIndex + challenge.duration, ChallengeCard(
          challenge: Challenge(challenge.title, challenge.doneText ,challenge.number,  0, true, 1, ""),
          player: cards[currentCardIndex].player,)
        );
        doneChallenges.add(challenge.number);
      }
      currentCardIndex++;
    });
    print(cards.length);
  }

  Widget cardControllerRow(SwipeableWidgetController cardController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomBox(
              circular: 50,
              height: 50,
              linearColor1: _color,
              linearColor2: _color,
              onTap: () {
                if(currentCardIndex >= 1) setState(() => currentCardIndex--);
              },
              child: Center(child: Text("Back")),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomBox(
              circular: 50,
              height: 50,
              linearColor1: _color,
              linearColor2: _color,
              onTap: () => cardController.triggerSwipeRight(),
              child: Center(child: Text("Next")),
            ),
          ),
        ),
      ],
    );
  }

  getRandomPlayer(){
    var _currentIndex = _random.nextInt(players.length);
    String text = players[_currentIndex];
    return text;
  }

  void getRule(url) async {
    var text = await helper.getFileData(url);

    showModalBottomSheet(context: context, builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          height: MediaQuery.of(context).copyWith().size.height * 0.90,
          color: Colors.transparent,
          child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(20.0),
                      topRight: const Radius.circular(20.0))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Spacer(),
                        GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(Icons.close, color: _color, size: 35,)
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: StyledText(
                        text: text,
                        newLineAsBreaks: true,
                        textAlign: TextAlign.center,
                        styles: {
                          "bold": TextStyle(fontWeight: FontWeight.bold),
                          "header" : TextStyle(fontSize: 32)
                        },
                      ),
                    ),
                  ),
                ],
              )),
        ),
      );
    }, isScrollControlled: true);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}
