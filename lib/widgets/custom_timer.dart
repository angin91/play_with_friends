import 'package:flutter/material.dart';
import 'dart:async';

class CustomTimer extends StatefulWidget {
  CustomTimer({Key key, @required this.time, this.onExpire, this.style, this.rerunOnExpire = false, this.onTick}) : super(key: key);

  final int time;
  final Function onExpire;
  final TextStyle style;
  final bool rerunOnExpire;
  final Function onTick;

  @override
  _CustomTimerState createState() => _CustomTimerState();
}

class _CustomTimerState extends State<CustomTimer> with WidgetsBindingObserver {
  Timer _timer;
  int _start;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _start = widget.time;
    startTimer();
    WidgetsBinding.instance.addObserver(this);
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            if(!widget.rerunOnExpire){
              timer.cancel();
            }else{
              setState(() {
                _start = widget.time;
              });
            }
            if(widget.onExpire != null) {
              widget.onExpire();
            }
          });
        } else {
          if(widget.onTick != null){
            widget.onTick();
          }
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Text((_start/60).floor().toString().padLeft(2, '0') + ":" + (_start%60).floor().toString().padLeft(2, '0'), style: widget.style,);
  }

  void pauseTimer() {
    if (_timer != null) _timer.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.paused){
      pauseTimer();
    }
    if(state == AppLifecycleState.resumed){
      startTimer();
    }
    super.didChangeAppLifecycleState(state);
  }
}
