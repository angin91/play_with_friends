import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:play_with_friends/games/general/RulePage.dart';
import 'package:play_with_friends/models/CostumButton.dart';

import '../Helper.dart';
import 'general/SingALong.dart';

class SingALongStartPage extends StatefulWidget {
  SingALongStartPage({Key key}) : super(key: key);

  @override
  _SingALongStartPageState createState() => _SingALongStartPageState();
}

class _SingALongStartPageState extends State<SingALongStartPage> {
  Helper helper;
  int _teamOnePoints = 0;
  int _teamTwoPoints = 0;

  @override
  void initState() {
    super.initState();
    helper = new Helper();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sing-a-Long"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Sing-a-Long",
                style: TextStyle(fontSize: 40),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.orange,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: Text("Team 1")),
                            Center(child: Text(_teamOnePoints.toString())),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.pink,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: Text("Team 2")),
                            Center(child: Text(_teamTwoPoints.toString())),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _teamOnePoints--;
                      }),
                      child: Container(
                        height: 50,
                        color: Colors.orange,
                        child: Center(child: Text("-")),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _teamOnePoints++;
                      }),
                      child: Container(
                        height: 50,
                        color: Colors.orange,
                        child: Center(child: Text("+")),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _teamTwoPoints--;
                      }),
                      child: Container(
                        height: 50,
                        color: Colors.pink,
                        child: Center(child: Text("-")),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _teamTwoPoints++;
                      }),
                      child: Container(
                        height: 50,
                        color: Colors.pink,
                        child: Center(child: Text("+")),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      text: "Start",
                      onTap: () => getSong(),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      text: "Rules",
                      onTap: () =>
                          getRule("resource/rules/sing_a_long_rules_swe"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  addPoints(int points) {}

  getSong() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SingALong(songTitle: "(\"I Wanna Dance with Somebody\” by Whitney Houston)", frontText: "Oh, I wanna dance with somebody, I wanna feel the heat with somebody", backText: "Yeah, I wanna dance with somebody, With somebody who loves me")));
  }

  void getRule(url) async {
    var text = await helper.getFileData(url);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RulePage(text: text),
        ));
  }
}
