import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// This widget is used to show the timer as a digital clock or as a countdown
class SessionTimer extends StatefulWidget {
  Key key;
  final bool countDown;
  final int time;

  _SessionTimerState _sessionTimerState;

  SessionTimer({this.key, this.countDown = true, this.time = 0});

  void stopTimer() {
    _sessionTimerState._stopTimer();
  }

  void startTimer() {
    _sessionTimerState._startTimer();
  }

  @override
  State<StatefulWidget> createState() {
    _sessionTimerState = _SessionTimerState();
    return _sessionTimerState;
  }
}

class _SessionTimerState extends State<SessionTimer>
    with WidgetsBindingObserver {
  num _durationInSeconds;
  var _timer;
  TimerState _timerState;

  @override
  void initState() {
    super.initState();
    _durationInSeconds = widget.time;
    WidgetsBinding.instance.addObserver(this);
    _startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _stopTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(state);

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _timerState = TimerState.PAUSED;
      _stopTimer();
    } else if (state == AppLifecycleState.resumed) {
      _timerState = TimerState.RESUMED;
      _startTimer();
    }
  }

  void _startTimer() {
    _timerState = TimerState.RUNNING;
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _onTimerTick(t));
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _createTimerView();
  }

  void _onTimerTick(Timer timer) {
    if (_timerState != TimerState.PAUSED) {
      widget.countDown ? max(0, --_durationInSeconds) : ++_durationInSeconds;
      if (_durationInSeconds < 0) {
        _stopTimer();
      } else {
        setState(() {});
      }
    }
  }

  Widget _createTimerView() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.white, border: Border.all(color: Colors.red)),
      child: Text(
        _getFormattedTime(),
        style: TextStyle(
            color: Colors.green,
            fontSize: 16.0,
            fontStyle: FontStyle.normal,
            fontFamily: 'sans-serif-medium'),
      ),
    );
  }

  String _getFormattedTime() {
    //widget.displayFormat;//TODO
    print("Duration:: $_durationInSeconds");
    int minutes;
    int hours;
    hours = _durationInSeconds ~/ 3600;
    minutes = _durationInSeconds ~/ 60;
    minutes = minutes % 60;
    return "$hours: $minutes:$_durationInSeconds";
  }
}

enum TimerState { RUNNING, PAUSED, RESUMED }
