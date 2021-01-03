import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:play_with_friends/Helper.dart';
import 'package:play_with_friends/games/GuessWhoChooseCategory.dart';
import 'package:play_with_friends/games/general/ChallengeGame.dart';
import 'package:play_with_friends/games/general/RingOfFire.dart';
import 'package:play_with_friends/games/general/AlphabetGame.dart';
import 'package:play_with_friends/games/general/SingALong.dart';
import 'package:play_with_friends/models/Game.dart';
import 'package:play_with_friends/widgets/CustomBox.dart';

class SelectGamePage extends StatefulWidget {
  SelectGamePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SelectGamePageState createState() => _SelectGamePageState();
}

class _SelectGamePageState extends State<SelectGamePage> {
  var helper;
  List<Game> games = new List();

  @override
  void initState() {
    super.initState();
    _setGameList();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  _SelectGamePageState() {
    helper = new Helper();
  }

  _setGameList(){
    games.add(Game("Guess Who", GuessWhoChooseCategory(), [GameTag.teamGame], Colors.pink[700], Colors.pink[300]));
    games.add(Game("Sing-a-Long", SingALong(), [GameTag.teamGame], Colors.purple[800], Colors.purple[400]));
    games.add(Game("Alphabet game", AlphabetGame(), [GameTag.drinkingGame], Colors.grey[800], Colors.grey[400]));
    games.add(Game("Challenge game", ChallengeGame(), [GameTag.drinkingGame], Colors.yellow[900], Colors.yellow[700]));
    games.add(Game("Ring of Fire", RingOfFire(), [GameTag.drinkingGame], Colors.blue[800], Colors.blue[400]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: const Color.fromRGBO(241, 233, 218, 1),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                flexibleSpace: Container(
                  color: const Color.fromRGBO(241, 233, 218, 1),
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
        child: Text(
          "ALL GAMES",
          style: TextStyle(
            fontSize: 22,
            color: Colors.black.withOpacity(0.6)
          ),
        ),
      );
    }
    if (index == 1) {
      return _buildCarousel(context, null);
    }
    if (index == 2) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "DRINKING GAMES",
          style: TextStyle(
              fontSize: 22,
              color: Colors.black.withOpacity(0.6)
          ),
        ),
      );
    }
    if (index == 3) {
      return _buildCarousel(context, GameTag.drinkingGame);
    }
    if (index == 4) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "TEAM-GAMES",
          style: TextStyle(
              fontSize: 22,
              color: Colors.black.withOpacity(0.6)
          ),
        ),
      );
    }
    if (index == 5) {
      return _buildCarousel(context, GameTag.teamGame);
    }
    return Container();
  }

  Widget _buildCarousel(BuildContext context, GameTag tag) {
    List<Game> games = getGamesWithTag(tag);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 300.0,
            child: PageView.builder(
              itemCount: games.length,
              controller: PageController(viewportFraction: 0.8),
              itemBuilder: (BuildContext context, int itemIndex) {
                return _buildCarouselItem(
                    context,
                    games[itemIndex].color1,
                    games[itemIndex].color2,
                    games[itemIndex].title,
                    games[itemIndex].game);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCarouselItem(BuildContext context, Color color1,
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

  List<Game> getGamesWithTag(GameTag tag) {
    if(tag == null){
      return games;
    }
    List<Game> newGameList = new List();
    for(Game game in games){
      if(game.hasTag(tag)){
        newGameList.add(game);
      }
    }
    return newGameList;
  }
}
