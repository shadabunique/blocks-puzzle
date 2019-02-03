import 'dart:ui';

import 'package:blocks_puzzle/widgets/block.dart';
import 'package:flutter/material.dart';

const Color screenBgColor = Colors.black87;
const Color emptyCellColor = Colors.white70;
const double draggableBlockSize = 30.0;
const double blockUnitSize = 35.0;
const double blockUnitSizeWithPadding = blockUnitSize + 2.0;
const int pointsPerMatchedRow = 10;
const int pointsPerBlockUnitPlaced = 1;

typedef BlockPlacedCallback = void Function(BlockType blockType);
typedef OutOfBlocksCallback = void Function();
typedef RowsClearedCallback = void Function(int numOfLines);

int getUnitBlocksCount(BlockType blockType) {
  switch (blockType) {
    case BlockType.SINGLE:
      return 1;
    case BlockType.DOUBLE:
      return 2;
    case BlockType.LINE_HORIZONTAL:
    case BlockType.LINE_VERTICAL:
      return 3;
    case BlockType.SQUARE:
    case BlockType.TYPE_L:
    case BlockType.MIRRORED_L:
    case BlockType.TYPE_Z:
    case BlockType.TYPE_S:
      return 4;
    case BlockType.TYPE_T:
      return 5;
    default:
      return 0;
  }
}
