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
          appBar: AppBar(
            title: Text(
              "Blocks Puzzle",
              style: TextStyle(color: Colors.white),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Text("Play"),
            onPressed: () {
              gameTimer.start();
            },
          ),
          body: _buildGameWidget()),
    );
  }

  Widget _buildGameWidget() {
    return Container(
        color: Colors.black87,
        /*child: Container(child:Row(
            children: [_buildTopSection(),_buildGameBoard(),_buildBottomSection()],
          ),
       ));*/
        child: Flex(direction: Axis.vertical, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [_buildTopSection()],
          ),
          Flexible(
            fit: FlexFit.loose,
            child: _buildGameBoard(),
          ),
          _buildBottomSection(),
        ]));
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
        margin: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            gameTimer,
          ],
        ));

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
    gameBoard.onBlockDropped(blockType, blockColor, blockPosition);
  }

  void onBlockPlaced(BlockType blockType) {
    blocks?.onBlockPlaced(blockType);
  }
}
