import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "dart:math";
import 'package:aeyrium_sensor/aeyrium_sensor.dart';
import 'package:play_with_friends/widgets/CustomTimer.dart';
import 'package:wakelock/wakelock.dart';

class GuessWho extends StatefulWidget {
  GuessWho({Key key, this.list}) : super(key: key);

  final List<String> list;

  @override
  _GuessWhoState createState() => _GuessWhoState();
}

class _GuessWhoState extends State<GuessWho> with WidgetsBindingObserver {
  final _random = new Random();

  List gameList;
  int _currentIndex;

  String _text = "";
  Color _color = Colors.blue;
  bool _waiting = true;
  int _points = 0;
  bool _started = false;

  StreamSubscription<dynamic> _streamSubscriptions;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    gameList = widget.list;
    Wakelock.enable();
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    WidgetsBinding.instance.addObserver(this);

    start();
  }

  start(){
    setRandomText();
    _streamSubscriptions = AeyriumSensor.sensorEvents.listen((event) {
      _passOrGood(event);
    });
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
                CustomTimer(
                  time: 60,
                  onExpire: () => _finish(),
                  style: TextStyle(fontSize: 40),),
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
                    child: CustomTimer(
                      time: 3,
                      style: TextStyle(fontSize: 120),
                      onExpire: () => setState(() {
                        _started = true;
                        _waiting = false;
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
    var newText;
    if (text.startsWith("(")) {
      newText = text.substring(0, text.indexOf(")") + 1) + "\n";
      newText += text.substring(text.indexOf(")") + 2);
      _text = newText;
    } else {
      _text = text;
    }
  }

  _passOrGood(event){
    if (event.pitch > 0.7 && !_waiting) {
      setState(() {
        _text = "";
        _color = Colors.green;
        _waiting = true;
        _points++;
        gameList.removeAt(_currentIndex);
        if(gameList.length < 1){
          _finish();
        }
        Future.delayed(
            const Duration(seconds: 2),
                () => setState(() {
              setRandomText();
              _color = Colors.blue;
              _waiting = false;
            }));
      });
    }
    if (event.pitch < -1.0 && !_waiting) {
      setState(() {
        _text = "";
        _color = Colors.red;
        _waiting = true;
        _points--;
        gameList.removeAt(_currentIndex);
        if(gameList.length < 1){
          _finish();
        }
        Future.delayed(
            const Duration(seconds: 2),
                () => setState(() {
              setRandomText();
              _color = Colors.blue;
              _waiting = false;
            }));
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    Wakelock.disable();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    if (_streamSubscriptions != null) {
      _streamSubscriptions.cancel();
    }
    WidgetsBinding.instance.removeObserver(this);
  }

  _finish(){
    Navigator.pop(context, [gameList, _points]);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.paused){
    }
    if(state == AppLifecycleState.resumed){
      SystemChrome.setEnabledSystemUIOverlays([]);
    }
    super.didChangeAppLifecycleState(state);
  }
}
