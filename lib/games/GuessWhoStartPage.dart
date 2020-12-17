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
  List<int> _numberTeams = [1,2,3,4];
  int _dropdownTeams;
  int _points = 0;

  @override
  void initState() {
    super.initState();
    helper = new Helper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Guess Who"),
        ),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<int>(
                      hint: Text("No of teams"),
                      value: _dropdownTeams,
                      items: _numberTeams.map((value) {
                        return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _dropdownTeams = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Text(_points.toString()),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      text: "Start",
                      onTap: () => start(_url),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      text: "Rules",
                      onTap: () => getRule("resource/rules/guess_who_rules"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  void start(String url) async {
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
      _points = result[1];
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