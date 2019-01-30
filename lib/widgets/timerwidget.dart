import 'dart:async';
import 'dart:math';

import 'package:blocks_puzzle/widgets/digital_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// This widget is used to show the timer as a timer or as a countdown
class TimerWidget {
  final bool countDown;
  final int time;
  final TimeUpdatedCallback timeUpdatedCallback;
  final VoidCallback countDownCompleted;
  int _durationInSeconds;
  Timer _timer;
  TimerState _timerState;

  TimerWidget(
      {Key key,
      @required this.timeUpdatedCallback,
      this.countDown = true,
      this.time = 0,
      this.countDownCompleted})
      : assert(timeUpdatedCallback != null);

  void startTimer() {
    this.timeUpdatedCallback(Time(time ~/ 3600, (time ~/ 60) % 60, time % 60));
    _durationInSeconds = time;
    _timerState = TimerState.RUNNING;
    if (_timer == null) {
      _timer =
          Timer.periodic(Duration(seconds: 1), (Timer t) => _onTimerTick(t));
    }
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _onTimerTick(Timer timer) {
    print(_durationInSeconds);
    if (_timerState != TimerState.PAUSED) {
      this.countDown ? max(0, --_durationInSeconds) : ++_durationInSeconds;
      if (_durationInSeconds < 0) {
        stopTimer();
        if (this.countDownCompleted != null) {
          this.countDownCompleted();
        }
      } else {
        this.timeUpdatedCallback(Time(_durationInSeconds ~/ 3600,
            (_durationInSeconds ~/ 60) % 60, _durationInSeconds % 60));
      }
    }
  }
}
