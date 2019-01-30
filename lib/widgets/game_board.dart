import 'dart:math';

import 'package:blocks_puzzle/widgets/block.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const double blockUnitSizeWithPadding = blockUnitSize + 2.0;
const double margin = 8.0;
const Color emptyCellColor = Colors.white70;

typedef BlockPlacedCallback = void Function(BlockType blockType);

class GameBoard extends StatefulWidget {
  _GameBoardState _gameBoardState;

  final BlockPlacedCallback blockPlacedCallback;

  GameBoard({this.blockPlacedCallback});

  @override
  _GameBoardState createState() {
    _gameBoardState = _GameBoardState(this.blockPlacedCallback);
    return _gameBoardState;
  }

  void onBlockDropped(
      BlockType blockType, Color blockColor, Offset blockPosition) {
    _gameBoardState?.onBlockDropped(blockType, blockColor, blockPosition);
  }
}

class _GameBoardState extends State<GameBoard> {
  int numOfColumns;
  BlockType blockType;
  Color blockColor;
  Offset blockPosition;
  List<Block> cells = <Block>[];
  List<Color> cellColorsList = <Color>[];
  List<int> cellsToFill = <int>[];
  List<int> cellsToClear = <int>[];

  final BlockPlacedCallback _blockPlacedCallback;

  _GameBoardState(this._blockPlacedCallback);

  void onBlockDropped(
      BlockType blockType, Color blockColor, Offset blockPosition) {
    cellsToFill.clear();
    cellsToClear.clear();
    this.blockType = blockType;
    this.blockColor = blockColor;
    this.blockPosition = blockPosition;

    //Step 1: Find the grid block positions and place the dropped block if possible
    //Step 2: Add a new draggable block at the bottom
    //Step 3: Uncolor the filled lines horizontally and vertically
    //Step 4: Check if any of the stacked draggable blocks can be fit on the grid. if not finish the game
    int numOfChildBlocks = getUnitBlocksCount(blockType);
    computeFillableGridBlockPositions(
        numOfChildBlocks, blockType, blockPosition);

    if (cellsToFill.length == numOfChildBlocks) {
      for (int index in cellsToFill) {
        cellColorsList[index] = blockColor;
      }

      if (_blockPlacedCallback != null) {
        _blockPlacedCallback(blockType);
      }
      setState(() {});
      Future.delayed(const Duration(milliseconds: 600), clearFilledRows);
    }
  }

  void clearFilledRows() {
    findHorizontallyFilledRows();
    findVerticallyFilledRows();
    if (cellsToClear.isNotEmpty) {
      for (int counter in cellsToClear) {
        cellColorsList[counter] = emptyCellColor;
      }
      cellsToClear.clear();
      setState(() {});
    }
  }

  void findHorizontallyFilledRows() {
    List<int> tempList = <int>[];
    int matchedRow = -1;
    for (int row = 0; row < numOfColumns; row++) {
      tempList.clear();
      matchedRow = row;
      for (int col = 0; col < numOfColumns; col++) {
        if (cellColorsList[col + row * numOfColumns] == emptyCellColor) {
          matchedRow = -1;
          tempList.clear();
          break;
        }
        tempList.add(col + row * numOfColumns);
      }
      if (matchedRow >= 0) {
        cellsToClear.addAll(tempList);
      }
    }
  }

  void findVerticallyFilledRows() {
    List<int> tempList = <int>[];
    int matchedRow = -1;
    for (int row = 0; row < numOfColumns; row++) {
      tempList.clear();
      matchedRow = row;
      for (int col = row;
          col < numOfColumns * numOfColumns;
          col += numOfColumns) {
        if (cellColorsList[col] == emptyCellColor) {
          matchedRow = -1;
          tempList.clear();
          break;
        }
        tempList.add(col);
      }
      if (matchedRow >= 0) {
        cellsToClear.addAll(tempList);
      }
    }
  }

  void computeFillableGridBlockPositions(
      int numOfChildBlocks, BlockType blockType, Offset droppedBlockPosition) {
    Rect gridBlockRectangle;

    List<Rect> droppedBlockRects =
    getDroppedBlocks(blockType, droppedBlockPosition);

    for (Rect droppedBlockRect in droppedBlockRects) {
      double maxIntersection = 0.0;
      int matchedIndex = -1;
      if (cellsToFill.length == numOfChildBlocks) {
        break;
      }
      for (int col = 0; col < cells.length; col++) {
        gridBlockRectangle = Rect.fromLTWH(
            col % numOfColumns * blockUnitSizeWithPadding,
            col ~/ numOfColumns * blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize);

        if (droppedBlockRect.overlaps(gridBlockRectangle)) {
          Rect intersect = droppedBlockRect.intersect(gridBlockRectangle);
          double overlapArea = intersect.width * intersect.height;
          if (maxIntersection == 0.0 || overlapArea >= maxIntersection) {
            matchedIndex = col;
          }
          maxIntersection = max(overlapArea, maxIntersection);
        }
      }
      if (matchedIndex >= 0 &&
          cellColorsList[matchedIndex] == emptyCellColor &&
          !cellsToFill.contains(matchedIndex)) {
        cellsToFill.add(matchedIndex);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (numOfColumns == null) {
      double screenWidth = MediaQuery.of(context).size.width;
      numOfColumns = (screenWidth - margin * 4) ~/ blockUnitSizeWithPadding;
      for (int i = 0; i < numOfColumns * numOfColumns; i++) {
        cellColorsList.add(emptyCellColor);
      }
    }
    cells.clear();
    for (int row = 0; row < numOfColumns * numOfColumns; row++) {
      cells.add(Block(BlockType.SINGLE, cellColorsList[row]));
    }
    return _createGrid();
  }

  Widget _createGrid() {
    return Container(
        width: numOfColumns * blockUnitSizeWithPadding,
        height: numOfColumns * blockUnitSizeWithPadding,
        margin: EdgeInsets.all(margin),
        child: Table(
          children: _createGridCells(),
        ));
  }

  List<TableRow> _createGridCells() {
    List<TableRow> rows = <TableRow>[];
    for (int row = 0; row < numOfColumns; row++) {
      rows.add(TableRow(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: getRow(row),
        ),
      ]));
    }
    return rows;
  }

