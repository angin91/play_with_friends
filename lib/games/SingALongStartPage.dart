import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:play_with_friends/games/general/RulePage.dart';
import 'package:play_with_friends/models/Song.dart';
import 'package:play_with_friends/widgets/CustomButton.dart';

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
  List<Song> songs;
  final _random = new Random();

  @override
  void initState() {
    super.initState();
    helper = new Helper();
    setSongList();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  setSongList() async {
    var s = await helper.getFileData("resource/songs/song_list");
    var jsonSongs = jsonDecode(s)['songs'] as List;
    songs = jsonSongs.map((jsonSong) => Song.fromJson(jsonSong)).toList();
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => SingALong(song: getRandomSong())));
  }

  getRandomSong(){
    var nextInt = _random.nextInt(songs.length);
    return songs[nextInt];

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
