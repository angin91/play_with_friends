import 'package:flutter/material.dart';
import 'dart:async';

class CostumTimer extends StatefulWidget {
  CostumTimer({Key key, @required this.time, this.onExpire, this.style}) : super(key: key);

  final int time;
  final Function onExpire;
  final TextStyle style;

  @override
  _CostumTimerState createState() => _CostumTimerState();
}

class _CostumTimerState extends State<CostumTimer> with WidgetsBindingObserver {
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
            timer.cancel();
            if(widget.onExpire != null) {
              widget.onExpire();
            }
          });
        } else {
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
    return Text("$_start", style: widget.style,);
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
