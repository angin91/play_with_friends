import 'package:flutter/material.dart';
import 'package:play_with_friends/games/general/GuessWho.dart';
import 'file:///C:/Users/angin/workspace/play_with_friends/lib/games/general/RulePage.dart';
import 'package:play_with_friends/models/CostumButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Helper.dart';

class GuessWhoStartPage extends StatefulWidget {
  GuessWhoStartPage({Key key}) : super(key: key);

  @override
  _GuessWhoStartPageState createState() => _GuessWhoStartPageState();
}

class _GuessWhoStartPageState extends State<GuessWhoStartPage> {

  Helper helper;
  String _ruleText = "";
  final Map<String, List> _categories =  {};
  String _categoryToPlay;
  List _listToPlay;
  String _url;
  int _teamPlaying;
  int _teamOnePoints = 0;
  int _teamTwoPoints = 0;
  int _teamThreePoints = 0;
  int _teamFourPoints = 0;
  Future load;

  @override
  void initState() {
    super.initState();
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
        appBar: AppBar(
          title: Text("Guess Who"),
          actions: [
            IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: () {
                _resetPoints();
              },
            )
          ],
        ),
        body: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                    future: load,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return DropdownButton<List>(
                        hint: Text("Select category"),
                        items: _categories.map((description, value) {
                          return MapEntry(
                              description,
                              DropdownMenuItem<List>(
                                value: value,
                                child: Text(description),
                              ));
                        }).values.toList(),
                        value: _listToPlay,
                        onChanged: (newValue) {
                          setState(() {
                            _listToPlay = newValue;
                          });
                        },
                      );
                    }
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => start(1, _url, _scaffoldKey),
                        child: Container(
                            color: Colors.blue,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Team 1"),
                                Text(_teamOnePoints.toString(), style: TextStyle(fontSize: 40),),
                              ],
                            )
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => start(2, _url, _scaffoldKey),
                        child: Container(
                            color: Colors.green,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Team 2"),
                                Text(_teamTwoPoints.toString(), style: TextStyle(fontSize: 40),),
                              ],
                            )
                        ),
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => start(3, _url, _scaffoldKey),
                        child: Container(
                            color: Colors.orange,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Team 3"),
                                Text(_teamThreePoints.toString(), style: TextStyle(fontSize: 40),),
                              ],
                            )
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => start(4, _url, _scaffoldKey),
                        child: Container(
                            color: Colors.teal,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Team 4"),
                                Text(_teamFourPoints.toString(), style: TextStyle(fontSize: 40),),
                              ],
                            )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                text: "Rules",
                onTap: () => getRule("resource/rules/guess_who_rules"),
              ),
            ),
          ],
        )
    );
  }

  void start(int team, String url, _scaffoldKey) async {
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

  void getRule(url) async {
    var text = await helper.getFileData(url);
    setState(() {
      _ruleText = text;
    });

    Navigator.push(context, MaterialPageRoute(builder: (context) => RulePage(text: _ruleText),));
  }
}