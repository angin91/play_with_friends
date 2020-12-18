import 'package:flutter/material.dart';
import 'package:play_with_friends/games/general/GuessWho.dart';
import 'file:///C:/Users/angin/workspace/play_with_friends/lib/games/general/RulePage.dart';
import 'package:play_with_friends/models/CostumButton.dart';

import '../Helper.dart';

class GuessWhoStartPage extends StatefulWidget {
  GuessWhoStartPage({Key key}) : super(key: key);

  @override
  _GuessWhoStartPageState createState() => _GuessWhoStartPageState();
}

class _GuessWhoStartPageState extends State<GuessWhoStartPage> {

  Helper helper;
  String _ruleText = "";
  final Map<String, String> _categories =  {
    "Allt": "all",
    "Disney": "resource/categories/disney_characters_swe",
    "Länder": "resource/categories/countries_swe",
//    "Gudar/mytologier": "resource/categories/gods",
    "Personer": "resource/categories/persons",
    "Sporter": "resource/categories/sports_swe",
    "Ord": "resource/categories/words_swe"
  };
  String _dropdownTextCategories;
  String _url;
  int _teamPlaying;
  int _teamOnePoints = 0;
  int _teamTwoPoints = 0;
  int _teamThreePoints = 0;
  int _teamFourPoints = 0;

  @override
  void initState() {
    super.initState();
    helper = new Helper();
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Guess Who"),
        ),
        body: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  hint: Text("Select category"),
                  items: _categories.map((description, value) {
                    return MapEntry(
                        description,
                        DropdownMenuItem<String>(
                          value: value,
                          child: Text(description),
                        ));
                  }).values.toList(),
                  value: _dropdownTextCategories,
                  onChanged: (newValue) {
                    setState(() {
                      _dropdownTextCategories = newValue;
                      _url = newValue;
                    });
                  },
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
    if(_dropdownTextCategories == null || _dropdownTextCategories.isEmpty){
      final snackBar = SnackBar(
        content: Text('You need to choose a category!'),
        backgroundColor: Colors.red,);
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }

    var data = "";
    var listOfItems;
    if(url.contains("all")){
      for(var i = 1; i <= _categories.values.length - 1; i++){
        data += await helper.getFileData(_categories.values.toList()[i]) + "\n";
      }
    }else {
      data = await helper.getFileData(url);
    }
    listOfItems = data.split("\n");

    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => GuessWho(list: listOfItems,)),);
    setState(() {
      if(_teamPlaying == 1){_teamOnePoints += result[1];}
      if(_teamPlaying == 2){_teamTwoPoints += result[1];}
      if(_teamPlaying == 3){_teamThreePoints += result[1];}
      if(_teamPlaying == 4){_teamFourPoints += result[1];}
    });
  }

  void getRule(url) async {
    var text = await helper.getFileData(url);
    setState(() {
      _ruleText = text;
    });

    Navigator.push(context, MaterialPageRoute(builder: (context) => RulePage(text: _ruleText),));
  }
}