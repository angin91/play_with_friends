import 'package:flutter/material.dart';
import 'file:///C:/Users/angin/workspace/play_with_friends/lib/games/GuessWhoStartPage.dart';
import 'package:play_with_friends/Helper.dart';
import 'package:play_with_friends/games/CharadesStartPage.dart';
import 'package:play_with_friends/models/CostumButton.dart';

import 'models/CostumTimer.dart';

class SelectGamePage extends StatefulWidget {
  SelectGamePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SelectGamePageState createState() => _SelectGamePageState();
}

class _SelectGamePageState extends State<SelectGamePage> {
  var helper;

  _SelectGamePageState() {
    helper = new Helper();
  }

  Map games = {
    "Charades": CharadesStartPage(),
    "Guess Who": GuessWhoStartPage()
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Text(
                "Wanna play a game?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: ListView.separated(
                  itemCount: games.length,
                  itemBuilder: (context, index) => CustomButton(
                    text: games.keys.elementAt(index),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => games.values.elementAt(index)),),
                  ),
                  separatorBuilder: (context, index) => SizedBox(
                    height: 3,
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  getJson(url) async {
    String text = await helper.getFileData(url);
  }
}
