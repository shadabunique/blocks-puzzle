import 'package:blocks_puzzle/widgets/digital_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

///Timer that shows up the game progress
class GameTimer extends StatefulWidget {
  _GameTimerState _gameTimerState;

  GameTimer({Key key}) : super(key: key);

  void start() {
    _gameTimerState._digitalTimer?.startTimer();
  }

  void stop() {
    _gameTimerState._digitalTimer?.stopTimer();
  }

  void pause() {
    _gameTimerState._digitalTimer?.pauseTimer();
  }

  @override
  _GameTimerState createState() {
    _gameTimerState = _GameTimerState();
    return _gameTimerState;
  }
}

class _GameTimerState extends State<GameTimer> with WidgetsBindingObserver {
  DigitalTimer _digitalTimer;
  int _hour = 0;
  int _minute = 0;
  int _second = 0;

  @override
  void initState() {
    _digitalTimer = DigitalTimer(
      countDown: true,
      time: 6,
      timeUpdatedCallback: onTimeUpdated,
      countDownCompleted: onCountDownCompleted,
    );
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _digitalTimer?.stopTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _digitalTimer.pauseTimer();
    } else if (state == AppLifecycleState.resumed) {
      _digitalTimer?.startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Text(
        getFormattedTime(),
        style: TextStyle(
            color: Colors.green,
            fontSize: 16.0,
            fontStyle: FontStyle.normal,
            fontFamily: 'sans-serif-medium'),
      ),
    );
  }

  String getFormattedTime() {
    return "$_hour:$_minute:$_second";
  }

  void onTimeUpdated(Time updatedTime) {
    this._hour = updatedTime.hour;
    this._minute = updatedTime.minute;
    this._second = updatedTime.second;
    setState(() {});
  }

  void onCountDownCompleted() {
  }
}