  List<Widget> getRow(int rowIdx) {
    List<Widget> row = <Widget>[];
    for (int col = 0; col < numOfColumns; col++) {
      row.add(cells[rowIdx * numOfColumns + col]);
    }
    return row;
  }

  int getUnitBlocksCount(BlockType blockType) {
    switch (blockType) {
      case BlockType.SINGLE:
        return 1;
      case BlockType.DOUBLE:
        return 2;
      case BlockType.LINE_HORIZONTAL:
        return 3;
      case BlockType.LINE_VERTICAL:
        return 3;
      case BlockType.SQUARE:
        return 4;
      case BlockType.TYPE_T:
        return 5;
      case BlockType.TYPE_L:
        return 4;
      case BlockType.MIRRORED_L:
        return 4;
      case BlockType.TYPE_Z:
        return 4;
      case BlockType.TYPE_S:
        return 4;
      default:
        return 0;
    }
  }

  List<Rect> getDroppedBlocks(
      BlockType blockType, Offset droppedBlockPosition) {
    List<Rect> droppedBlocks = <Rect>[];
    RenderBox getBox = context.findRenderObject();
    droppedBlockPosition =
        getBox.globalToLocal(droppedBlockPosition) - Offset(margin, margin);
    switch (blockType) {
      case BlockType.SINGLE:
        droppedBlocks.add(Rect.fromLTWH(droppedBlockPosition.dx,
            droppedBlockPosition.dy, blockUnitSize, blockUnitSize));
        break;
      case BlockType.DOUBLE:
        droppedBlocks.add(Rect.fromLTWH(droppedBlockPosition.dx,
            droppedBlockPosition.dy, blockUnitSize, blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy,
            blockUnitSize,
            blockUnitSize));
        break;
      case BlockType.LINE_HORIZONTAL:
        droppedBlocks.add(Rect.fromLTWH(droppedBlockPosition.dx,
            droppedBlockPosition.dy, blockUnitSize, blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + 2 * blockUnitSizeWithPadding,
            droppedBlockPosition.dy,
            blockUnitSize,
            blockUnitSize));
        break;
      case BlockType.LINE_VERTICAL:
        droppedBlocks.add(Rect.fromLTWH(droppedBlockPosition.dx,
            droppedBlockPosition.dy, blockUnitSize, blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx,
            droppedBlockPosition.dy + blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx,
            droppedBlockPosition.dy + 2 * blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        break;
      case BlockType.SQUARE:
        droppedBlocks.add(Rect.fromLTWH(droppedBlockPosition.dx,
            droppedBlockPosition.dy, blockUnitSize, blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx,
            droppedBlockPosition.dy + blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy + blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        break;
      case BlockType.TYPE_T:
        droppedBlocks.add(Rect.fromLTWH(droppedBlockPosition.dx,
            droppedBlockPosition.dy, blockUnitSize, blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + 2 * blockUnitSizeWithPadding,
            droppedBlockPosition.dy,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy + blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy + 2 * blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        break;
      case BlockType.TYPE_L:
        droppedBlocks.add(Rect.fromLTWH(droppedBlockPosition.dx,
            droppedBlockPosition.dy, blockUnitSize, blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx,
            droppedBlockPosition.dy + blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx,
            droppedBlockPosition.dy + 2 * blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy + 2 * blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        break;
      case BlockType.MIRRORED_L:
        droppedBlocks.add(Rect.fromLTWH(droppedBlockPosition.dx,
            droppedBlockPosition.dy, blockUnitSize, blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy + blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy + 2 * blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        break;
      case BlockType.TYPE_Z:
        droppedBlocks.add(Rect.fromLTWH(droppedBlockPosition.dx,
            droppedBlockPosition.dy, blockUnitSize, blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy + blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + 2 * blockUnitSizeWithPadding,
            droppedBlockPosition.dy + blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        break;
      case BlockType.TYPE_S:
        droppedBlocks.add(Rect.fromLTWH(droppedBlockPosition.dx + blockUnitSize,
            droppedBlockPosition.dy, blockUnitSize, blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + 2 * blockUnitSizeWithPadding,
            droppedBlockPosition.dy,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx,
            droppedBlockPosition.dy + blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        droppedBlocks.add(Rect.fromLTWH(
            droppedBlockPosition.dx + blockUnitSizeWithPadding,
            droppedBlockPosition.dy + blockUnitSizeWithPadding,
            blockUnitSize,
            blockUnitSize));
        break;
    }
    return droppedBlocks;
  }
}
