import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:play_with_friends/games/GuessWhoStartPage.dart';
import 'package:play_with_friends/models/custom_icons.dart';
import 'package:play_with_friends/widgets/CustomBox.dart';
import 'package:play_with_friends/widgets/CustomSelectionBox.dart';
import 'package:styled_text/styled_text.dart';

import '../Helper.dart';

class GuessWhoChooseCategory extends StatefulWidget {
  GuessWhoChooseCategory({Key key}) : super(key: key);

  @override
  _GuessWhoChooseCategoryState createState() => _GuessWhoChooseCategoryState();
}

class _GuessWhoChooseCategoryState extends State<GuessWhoChooseCategory> {
  Helper helper;
  final Map<String, List> _categories = {};
  Color _color = Colors.pink;
  Future load;
  int _selected;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    helper = new Helper();
    load = _loadLists();
  }

  _loadLists() async {
    _categories.clear();
    var data =
        await helper.getFileData("resource/categories/disney_characters_swe");
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

  @override
  Widget build(BuildContext context) {
    var svgPic = SvgPicture.asset(
      "resource/images/guess_who/TopSlider1.svg",
      fit: BoxFit.fitWidth,
    );
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Guess Who"),
        elevation: 0,
        actions: [
          GestureDetector(
            child: Icon(
              CustomIcons.help_circled,
              color: _color,
            ),
            onTap: () => getRule("resource/rules/guess_who_rules_swe"),
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(241, 233, 218, 1),
      body: FutureBuilder(
        future: load,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Column(
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
                  "Select a category",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Container(
                  child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(
                            height: 10,
                          ),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GestureDetector(
                                onTap: () => setState(() {
                                      _selected = index;
                                    }),
                                child: index == _selected
                                    ? CustomSelectionBox(
                                        selected: true,
                                        circular: 10,
                                        height: 60,
                                        color: Colors.white,
                                        selectedColor: _color,
                                        child: Center(
                                            child: Text(
                                          _categories.keys.elementAt(index),
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: _color,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      )
                                    : CustomSelectionBox(
                                        selected: false,
                                        circular: 10,
                                        height: 60,
                                        color: Colors.white,
                                        child: Center(
                                            child: Text(
                                          _categories.keys.elementAt(index),
                                          style: TextStyle(fontSize: 18),
                                        )),
                                      )),
                          )),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _selected != null
                      ? CustomBox(
                          circular: 50,
                          height: 50,
                          linearColor1: Colors.pink[700],
                          linearColor2: Colors.pink[400],
                          child: Center(child: Text("Next", style: TextStyle(color: Colors.white, fontSize: 20),)),
                          onTap: () => changePage(),
                        )
                      : CustomBox(
                          circular: 50,
                          height: 50,
                          linearColor1: Colors.grey,
                          linearColor2: Colors.grey,
                          child: Center(child: Text("Next", style: TextStyle(color: Colors.white, fontSize: 20),)),
                        )
              )
            ],
          );
        },
      ),
    );
  }

  changePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GuessWhoStartPage(list: _categories.values.elementAt(_selected),)),
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
}
