import 'package:blocks_puzzle/widgets/block.dart';
import 'package:blocks_puzzle/widgets/game_board.dart';
import 'package:blocks_puzzle/widgets/game_objects.dart';
import 'package:blocks_puzzle/widgets/game_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(BlocksPuzzleApp());
  });
}

class BlocksPuzzleApp extends StatelessWidget {
  GameTimer gameTimer;
  Blocks blocks;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(
        /* floatingActionButton: FloatingActionButton(
            child: Text("Play"),
            onPressed: () {
              gameTimer.start();
            },
          ),*/
          body: _buildGameWidget()),
    );
  }

  Widget _buildGameWidget() {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      color: Colors.black87,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              child: _buildTopSection(),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: _buildGameBoard(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(child: _buildBottomSection()),
          )
        ],
      ),
    );
  }

  GameBoard gameBoard;

  Widget _buildGameBoard() {
    gameBoard = GameBoard(blockPlacedCallback: onBlockPlaced);
    return gameBoard;
  }

  //Top section includes timer, scoreboard
  Widget _buildTopSection() {
    //Build timer
    if (gameTimer == null) {
      gameTimer = GameTimer();
    }
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              child: gameTimer,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
            ),
          )
        ],
      ),
    );
    /*   return Container(
        margin: const EdgeInsets.all(20.0),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            gameTimer,
          ],
        ));*/

    //TODO:Build Scoreboard
  }

  //Bottom section includes game objects i.e. actionable blocks
  Widget _buildBottomSection() {
    //Build game objects
    if (blocks == null) {
      blocks = Blocks(
        blockDroppedCallback: onBlockDropped,
      );
    }
    return blocks;
  }

  void onBlockDropped(
      BlockType blockType, Color blockColor, Offset blockPosition) {
    gameBoard?.onBlockDropped(blockType, blockColor, blockPosition);
  }

  void onBlockPlaced(BlockType blockType) {
    blocks?.onBlockPlaced(blockType);
  }
}
