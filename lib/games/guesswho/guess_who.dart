import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "dart:math";
import 'package:aeyrium_sensor/aeyrium_sensor.dart';
import 'package:play_with_friends/widgets/custom_timer.dart';
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
  Color _color = const Color.fromRGBO(217, 3, 104, 1);
  bool _waiting = true;
  int _points = 0;
  bool _started = false;
  double _progress = 0;

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
          backgroundColor: Colors.white,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end:
                Alignment(0.9, 0.0), // 10% of the width, so there are ten blinds.
                colors: [
                  _color,
                  _color.withOpacity(0.5)
                ],
              )
            ),
            child: _started ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
                  child: LinearProgressIndicator(
                    backgroundColor: const Color.fromRGBO(178, 1, 85, 1),
                    value: _progress,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 20),
                      child: CustomTimer(
                        time: 60,
                        onExpire: () => _finish(),
                        onTick: () {
                          setState(() {
                            _progress = _progress + (1/60);
                          });
                        },
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      _text,
                      style: TextStyle(fontSize: 60, color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, left: 20),
                      child: Text(_points.toString() + " p", style: TextStyle(fontSize: 40, color: Colors.white)),
                    ),
                    Spacer()
                  ],
                )
              ],
            ) : Row(
              children: [
                Expanded(
                  child: Center(
                    child: CustomTimer(
                      time: 3,
                      style: TextStyle(fontSize: 120, color: Colors.white),
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
        _text = "Correct";
        _color = const Color.fromRGBO(33, 142, 51, 1);
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
              _color = const Color.fromRGBO(217, 3, 104, 1);
              _waiting = false;
            }));
      });
    }
    if (event.pitch < -1.0 && !_waiting) {
      setState(() {
        _text = "Wrong";
        _color = const Color.fromRGBO(224, 40, 0, 1);
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
              _color = const Color.fromRGBO(217, 3, 104, 1);
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
