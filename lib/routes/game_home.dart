import 'dart:async';
import 'dart:math';

import 'package:blocks_puzzle/animations/stars_collection_animation.dart';
import 'package:blocks_puzzle/common/shared_prefs.dart';
import 'package:blocks_puzzle/common/utils.dart';
import 'package:blocks_puzzle/model/game_session.dart';
import 'package:blocks_puzzle/widgets/block.dart';
import 'package:blocks_puzzle/widgets/game_board.dart';
import 'package:blocks_puzzle/widgets/game_objects.dart';
import 'package:blocks_puzzle/widgets/game_over.dart';
import 'package:blocks_puzzle/widgets/game_pause.dart';
import 'package:blocks_puzzle/widgets/game_timer.dart';
import 'package:blocks_puzzle/widgets/play_pause.dart';
import 'package:blocks_puzzle/widgets/score_board.dart';
import 'package:blocks_puzzle/widgets/stars_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GameScreen extends StatelessWidget {
  GameTimer _gameTimer;
  Blocks _gameObjects;
  GameBoard _gameBoard;
  StarsCounter _starsCounter;
  ScoreBoard _scoreBoard;
  PlayPause _playPauseButton;
  int _currentScore = 0;
  int _starsCollected = 0;
  StarsCollectionAnimation _starsCollectionAnimation;

  GameScreen() {
    _gameTimer = GameTimer();
    _playPauseButton = PlayPause(
      onGameStateChanged,
    );

    _starsCounter = StarsCounter();
    _scoreBoard = ScoreBoard();
    _starsCollectionAnimation = StarsCollectionAnimation();
    _buildBottomSection();

    //Start the timer after 400 ms
    Timer.periodic(Duration(milliseconds: 400), (Timer t) => _onTimerTick(t));
    Timer.periodic(
        Duration(milliseconds: 100),
            (Timer t) =>
            _starsCollectionAnimation
                .updateTargetPosition(_starsCounter.getPosition()));
  }

  void _onTimerTick(Timer t) {
    _gameTimer?.start();
    t.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _buildGameWidget(),
      ),
    );
  }

  Widget _buildGameWidget() {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      color: screenBgColor,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: _buildTopSection(),
              ),
              Expanded(
                flex: 3,
                child: _buildGameBoard(),
              ),
              Expanded(
                flex: 1,
                child: _gameObjects,
              ),
            ],
          ),
          Center(child: _starsCollectionAnimation)
        ],
      ),
    );
  }

  Widget _buildGameBoard() {
    _gameBoard = GameBoard(
      blockPlacedCallback: onBlockPlaced,
      outOfBlocksCallback: outOfBlocksCallback,
      rowsClearedCallback: rowsClearedCallback,
    );
    return _gameBoard;
  }

  //Top section includes timer, scoreboard
  Widget _buildTopSection() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _gameTimer,
                _starsCounter,
              ],
            ),
          ),
          Expanded(flex: 1, child: _scoreBoard),
          Expanded(
            flex: 1,
            child: _playPauseButton,
          )
        ],
      ),
    );
  }

  //Bottom section includes game objects i.e. actionable blocks
  Widget _buildBottomSection() {
    if (_gameObjects == null) {
      _gameObjects = Blocks(
        blockDroppedCallback: onBlockDropped,
      );
    }
    return _gameObjects;
  }

  void onBlockDropped(
      BlockType blockType, Color blockColor, Offset blockPosition) {
    _gameBoard?.onBlockDropped(blockType, blockColor, blockPosition);
    _gameBoard?.setAvailableDraggableBlocks(_gameObjects
        ?.getDraggableBlocks()
        ?.where((block) => block != null)
        ?.toList());
  }

  void onBlockPlaced(BlockType blockType) {
    _gameObjects?.onBlockPlaced(blockType);
    _currentScore += getUnitBlocksCount(blockType) * pointsPerBlockUnitPlaced;
    _scoreBoard?.updateScoreboard(_currentScore);
  }

  void outOfBlocksCallback(BuildContext context) {
    _gameTimer?.stop();
    saveSessionStats();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => _createGameOverDialog(context));
  }

  void saveSessionStats() async {
    BlockzSharedPrefs.getInstance().saveSession(GameSession(
        _currentScore,
        _starsCollected,
        _gameTimer?.getTimeDurationInSeconds(),
        DateTime.now().millisecondsSinceEpoch));

    int highestScore = await BlockzSharedPrefs.getInstance().getHighestScore();
    BlockzSharedPrefs.getInstance()
        .saveHighestScore(max(highestScore, _currentScore));

    int totalStars = await BlockzSharedPrefs.getInstance().getTotalStars();
    BlockzSharedPrefs.getInstance()
        .saveTotalStars(max(totalStars, _starsCollected));
  }

  void rowsClearedCallback(int numOfRows) {
    _starsCollected += numOfRows * pointsPerMatchedRow;
    _starsCounter?.updateStars(_starsCollected);
    _starsCollectionAnimation?.showAnimation();
  }

  Widget _createGameOverDialog(BuildContext context) {
    return WillPopScope(
        onWillPop: () {},
        child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: GameOverPopup()));
  }

  void onGameStateChanged(BuildContext context, GameState state) {
    switch (state) {
      case GameState.PAUSE:
        _gameTimer?.pause();
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => _createGamePauseDialog(context));
        break;
      case GameState.PLAY:
        _gameTimer?.start();
        break;
    }
  }

  Widget _createGamePauseDialog(BuildContext context) {
    return WillPopScope(
        onWillPop: () {},
        child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: GamePausePopup(playCallback: _startPlaying)));
  }

  void _startPlaying() {
    _gameTimer?.start();
    _playPauseButton.play();
  }
}
