import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:play_with_friends/Helper.dart';
import 'package:play_with_friends/games/general/AlphabetGame.dart';
import 'package:play_with_friends/games/general/RulePage.dart';
import 'package:play_with_friends/widgets/BaseAlertTextDialog.dart';
import 'package:play_with_friends/widgets/CustomButton.dart';

class AlphabetGameStartPage extends StatefulWidget {
  AlphabetGameStartPage({Key key}) : super(key: key);

  @override
  _AlphabetGameStartPageState createState() => _AlphabetGameStartPageState();
}

class _AlphabetGameStartPageState extends State<AlphabetGameStartPage> {
  Helper helper;
  List<String> _players;
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    helper = new Helper();
    _players = new List<String>();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  resetPlayer() {
    _players.clear();
  }

  setPlayer(BuildContext context) {
    var baseDialog = BaseAlertTextDialog(
      title: "Confirm Registration",
      yesOnPressed: () {
        setState(() {
          _players.add(_controller.text);
        });
        _controller.clear();
        Navigator.pop(context);
      },
      noOnPressed: () {
        _controller.clear();
        Navigator.pop(context);
      },
      yes: "Add",
      no: "Cancel",
      controller: _controller,
    );
    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Alphabet game"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                text: "Add player",
                onTap: () => setPlayer(context),
              ),
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                ),
                itemCount: _players.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: Text(_players[index])),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      text: "Start",
                      onTap: () => startGame(),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      text: "Rules",
                      onTap: () =>
                          getRule("resource/rules/alphabet_game_rules_swe"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  void startGame() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AlphabetGame(),));
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
