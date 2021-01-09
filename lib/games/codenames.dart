import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:play_with_friends/helper.dart';
import 'package:play_with_friends/models/custom_icons.dart';
import 'package:play_with_friends/widgets/custom_box.dart';
import 'package:play_with_friends/widgets/custom_selection_box.dart';
import 'package:flip_card/flip_card.dart';
import 'package:styled_text/styled_text.dart';
import "dart:math";
import 'package:play_with_friends/models/codenames_info.dart';

class Codenames extends StatefulWidget {
  Codenames({Key key,}) : super(key: key);

  @override
  _CodenamesState createState() => _CodenamesState();
}

class _CodenamesState extends State<Codenames> with WidgetsBindingObserver {
  Helper helper;
  final _random = new Random();
  Color _color = Colors.teal;
  List<CodenamesInfo> things = new List<CodenamesInfo>();
  List<CodenamesInfo> blueSolution = new List<CodenamesInfo>();
  List<CodenamesInfo> redSolution = new List<CodenamesInfo>();
  CodenamesInfo assassin;
  Future load;

  @override
  void initState() {
    helper = new Helper();
    load = setThingsList();
    super.initState();
  }

  setThingsList() async {
    var data = await helper.getFileData("resource/codenames/words");
    List<String> words = data.split("\n");
    words.shuffle(_random);

    setState(() {
      for(int i  = 0; i < 20; i++){
        if(i == 0 || i == 1 || i == 2 || i == 3){
          var codenamesInfo = CodenamesInfo(words[i], CodenamesTag.red);
          things.add(codenamesInfo);
          redSolution.add(codenamesInfo);
        }else if(i == 4 || i == 5 || i == 6 || i == 7 || i == 8){
          var codenamesInfo = CodenamesInfo(words[i], CodenamesTag.blue);
          things.add(codenamesInfo);
          blueSolution.add(codenamesInfo);
        }else if(i == 9){
          var codenamesInfo = CodenamesInfo(words[i], CodenamesTag.assassin);
          things.add(codenamesInfo);
          assassin = codenamesInfo;
        } else {
          things.add(CodenamesInfo(words[i], CodenamesTag.none));
        }
      }
      things.shuffle(_random);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Codenames"),
        elevation: 0,
        actions: [
          GestureDetector(
            child: Icon(
              CustomIcons.help_circled,
              color: _color,
            ),
            onTap: () => getRule("resource/rules/codenames_rules_swe"),
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(241, 233, 218, 1),
      body: FutureBuilder(
        future: load,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        buildTile(0),
                        buildTile(1),
                        buildTile(2),
                        buildTile(3)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        buildTile(4),
                        buildTile(5),
                        buildTile(6),
                        buildTile(7)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        buildTile(8),
                        buildTile(9),
                        buildTile(10),
                        buildTile(11)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        buildTile(12),
                        buildTile(13),
                        buildTile(14),
                        buildTile(15)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        buildTile(16),
                        buildTile(17),
                        buildTile(18),
                        buildTile(19)
                      ],
                    ),
                  ),
                  CustomBox(
                    height: 70,
                    circular: 10,
                    linearColor1: _color,
                    linearColor2: _color,
                    child: Center(child: Text("Show solution"),),
                    onTap: () {
                      showSolution();
                    },
                  ),
                ],
              ),
            );
          } else{
            return Container();
          }
        }
      ),
    );
  }

  Widget buildTile(int index) {
    return Expanded(
      child: FlipCard(
        front: CustomSelectionBox(
          circular: 5,
          color: Colors.white,
          selectedColor: _color,
          selected: true,
          child: Center(
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  things[index].word,
                  textAlign: TextAlign.center,
                ),
              )
          ),
        ),
        back: CustomSelectionBox(
          circular: 5,
          color: things[index].getColor(),
          selectedColor: _color,
          selected: true,
        ),
      ),
    );
  }

  void showSolution(){
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
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text("Blue", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.blue),),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(blueSolution[0].word),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(blueSolution[1].word),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(blueSolution[2].word),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(blueSolution[3].word),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(blueSolution[4].word),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text("Red", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.red),),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(redSolution[0].word),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(redSolution[1].word),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(redSolution[2].word),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(redSolution[3].word),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Assassin", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.grey),),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(assassin.word),
                          ),
                        ],
                      )
                    ),
                  ),
                ],
              )),
        ),
      );
    }, isScrollControlled: true);
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
              child: ListView(
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
