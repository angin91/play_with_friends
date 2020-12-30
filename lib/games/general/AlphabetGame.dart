import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:flutter/services.dart';
import "dart:math";
import 'package:aeyrium_sensor/aeyrium_sensor.dart';
import 'package:play_with_friends/Helper.dart';
import 'package:play_with_friends/models/custom_icons.dart';
import 'package:play_with_friends/widgets/CustomButton.dart';
import 'package:play_with_friends/widgets/CustomDeckCard.dart';
import 'package:play_with_friends/widgets/CustomTimer.dart';
import 'package:wakelock/wakelock.dart';

class AlphabetGame extends StatefulWidget {
  AlphabetGame({Key key}) : super(key: key);

  @override
  _AlphabetGameState createState() => _AlphabetGameState();
}

class _AlphabetGameState extends State<AlphabetGame> with WidgetsBindingObserver {
  final _random = new Random();
  Helper helper;

  List alphabetList = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "R", "S", "T", "U", "V"];
  String _letter;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    helper = new Helper();
    start();
    Wakelock.enable();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  start(){
    setRandomLetter();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.7;
    double height = MediaQuery.of(context).size.height * 0.7;
    GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: FlipCard(
                key: cardKey,
                onFlipDone: (isFront) {
                  if(!isFront) flipBack(cardKey);
                },
              )
            ),
          ),
          GestureDetector(
              onTap: () => getRule("resource/rules/alphabet_game_rules_swe"),
              child: Icon(CustomIcons.help, color: Colors.white,)
          )
        ],
      ),
    );
  }

  setRandomLetter() {
    var currentIndex = _random.nextInt(alphabetList.length);
    String letter = alphabetList[currentIndex];
    // setState(() {
      // _letter = letter;
    // });
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

  flipBack(cardKey){
    setRandomLetter();
    cardKey.currentState._controller.reverse();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}
