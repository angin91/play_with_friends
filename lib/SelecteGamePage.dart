import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fullscreen/fullscreen.dart';
import 'file:///C:/Users/angin/workspace/play_with_friends/lib/games/GuessWhoStartPage.dart';
import 'package:play_with_friends/Helper.dart';
import 'package:play_with_friends/games/AlphabetGameStartPage.dart';
import 'package:play_with_friends/games/CharadesStartPage.dart';
import 'package:play_with_friends/widgets/CostumButton.dart';
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
    "Charades": CharadesStartPage(),
    "Guess Who": GuessWhoStartPage(),
    "Sing-a-Long": SingALongStartPage(),
    "a-a-Long": SingALongStartPage(),
    "s-a-Long": SingALongStartPage(),
    "Alphabet game": AlphabetGameStartPage()
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.black,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey[600], Colors.black],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                ),
              ),
              child: Center(
                  child: Text(
                "Wanna play a game?",
                style: TextStyle(color: Colors.white, fontSize: 40),
              )),
            ),
            // Make the initial height of the SliverAppBar larger than normal.
            expandedHeight: 150,
          ),
          SliverList(
            // Use a delegate to build items as they're scrolled on screen.
            delegate: SliverChildBuilderDelegate(
              // The builder function returns a ListTile with a title that
              // displays the index of the current item.
              (context, index) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: getCostumBox(index),
              ),
              // Builds 1000 ListTiles
              childCount: games.length,
            ),
          )
        ],
      ),
    ));
  }

  Widget getCostumBox(int index) {
    if (index == 0) {
      return CustomBox(
        text: games.keys.elementAt(index),
        color: Colors.pink[200],
        icon: Icons.masks,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => games.values.elementAt(index)),),
      );
    }
    if (index == 1) {
      return CustomBox(
        text: games.keys.elementAt(index),
        color: Colors.orange[200],
        icon: Icons.person,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => games.values.elementAt(index)),),
      );
    }
    if (index == 2) {
      return CustomBox(
        text: games.keys.elementAt(index),
        color: Colors.yellow[200],
        icon: Icons.music_note,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => games.values.elementAt(index)),),
      );
    }
    if (index == 3) {
      return CustomBox(
        text: games.keys.elementAt(index),
        color: Colors.green[200],
        icon: Icons.music_note,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => games.values.elementAt(index)),),
      );
    }
    if (index == 4) {
      return CustomBox(
        text: games.keys.elementAt(index),
        color: Colors.green[400],
        icon: Icons.music_note,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => games.values.elementAt(index)),),
      );
    }
    if (index == 5) {
      return CustomBox(
        text: games.keys.elementAt(index),
        color: Colors.blue[200],
        icon: Icons.style,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => games.values.elementAt(index)),),
      );
    }
  }
}
