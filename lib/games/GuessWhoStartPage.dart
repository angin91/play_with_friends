import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:play_with_friends/games/general/GuessWho.dart';
import 'package:play_with_friends/models/custom_icons.dart';
import 'package:play_with_friends/widgets/CustomBox.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Helper.dart';

class GuessWhoStartPage extends StatefulWidget {
  GuessWhoStartPage({Key key}) : super(key: key);

  @override
  _GuessWhoStartPageState createState() => _GuessWhoStartPageState();
}

class _GuessWhoStartPageState extends State<GuessWhoStartPage> {

  Helper helper;
  final Map<String, List> _categories =  {};
  List _listToPlay;
  int _teamPlaying;
  int _teamOnePoints = 0;
  int _teamTwoPoints = 0;
  int _teamThreePoints = 0;
  int _teamFourPoints = 0;
  Future load;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    helper = new Helper();
    load = _loadLists();
    _loadPoints();
  }

  _loadPoints()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _teamOnePoints = (prefs.getInt('teamOnePoints') ?? 0);
      _teamTwoPoints = (prefs.getInt('teamTwoPoints') ?? 0);
      _teamThreePoints = (prefs.getInt('teamThreePoints') ?? 0);
      _teamFourPoints = (prefs.getInt('teamFourPoints') ?? 0);
    });
  }

  _loadLists() async {
    _categories.clear();
    var data = await helper.getFileData("resource/categories/disney_characters_swe");
    _categories.putIfAbsent("Disney", () => data.split("\n"));
    data = await helper.getFileData("resource/categories/countries_swe");
    _categories.putIfAbsent("Länder", () => data.split("\n"));
    data = await helper.getFileData("resource/categories/persons");
    _categories.putIfAbsent("Personer", () => data.split("\n"));
    data = await helper.getFileData("resource/categories/sports_swe");
    _categories.putIfAbsent("Sporter", () => data.split("\n"));
    data = await helper.getFileData("resource/categories/words_swe");
    _categories.putIfAbsent("Ord", () => data.split("\n"));
    data = await helper.getFileData("resource/categories/marvel");
    _categories.putIfAbsent("Marvel", () => data.split("\n"));
    data = await helper.getFileData("resource/categories/jobs_swe");
    _categories.putIfAbsent("Yrken", () => data.split("\n"));
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
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Container(
            color: Colors.black,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          child: Icon(CustomIcons.help, color: Colors.white,),
                          onTap: () => getRule("resource/rules/guess_who_rules_swe"),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FutureBuilder(
                                future: load,
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  return CustomBox(
                                    color: Colors.grey,
                                    child: DropdownButton<List>(
                                      hint: Text("Select category"),
                                      iconEnabledColor: Colors.grey,
                                      dropdownColor: Colors.grey,
                                      items: _categories.map((description, value) {
                                        return MapEntry(
                                            description,
                                            DropdownMenuItem<List>(
                                              value: value,
                                              child: Text(description,),
                                            ));
                                      }).values.toList(),
                                      value: _listToPlay,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _listToPlay = newValue;
                                        });
                                      },
                                    ),
                                  );
                                }
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                            child: Icon(Icons.remove_circle, color: Colors.white,),
                          onTap: () => _resetPoints(),
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
                          child: CustomBox(
                            onTap: () => start(1, _scaffoldKey),
                            color: Colors.blue[400],
                            child: getTeamWidget("Team 1", _teamOnePoints),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomBox(
                            onTap: () => start(2, _scaffoldKey),
                            color: Colors.green[400],
                            child: getTeamWidget("Team 2", _teamTwoPoints),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child:  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomBox(
                            onTap: () => start(3, _scaffoldKey),
                            color: Colors.orange[400],
                            child: getTeamWidget("Team 3", _teamThreePoints),
                          ),
                        ),
                      ),
                      Expanded(
                        child:  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomBox(
                            onTap: () => start(4, _scaffoldKey),
                            color: Colors.teal[400],
                            child: getTeamWidget("Team 4", _teamFourPoints),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  void start(int team, _scaffoldKey) async {
    _teamPlaying = team;
    if(_listToPlay == null || _listToPlay.isEmpty){
      String text = "You need to choose a category!";
      if(_listToPlay != null && _listToPlay.isEmpty){
        text = "No more options in category. Please reset";
      }
      final snackBar = SnackBar(
        content: Text(text),
        backgroundColor: Colors.red,);
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }

    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => GuessWho(list: _listToPlay,)),);

    if(result != null){
      var key = _categories.keys.firstWhere((element) => _categories[element] == _listToPlay, orElse: () => null);
      _categories.update(key, (value) => result[0]);
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

  Widget getTeamWidget(text, points){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: TextStyle(
            color: Colors.brown[400],
            fontSize: 30,
            fontWeight: FontWeight.bold),),
        Text( points.toString(), style: TextStyle(
          color: Colors.brown[400],
          fontSize: 50,
          fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void getRule(url) async {
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
//    Navigator.push(context, MaterialPageRoute(builder: (context) => RulePage(text: text),));
  }
}