import 'package:blocks_puzzle/widgets/block.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';

class Box extends CustomPainter {
  final BlockType shape;
  final Color color;
  final double unitSize;
  final double padding;

  const Box(
      {@required this.shape,
      @required this.color,
      this.unitSize = 16.0,
      this.padding = 2.0});

  @override
  void paint(Canvas canvas, Size size) {
    var blockPaint = Paint()..color = color;
    switch (this.shape) {
      case BlockType.SINGLE:
        canvas.drawRect(
            Rect.fromLTWH(0.0, 0.0, unitSize, unitSize), blockPaint);
        break;
      case BlockType.DOUBLE:
        var block1 = Rect.fromLTWH(0.0, 0.0, unitSize, unitSize);
        var block2 = Rect.fromLTWH(
            block1.right + padding, block1.top, unitSize, unitSize);
        canvas.drawRect(block1, blockPaint);
        canvas.drawRect(block2, blockPaint);
        break;
      case BlockType.LINE_HORIZONTAL:
        var block1 = Rect.fromLTWH(0.0, 0.0, unitSize, unitSize);
        var block2 = Rect.fromLTWH(
            block1.right + padding, block1.top, unitSize, unitSize);
        var block3 = Rect.fromLTWH(
            block2.right + padding, block1.top, unitSize, unitSize);
        canvas.drawRect(block1, blockPaint);
        canvas.drawRect(block2, blockPaint);
        canvas.drawRect(block3, blockPaint);
        break;
      case BlockType.LINE_VERTICAL:
        var block1 = Rect.fromLTWH(0.0, 0.0, unitSize, unitSize);
        var block2 = Rect.fromLTWH(
            block1.left, block1.bottom + padding, unitSize, unitSize);
        var block3 = Rect.fromLTWH(
            block1.left, block2.bottom + padding, unitSize, unitSize);
        canvas.drawRect(block1, blockPaint);
        canvas.drawRect(block2, blockPaint);
        canvas.drawRect(block3, blockPaint);
        break;
      case BlockType.SQUARE:
        var block1 = Rect.fromLTWH(0.0, 0.0, unitSize, unitSize);
        var block2 = Rect.fromLTWH(
            block1.right + padding, block1.top, unitSize, unitSize);
        var block3 = Rect.fromLTWH(
            block1.left, block1.bottom + padding, unitSize, unitSize);
        var block4 = Rect.fromLTWH(
            block3.right + padding, block3.top, unitSize, unitSize);
        canvas.drawRect(block1, blockPaint);
        canvas.drawRect(block2, blockPaint);
        canvas.drawRect(block3, blockPaint);
        canvas.drawRect(block4, blockPaint);
        break;
      case BlockType.TYPE_T:
        var block1 = Rect.fromLTWH(0.0, 0.0, unitSize, unitSize);
        var block2 = Rect.fromLTWH(
            block1.right + padding, block1.top, unitSize, unitSize);
        var block3 = Rect.fromLTWH(
            block2.right + padding, block2.top, unitSize, unitSize);
        var block4 = Rect.fromLTWH(
            block2.left, block2.bottom + padding, unitSize, unitSize);
        var block5 = Rect.fromLTWH(
            block2.left, block4.bottom + padding, unitSize, unitSize);
        canvas.drawRect(block1, blockPaint);
        canvas.drawRect(block2, blockPaint);
        canvas.drawRect(block3, blockPaint);
        canvas.drawRect(block4, blockPaint);
        canvas.drawRect(block5, blockPaint);
        break;
      case BlockType.TYPE_L:
        var block1 = Rect.fromLTWH(0.0, 0.0, unitSize, unitSize);
        var block2 = Rect.fromLTWH(
            block1.left, block1.bottom + padding, unitSize, unitSize);
        var block3 = Rect.fromLTWH(
            block1.left, block2.bottom + padding, unitSize, unitSize);
        var block4 = Rect.fromLTWH(
            block3.right + padding, block3.top, unitSize, unitSize);
        canvas.drawRect(block1, blockPaint);
        canvas.drawRect(block2, blockPaint);
        canvas.drawRect(block3, blockPaint);
        canvas.drawRect(block4, blockPaint);
        break;
      case BlockType.MIRRORED_L:
        var block1 = Rect.fromLTWH(0.0, 0.0, unitSize, unitSize);
        var block2 = Rect.fromLTWH(
            block1.right + padding, block1.top, unitSize, unitSize);
        var block4 = Rect.fromLTWH(
            block2.left, block2.bottom + padding, unitSize, unitSize);
        var block5 = Rect.fromLTWH(
            block4.left, block4.bottom + padding, unitSize, unitSize);
        canvas.drawRect(block1, blockPaint);
        canvas.drawRect(block5, blockPaint);
        canvas.drawRect(block4, blockPaint);
        canvas.drawRect(block2, blockPaint);
        break;
      case BlockType.TYPE_Z:
        var block1 = Rect.fromLTWH(0.0, 0.0, unitSize, unitSize);
        var block2 = Rect.fromLTWH(
            block1.right + padding, block1.top, unitSize, unitSize);
        var block3 = Rect.fromLTWH(
            block2.left, block2.bottom + padding, unitSize, unitSize);
        var block4 = Rect.fromLTWH(
            block3.right + padding, block3.top, unitSize, unitSize);
        canvas.drawRect(block1, blockPaint);
        canvas.drawRect(block2, blockPaint);
        canvas.drawRect(block3, blockPaint);
        canvas.drawRect(block4, blockPaint);
        break;
      case BlockType.TYPE_S:
        var block1 = Rect.fromLTWH(0.0, 0.0, unitSize, unitSize);
        var block2 =
            Rect.fromLTWH(block1.right + padding, 0.0, unitSize, unitSize);
        var block3 = Rect.fromLTWH(
            block1.left, block1.bottom + padding, unitSize, unitSize);
        var block4 = Rect.fromLTWH(block3.left - unitSize - padding,
            block2.bottom + padding, unitSize, unitSize);
        canvas.drawRect(block1, blockPaint);
        canvas.drawRect(block2, blockPaint);
        canvas.drawRect(block3, blockPaint);
        canvas.drawRect(block4, blockPaint);
        break;
    }
  }

  @override
  bool shouldRepaint(Box box) {
    return shape != box.shape;
  }
}
