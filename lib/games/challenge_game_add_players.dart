import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:play_with_friends/helper.dart';
import 'package:play_with_friends/models/custom_icons.dart';
import 'package:play_with_friends/widgets/custom_box.dart';
import 'package:play_with_friends/widgets/base_alert_text_dialog.dart';
import 'package:play_with_friends/games/challenge_game.dart';
import 'package:styled_text/styled_text.dart';

class ChallengeGameAddPlayers extends StatefulWidget {
  ChallengeGameAddPlayers({Key key,}) : super(key: key);

  @override
  _ChallengeGameAddPlayersState createState() => _ChallengeGameAddPlayersState();
}

class _ChallengeGameAddPlayersState extends State<ChallengeGameAddPlayers> with WidgetsBindingObserver {
  Helper helper;
  List<String> _players = [];
  Color _color = Colors.yellow[800];
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    helper = new Helper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Text(
              "Add players",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                    height: 10,
                  ),
                  itemCount: _players.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomBox(
                      circular: 10,
                      height: 60,
                      linearColor1: Colors.white,
                      linearColor2: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          Text(
                            _players[index],
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                                onTap: () => setState(() => _players.removeAt(index)),
                                child: Icon(Icons.delete)
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
            ),
          ),
          Row(
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
                      showDialog(context: context, builder: (BuildContext context) => BaseAlertTextDialog(
                        title: "Add player",
                        controller: _controller,
                        yes: "Add",
                        no: "Cancel",
                        noOnPressed: () => Navigator.pop(context),
                        yesOnPressed: () {
                          if(_controller.text != ""){
                            setState(() {
                              _players.add(_controller.text);
                              _controller.clear();
                            });
                          }
                          Navigator.pop(context);
                        },
                      ));
                    },
                    child: Center(child: Text("Add player!")),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _players.length == 0 ?
                  CustomBox(
                    circular: 50,
                    height: 50,
                    linearColor1: Colors.grey,
                    linearColor2: Colors.grey,
                    child: Center(child: Text("Play!")),
                  ):
                  CustomBox(
                    circular: 50,
                    height: 50,
                    linearColor1: _color,
                    linearColor2: _color,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChallengeGame(players: _players,)),),
                    child: Center(child: Text("Play!")),
                  )
                ),
              ),
            ],
          )
        ],
      ),
    );
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
