import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:play_with_friends/games/general/GuessWho.dart';
import 'package:play_with_friends/models/custom_icons.dart';
import 'package:play_with_friends/widgets/CustomBox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:play_with_friends/widgets/CustomSelectionBox.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Helper.dart';

class GuessWhoStartPage extends StatefulWidget {
  GuessWhoStartPage({Key key, this.list}) : super(key: key);

  final List list;

  @override
  _GuessWhoStartPageState createState() => _GuessWhoStartPageState();
}

class _GuessWhoStartPageState extends State<GuessWhoStartPage> {

  Helper helper;
  List _listToPlay;
  int _teamPlaying;
  int _teamOnePoints = 0;
  int _teamTwoPoints = 0;
  int _teamThreePoints = 0;
  int _teamFourPoints = 0;
  Future load;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    helper = new Helper();
    _listToPlay = widget.list;
    _loadPoints();
    super.initState();
  }

  _loadPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _teamOnePoints = (prefs.getInt('teamOnePoints') ?? 0);
      _teamTwoPoints = (prefs.getInt('teamTwoPoints') ?? 0);
      _teamThreePoints = (prefs.getInt('teamThreePoints') ?? 0);
      _teamFourPoints = (prefs.getInt('teamFourPoints') ?? 0);
    });
  }

  _resetPoints() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.remove('teamOnePoints');
      _teamOnePoints = 0;
      prefs.remove('teamTwoPoints');
      _teamTwoPoints = 0;
      prefs.remove('teamThreePoints');
      _teamThreePoints = 0;
      prefs.remove('teamFourPoints');
      _teamFourPoints = 0;
    });
  }


  @override
  Widget build(BuildContext context) {
    var svgPic = SvgPicture.asset(
      "resource/images/guess_who/TopSlider2.svg",
      fit: BoxFit.fitWidth,
    );
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text("Guess Who"),
          elevation: 0,
          actions: [
            GestureDetector(
              child: Icon(
                CustomIcons.help_circled,
                color: Colors.pink,
              ),
              onTap: () => getRule("resource/rules/guess_who_rules_swe"),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              child: Icon(Icons.remove_circle, color: Colors.pink,),
              onTap: () => _resetPoints(),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(229, 229, 229, 1),
        body: Container(
          child: Column(
            children: [
              Container(
                height: width * 0.12,
                width: width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: svgPic,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  "Select a team",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: getTeamWidget(1, _teamOnePoints),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: getTeamWidget(2, _teamTwoPoints),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: getTeamWidget(3, _teamThreePoints),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: getTeamWidget(4, _teamFourPoints),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _teamPlaying != null
                      ? CustomBox(
                    circular: 50,
                    height: 50,
                    linearColor1: Colors.pink[700],
                    linearColor2: Colors.pink[400],
                    child: Center(child: Text("Play", style: TextStyle(color: Colors.white, fontSize: 20),)),
                    onTap: () => start(),
                  )
                      : CustomBox(
                    circular: 50,
                    height: 50,
                    linearColor1: Colors.grey,
                    linearColor2: Colors.grey,
                    child: Center(child: Text("Play", style: TextStyle(color: Colors.white, fontSize: 20),)),
                  )
              )
            ],
          ),
        )
    );
  }

  void start() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => GuessWho(list: _listToPlay,)),);

    if(result != null){
      _listToPlay = result[0];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        if(_teamPlaying == 1){
          _teamOnePoints = (prefs.getInt('teamOnePoints') ?? 0) + result[1];
          prefs.setInt('teamOnePoints', _teamOnePoints);
        }
        if(_teamPlaying == 2){
          _teamTwoPoints = (prefs.getInt('teamTwoPoints') ?? 0) + result[1];
          prefs.setInt('teamTwoPoints', _teamTwoPoints);
        }
        if(_teamPlaying == 3){
          _teamThreePoints = (prefs.getInt('teamThreePoints') ?? 0) + result[1];
          prefs.setInt('teamThreePoints', _teamThreePoints);
        }
        if(_teamPlaying == 4){
          _teamFourPoints = (prefs.getInt('teamFourPoints') ?? 0) + result[1];
          prefs.setInt('teamFourPoints', _teamFourPoints);
        }
      });
    }
  }

  Widget getTeamWidget(int teamPlaying, int points){
    if(_teamPlaying == teamPlaying){
      return CustomSelectionBox(
        color: Colors.white,
        selectedColor: Colors.pink,
        selected: true,
        circular: 30,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Team " + teamPlaying.toString(), style: TextStyle(
                    fontSize: 30, color: Colors.pink),),
                Text(points.toString(), style: TextStyle(
                  fontSize: 50, color: Colors.pink),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return CustomSelectionBox(
      color: Colors.white,
      circular: 30,
      onTap: () => setState(() {
        _teamPlaying = teamPlaying;
      }),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Team " + teamPlaying.toString(), style: TextStyle(
                  fontSize: 30),),
              Text(points.toString(), style: TextStyle(
                fontSize: 50,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getRule(url) async {
    var text = await helper.getFileData(url);

    showModalBottomSheet(context: context, builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
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
        ),
      );
    }, isScrollControlled: true);
  }
}