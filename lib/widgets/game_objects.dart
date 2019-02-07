import 'dart:math';

import 'package:blocks_puzzle/common/utils.dart';
import 'package:blocks_puzzle/widgets/block.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Blocks extends StatefulWidget {
  _BlocksState _blocksState;

  final BlockDroppedCallback blockDroppedCallback;

  Blocks({this.blockDroppedCallback});

  @override
  _BlocksState createState() {
    _blocksState = _BlocksState();
    return _blocksState;
  }

  void onBlockPlaced(BlockType blockType) {
    _blocksState?.onBlockPlaced(blockType);
  }

  List<Block> getDraggableBlocks() {
    return _blocksState?.draggableBlocks;
  }
}

class _BlocksState extends State<Blocks> {
  List<Block> availableBlocks = <Block>[];
  List<Block> draggableBlocks = <Block>[];

  @override
  void initState() {
    super.initState();

    availableBlocks.add(Block(BlockType.SINGLE, Colors.lightGreenAccent,
        blockSize: draggableBlockSize,
        blockDroppedCallback: widget.blockDroppedCallback,
        draggable: true));
    availableBlocks.add(Block(BlockType.DOUBLE, Colors.lightBlueAccent,
        blockSize: draggableBlockSize,
        blockDroppedCallback: widget.blockDroppedCallback,
        draggable: true));
    availableBlocks.add(Block(BlockType.LINE_HORIZONTAL, Colors.redAccent,
        blockSize: draggableBlockSize,
        blockDroppedCallback: widget.blockDroppedCallback,
        draggable: true));
    availableBlocks.add(Block(BlockType.LINE_VERTICAL, Colors.brown,
        blockSize: draggableBlockSize,
        blockDroppedCallback: widget.blockDroppedCallback,
        draggable: true));
    availableBlocks.add(Block(BlockType.SQUARE, Colors.orangeAccent,
        blockSize: draggableBlockSize,
        blockDroppedCallback: widget.blockDroppedCallback,
        draggable: true));
    availableBlocks.add(Block(BlockType.TYPE_T, Colors.indigoAccent,
        blockSize: draggableBlockSize,
        blockDroppedCallback: widget.blockDroppedCallback,
        draggable: true));
    availableBlocks.add(Block(BlockType.TYPE_L, Colors.pinkAccent,
        blockSize: draggableBlockSize,
        blockDroppedCallback: widget.blockDroppedCallback,
        draggable: true));
    availableBlocks.add(Block(BlockType.MIRRORED_L, Colors.purpleAccent,
        blockSize: draggableBlockSize,
        blockDroppedCallback: widget.blockDroppedCallback,
        draggable: true));
    availableBlocks.add(Block(BlockType.TYPE_Z, Colors.amberAccent,
        blockSize: draggableBlockSize,
        blockDroppedCallback: widget.blockDroppedCallback,
        draggable: true));
    availableBlocks.add(Block(BlockType.TYPE_S, Colors.tealAccent,
        blockSize: draggableBlockSize,
        blockDroppedCallback: widget.blockDroppedCallback,
        draggable: true));

    populateDraggableBlocks();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
                alignment: Alignment.center, child: draggableBlocks[0]),
          ),
          Expanded(
            flex: 1,
            child: Container(
                alignment: Alignment.center, child: draggableBlocks[1]),
          ),
          Expanded(
            flex: 1,
            child: Container(
                alignment: Alignment.center, child: draggableBlocks[2]),
          )
        ],
      ),
    );
  }

  void onBlockPlaced(BlockType blockType) {
    draggableBlocks[draggableBlocks.indexWhere(
        (block) => block != null && block.blockType == blockType)] = null;

    //This means we have at least a block which can be placed
    if (!draggableBlocks.any((block) => block != null)) {
      populateDraggableBlocks();
    }
    setState(() {});
  }

  void populateDraggableBlocks() {
    availableBlocks.shuffle(Random());
    draggableBlocks.clear();
    for (int index = 0; index < 3; index++) {
      draggableBlocks.add(availableBlocks[index]);
    }
  }
}
