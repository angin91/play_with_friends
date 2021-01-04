import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "dart:math";
import 'package:play_with_friends/helper.dart';
import 'package:play_with_friends/models/custom_icons.dart';
import 'package:wakelock/wakelock.dart';
import 'package:styled_text/styled_text.dart';
import 'package:play_with_friends/widgets/custom_box.dart';

class AlphabetGame extends StatefulWidget {
  AlphabetGame({Key key}) : super(key: key);

  @override
  _AlphabetGameState createState() => _AlphabetGameState();
}

class _AlphabetGameState extends State<AlphabetGame> with WidgetsBindingObserver {
  final _random = new Random();
  Helper helper;
  Color _color = Colors.grey;

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
      appBar: AppBar(
        title: Text("Guess Who"),
        elevation: 0,
        actions: [
          GestureDetector(
            child: Icon(
              CustomIcons.help_circled,
              color: _color,
            ),
            onTap: () => getRule("resource/rules/alphabet_game_rules_swe"),
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(241, 233, 218, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FlipCard(
                key: cardKey,
                onFlipDone: (isFront) {
                  print(cardKey.currentState);
                  setRandomLetter();
                },
                back: CustomBox(
                  linearColor1: Colors.grey[300],
                  linearColor2: Colors.grey[700],
                  circular: 20,
                  height: height,
                ),
                front: CustomBox(
                  linearColor1: Colors.grey[700],
                  linearColor2: Colors.grey[300],
                  circular: 20,
                  height: height,
                  child: Center(child: Text(_letter)),
                ),
              ),
            )
          ),
        ],
      ),
    );
  }

  setRandomLetter() {
    var currentIndex = _random.nextInt(alphabetList.length);
    String letter = alphabetList[currentIndex];
    setState(() {
      _letter = letter;
    });
  }

  flipBack(cardKey){
    setRandomLetter();
    cardKey.currentState._controller.reverse();
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
