import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:play_with_friends/models/Song.dart';
import 'package:play_with_friends/models/custom_icons.dart';
import 'package:play_with_friends/widgets/CustomBox.dart';
import 'package:styled_text/styled_text.dart';
import 'package:wakelock/wakelock.dart';
import 'package:play_with_friends/Helper.dart';

class SingALong extends StatefulWidget {
  SingALong({Key key, @required this.song}) : super(key: key);

  final Song song;

  @override
  _SingALongState createState() => _SingALongState();
}

class _SingALongState extends State<SingALong> {
  List<Song> songs = new List();
  Song currentSong;
  Helper helper;
  Color _color = Colors.purple;
  final _random = new Random();
  Future load;

  setSongList() async {
    var s = await helper.getFileData("resource/songs/song_list");
    var jsonSongs = jsonDecode(s)['songs'] as List;
    songs = jsonSongs.map((jsonSong) => Song.fromJson(jsonSong)).toList();
    setRandomSong();
  }

  setRandomSong() {
    var nextInt = _random.nextInt(songs.length);
    setState(() {
      currentSong = songs[nextInt];
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    helper = new Helper();
    load = setSongList();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    Wakelock.enable();
  }

  Song getRandomSong() {
    var nextInt = _random.nextInt(songs.length);
    return songs[nextInt];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(241, 233, 218, 1),
      appBar: AppBar(
        title: Text("Sing-a-Long"),
        elevation: 0,
        actions: [
          GestureDetector(
            child: Icon(
              CustomIcons.help_circled,
              color: _color,
            ),
            onTap: () => getRule("resource/rules/sing_a_long_rules_swe"),
          ),
        ],
      ),
      body: FutureBuilder(
          future: load,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              if(songs.length == 1){
                return GestureDetector(
                    onTap: () => setSongList(),
                    child: Center(child: Text("Reset deck", style: TextStyle(fontSize: 25),))
                );
              }
              return Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "\"" + currentSong.title + "\" by " + currentSong.artist,
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Container(
                          child: FlipCard(
                            front: CustomBox(
                              circular: 20,
                              linearColor1: Colors.purple[800],
                              linearColor2: Colors.purple[400],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Text(
                                          "Song",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white
                                          ),
                                          textAlign: TextAlign.center,
                                        )),
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Text(
                                          currentSong.lyric,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            back: CustomBox(
                              circular: 20,
                              linearColor1: Colors.purple[800],
                              linearColor2: Colors.purple[400],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Text(
                                          "Solution",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white
                                          ),
                                          textAlign: TextAlign.center,
                                        )),
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Text(
                                          currentSong.solution,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomBox(
                        height: 50,
                        circular: 50,
                        linearColor1: Colors.purple[800],
                        linearColor2: Colors.purple[400],
                        onTap: () {
                          songs.remove(currentSong);
                          setRandomSong();
                        },
                        child: Center(child: Text("Next", style: TextStyle(color: Colors.white),)),
                      ),
                    )
                  ],
                ),
              );
            }
            return Container();
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Wakelock.disable();
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
