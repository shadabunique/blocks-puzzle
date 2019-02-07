import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StarsCounter extends StatefulWidget {
  _StarsCounterState _starsCounterState;

  @override
  State<StatefulWidget> createState() {
    _starsCounterState = _StarsCounterState();
    return _starsCounterState;
  }

  void updateStars(int starsCount) {
    _starsCounterState?.updateStars(starsCount);
  }
}

class _StarsCounterState extends State<StarsCounter> {
  int _starsCount = 0;

  @override
  Widget build(BuildContext context) {
    return _buildStarsCounter();
  }

  Widget _buildStarsCounter() {
    return Container(
        margin: EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.orangeAccent),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: SvgPicture.asset(
                    'assets/images/ic_star.svg',
                    width: 28.0,
                    height: 28.0,
                  )),
              Text(
                '$_starsCount',
                style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 20.0,
                    fontFamily: 'Fighting Spirit'),
              ),
            ],
          ),
        ));
  }

  void updateStars(int starsCount) {
    setState(() {
      _starsCount = starsCount;
    });
  }
}
