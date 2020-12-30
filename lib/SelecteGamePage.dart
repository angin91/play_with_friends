import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'file:///C:/Users/angin/workspace/play_with_friends/lib/games/GuessWhoStartPage.dart';
import 'package:play_with_friends/Helper.dart';
import 'package:play_with_friends/games/AlphabetGameStartPage.dart';
import 'package:play_with_friends/games/general/ChallengeGame.dart';
import 'package:play_with_friends/games/general/RingOfFire.dart';
import 'package:play_with_friends/widgets/CustomBox.dart';

import 'games/SingALongStartPage.dart';

class SelectGamePage extends StatefulWidget {
  SelectGamePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SelectGamePageState createState() => _SelectGamePageState();
}

class _SelectGamePageState extends State<SelectGamePage> {
  var helper;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  _SelectGamePageState() {
    helper = new Helper();
  }

  Map games = {
    "Guess Who": GuessWhoStartPage(),
    "Sing-a-Long": SingALongStartPage(),
    "Alphabet game": AlphabetGameStartPage(),
    "Challenge game": ChallengeGame(),
    "Ring of Fire": RingOfFire()
  };

  Map drinkingGames = {
    "Challenge game": ChallengeGame(),
    "Ring of Fire": RingOfFire()
  };
  Map teamGames = {
    "Guess Who": GuessWhoStartPage(),
    "Sing-a-Long": SingALongStartPage(),
    "Alphabet game": AlphabetGameStartPage()
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: const Color.fromRGBO(229, 229, 229, 1),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                flexibleSpace: Container(
                  color: const Color.fromRGBO(229, 229, 229, 1),
                  child: Center(
                    child: Text(
                      "Pick a game!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                expandedHeight: 150,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => getCustomBox(index),
                  childCount: 6,
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget getCustomBox(int index) {
    if (index == 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Opacity(
            opacity: 0.7,
            child: Text(
              "ALL GAMES",
              style: TextStyle(
                fontSize: 22,
              ),
            )),
      );
    }
    if (index == 1) {
      return _buildCarousel(context, games.length, games);
    }
    if (index == 2) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Opacity(
            opacity: 0.7,
            child: Text(
              "DRINKING GAMES",
              style: TextStyle(
                fontSize: 22,
              ),
            )),
      );
    }
    if (index == 3) {
      return _buildCarousel(context, drinkingGames.length, drinkingGames);
    }
    if (index == 4) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Opacity(
            opacity: 0.7,
            child: Text(
              "TEAM-GAMES",
              style: TextStyle(
                fontSize: 22,
              ),
            )),
      );
    }
    if (index == 5) {
      return _buildCarousel(context, teamGames.length, teamGames);
    }
    return Container();
  }

  Widget _buildCarousel(BuildContext context, int carouselLenght, Map games) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 300.0,
            child: PageView.builder(
              itemCount: carouselLenght,
              controller: PageController(viewportFraction: 0.8),
              itemBuilder: (BuildContext context, int itemIndex) {
                if (games.keys
                    .elementAt(itemIndex)
                    .toString()
                    .contains("Sing-a-Long")) {
                  return _buildCarouselItem(
                      context,
                      itemIndex,
                      Colors.purple[800],
                      Colors.purple[400],
                      "Sing-a-Long",
                      games.values.elementAt(itemIndex));
                }
                if (games.keys
                    .elementAt(itemIndex)
                    .toString()
                    .contains("Ring of Fire")) {
                  return _buildCarouselItem(
                      context,
                      itemIndex,
                      Colors.blue[800],
                      Colors.blue[400],
                      "Ring of Fire",
                      games.values.elementAt(itemIndex));
                }
                if (games.keys
                    .elementAt(itemIndex)
                    .toString()
                    .contains("Challenge game")) {
                  return _buildCarouselItem(
                      context,
                      itemIndex,
                      Colors.yellow[900],
                      Colors.yellow[700],
                      "Challenge game",
                      games.values.elementAt(itemIndex));
                }
                if (games.keys
                    .elementAt(itemIndex)
                    .toString()
                    .contains("Guess Who")) {
                  return _buildCarouselItem(
                      context,
                      itemIndex,
                      Colors.teal[800],
                      Colors.teal[400],
                      "Guess Who",
                      games.values.elementAt(itemIndex));
                }
                if (games.keys
                    .elementAt(itemIndex)
                    .toString()
                    .contains("Alphabet game")) {
                  return _buildCarouselItem(
                      context,
                      itemIndex,
                      Colors.grey[800],
                      Colors.grey[400],
                      "Alphabet game",
                      games.values.elementAt(itemIndex));
                }
                return _buildCarouselItem(context, itemIndex, Colors.green[800],
                    Colors.green[400], "Test", null);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCarouselItem(BuildContext context, int itemIndex, Color color1,
      Color color2, String name, page) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: CustomBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    name,
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              Row(
                children: [
                  Spacer(),
                  Icon(
                    Icons.play_circle_fill,
                    color: Colors.white,
                    size: 40,
                  ),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
          linearColor1: color1,
          linearColor2: color2,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          ),
        ));
  }
}
