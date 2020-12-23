import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:flutter/services.dart';
import "dart:math";
import 'package:aeyrium_sensor/aeyrium_sensor.dart';
import 'package:play_with_friends/widgets/CostumTimer.dart';
import 'package:wakelock/wakelock.dart';

class AlphabetGame extends StatefulWidget {
  AlphabetGame({Key key}) : super(key: key);

  @override
  _AlphabetGameState createState() => _AlphabetGameState();
}

class _AlphabetGameState extends State<AlphabetGame> with WidgetsBindingObserver {
  FullScreen fullscreen;
  final _random = new Random();

  List gameList = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "R", "S", "T", "U", "V"];
  int _currentIndex;

  String _text = "";
  Color _color = Colors.blue;
  int _points = 0;
  bool _started = false;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    fullscreen = new FullScreen();
    Wakelock.enable();
    enterFullScreen(FullScreenMode.EMERSIVE_STICKY);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    WidgetsBinding.instance.addObserver(this);

    start();
  }

  start(){
    setRandomText();
  }

  void enterFullScreen(FullScreenMode fullScreenMode) async {
    await fullscreen.enterFullScreen(fullScreenMode);
  }

  void exitFullScreen() async {
    await fullscreen.exitFullScreen();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onDoubleTap: () => Navigator.pop(context),
        child: Scaffold(
          body: Container(
            color: _color,
            child: _started ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CostumTimer(
                    time: 3,
                    onExpire: () => _finish(),
                    rerunOnExpire: true,
                    style: TextStyle(fontSize: 40),),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      _text,
                      style: TextStyle(fontSize: 60),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ) : Row(
              children: [
                Expanded(
                  child: Center(
                    child: CostumTimer(
                      time: 3,
                      style: TextStyle(fontSize: 120),
                      onExpire: () => setState(() {
                        _started = true;
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  setRandomText() {
    _currentIndex = _random.nextInt(gameList.length);
    String text = gameList[_currentIndex];
    setState(() {
      _text = text;
    });
  }

  _finish(){
    setRandomText();
  }

  @override
  void dispose() {
    super.dispose();
    Wakelock.disable();
    exitFullScreen();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.paused){
    }
    if(state == AppLifecycleState.resumed){
      enterFullScreen(FullScreenMode.EMERSIVE_STICKY);
    }
    super.didChangeAppLifecycleState(state);
  }
}
